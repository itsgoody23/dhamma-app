#!/usr/bin/env python3
"""
Dhamma App — Editions ETL Pipeline
Parses pre-built HTML from suttacentral/editions into SQLite content packs.

This is a cleaner alternative to the bilara JSON parser. The editions repo
contains complete, formatted HTML books (CC0 licensed) that we split into
individual suttas by their <article> tags.

Usage:
    python editions_parser.py --output-dir ./output
    python editions_parser.py --output-dir ./output --editions-path ./editions
    python editions_parser.py --output-dir ./output --skip-clone

Source: https://github.com/suttacentral/editions
"""

import json
import gzip
import hashlib
import logging
import re
import shutil
import sqlite3
import subprocess
from datetime import datetime
from pathlib import Path

import click
from bs4 import BeautifulSoup, Tag
from tqdm import tqdm

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

# ── Schema (same as etl_pipeline.py) ─────────────────────────────────────────

DDL = """
PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

CREATE TABLE IF NOT EXISTS texts (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    uid           TEXT NOT NULL UNIQUE,
    title         TEXT NOT NULL,
    collection    TEXT,
    nikaya        TEXT NOT NULL,
    book          TEXT,
    chapter       TEXT,
    language      TEXT NOT NULL,
    translator    TEXT,
    source        TEXT,
    content_html  TEXT,
    content_plain TEXT
);

CREATE TABLE IF NOT EXISTS translations (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    text_uid      TEXT NOT NULL,
    language      TEXT NOT NULL,
    translator    TEXT,
    source        TEXT,
    content_html  TEXT,
    content_plain TEXT,
    UNIQUE(text_uid, language, translator)
);

CREATE TABLE IF NOT EXISTS translators (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    tradition  TEXT,
    bio        TEXT,
    source_url TEXT
);

CREATE INDEX IF NOT EXISTS idx_texts_nikaya      ON texts(nikaya);
CREATE INDEX IF NOT EXISTS idx_texts_language    ON texts(language);
CREATE INDEX IF NOT EXISTS idx_texts_uid         ON texts(uid);
CREATE INDEX IF NOT EXISTS idx_texts_nikaya_lang ON texts(nikaya, language);
"""

FTS5_DDL = """
CREATE VIRTUAL TABLE IF NOT EXISTS texts_fts USING fts5(
    uid           UNINDEXED,
    title,
    content_plain,
    content='texts',
    content_rowid='id',
    tokenize='unicode61 remove_diacritics 1'
);

CREATE TRIGGER IF NOT EXISTS texts_ai AFTER INSERT ON texts BEGIN
    INSERT INTO texts_fts(rowid, uid, title, content_plain)
    VALUES (new.id, new.uid, new.title, new.content_plain);
END;

CREATE TRIGGER IF NOT EXISTS texts_ad AFTER DELETE ON texts BEGIN
    INSERT INTO texts_fts(texts_fts, rowid, uid, title, content_plain)
    VALUES ('delete', old.id, old.uid, old.title, old.content_plain);
END;
"""

# Maps collection abbreviation → nikaya code for our DB
COLLECTION_TO_NIKAYA = {
    "dn": "dn",
    "mn": "mn",
    "sn": "sn",
    "an": "an",
    # Khuddaka texts
    "dhp": "kn",
    "ud": "kn",
    "iti": "kn",
    "snp": "kn",
    "thag": "kn",
    "thig": "kn",
}

NIKAYA_LABELS = {
    "dn": "Dīgha Nikāya",
    "mn": "Majjhima Nikāya",
    "sn": "Saṃyutta Nikāya",
    "an": "Aṅguttara Nikāya",
    "kn": "Khuddaka Nikāya",
}

LANG_LABELS = {
    "en": "English",
    "pli": "Pāli",
    "de": "Deutsch",
    "fr": "Français",
}

EDITIONS_REPO = "https://github.com/suttacentral/editions.git"


# ── Clone / locate editions ──────────────────────────────────────────────────


def ensure_editions(editions_path: Path, skip_clone: bool = False) -> Path:
    """Clone or locate the editions repo."""
    if editions_path.exists() and (editions_path / "en").exists():
        log.info(f"Using existing editions at {editions_path}")
        return editions_path

    if skip_clone:
        raise click.UsageError(
            f"Editions not found at {editions_path} and --skip-clone is set"
        )

    log.info(f"Cloning suttacentral/editions to {editions_path} ...")
    subprocess.run(
        ["git", "clone", "--depth", "1", EDITIONS_REPO, str(editions_path)],
        check=True,
    )
    return editions_path


# ── HTML parser ──────────────────────────────────────────────────────────────


def parse_edition_html(html_path: Path, collection: str, translator: str) -> list[dict]:
    """
    Parse a single edition HTML file into individual sutta rows.

    Each sutta is an <article id="XX"> inside the mainmatter section.
    """
    nikaya = COLLECTION_TO_NIKAYA.get(collection, collection)

    with open(html_path, encoding="utf-8") as f:
        soup = BeautifulSoup(f, "html.parser")

    rows = []
    articles = soup.find_all("article")

    for article in articles:
        aid = article.get("id", "")
        # Only process articles whose id matches collection prefix (e.g. dn1, mn10, sn1.1)
        if not aid or not _is_sutta_article(aid, collection):
            continue

        uid = aid  # e.g. "dn1", "mn10", "sn1.1"

        # Extract title from first heading
        heading = article.find(["h1", "h2", "h3", "h4"])
        if heading:
            title = _clean_title(heading, uid)
        else:
            title = uid.upper()

        # Get the sutta HTML content (the article inner HTML)
        content_html = _extract_sutta_html(article)
        content_plain = article.get_text(separator=" ", strip=True)

        # Determine book/chapter from parent sections
        book, chapter = _get_book_chapter(article)

        rows.append(
            {
                "uid": uid,
                "title": title,
                "collection": collection,
                "nikaya": nikaya,
                "book": book,
                "chapter": chapter,
                "language": "en",
                "translator": translator,
                "source": "sc",
                "content_html": content_html,
                "content_plain": content_plain,
            }
        )

    return rows


def _is_sutta_article(article_id: str, collection: str) -> bool:
    """Check if an article ID looks like a sutta (e.g. dn1, mn10, sn1.1, dhp1-20)."""
    # Match: collection prefix + digit
    pattern = rf"^{re.escape(collection)}\d"
    return bool(re.match(pattern, article_id))


def _clean_title(heading: Tag, uid: str) -> str:
    """Extract a clean title from the heading element.

    Edition headings contain: "DN 1 The Divine Net Brahmajālasutta"
    We want: "The Divine Net" (English title only).
    """
    # Get all text parts
    full_text = heading.get_text(separator="|", strip=True)
    parts = [p.strip() for p in full_text.split("|") if p.strip()]

    # Try to find the English title (skip numbering and Pali title)
    # Pattern: parts[0] = "DN 1", parts[1] = "The Divine Net", parts[2] = "Brahmajālasutta"
    if len(parts) >= 3:
        return parts[1]  # English title
    elif len(parts) == 2:
        # Could be "DN 1" + "Title" or "Title" + "PaliTitle"
        if re.match(r"^[A-Z]{2,4}\s+\d", parts[0]):
            return parts[1]
        return parts[0]
    elif parts:
        # Single part — remove leading "XX N " prefix
        text = parts[0]
        text = re.sub(r"^[A-Z]{2,4}\s+[\d.:\-]+\s*", "", text)
        return text or parts[0]
    return uid


def _extract_sutta_html(article: Tag) -> str:
    """Extract the inner HTML of a sutta article, cleaned up."""
    # Remove the heading (already captured as title)
    article_copy = BeautifulSoup(str(article), "html.parser").find("article")
    heading = article_copy.find(["h1", "h2", "h3", "h4"])
    if heading:
        heading.decompose()

    # Remove any scripts/styles
    for tag in article_copy(["script", "style"]):
        tag.decompose()

    # Return inner HTML
    return "".join(str(child) for child in article_copy.children)


def _get_book_chapter(article: Tag) -> tuple[str | None, str | None]:
    """Walk up from article to find parent section headings for book/chapter."""
    book = None
    chapter = None

    parent = article.parent
    while parent:
        if isinstance(parent, Tag) and parent.name in ("section", "div"):
            h = parent.find(["h1", "h2", "h3"], recursive=False)
            if h:
                text = h.get_text(strip=True)
                if not book:
                    book = text
                elif not chapter:
                    chapter = text
        parent = parent.parent

    return book, chapter


# ── Database helpers ─────────────────────────────────────────────────────────


def create_database(db_path: Path) -> sqlite3.Connection:
    conn = sqlite3.connect(str(db_path))
    conn.executescript(DDL)
    conn.executescript(FTS5_DDL)
    conn.commit()
    return conn


def insert_rows(conn: sqlite3.Connection, rows: list[dict], batch_size: int = 500) -> int:
    inserted = 0
    sql = """
        INSERT OR IGNORE INTO texts
            (uid, title, collection, nikaya, book, chapter, language, translator, source, content_html, content_plain)
        VALUES
            (:uid, :title, :collection, :nikaya, :book, :chapter, :language, :translator, :source, :content_html, :content_plain)
    """
    for i in range(0, len(rows), batch_size):
        batch = rows[i : i + batch_size]
        conn.executemany(sql, batch)
        conn.commit()
        inserted += len(batch)
    return inserted


def split_by_nikaya(source_db: Path, nikaya: str, output_dir: Path) -> Path:
    pack_path = output_dir / f"{nikaya}_pack.db"
    src = sqlite3.connect(str(source_db))
    dst = sqlite3.connect(str(pack_path))
    dst.executescript(DDL)
    dst.executescript(FTS5_DDL)
    dst.commit()

    rows = src.execute(
        "SELECT uid, title, collection, nikaya, book, chapter, language, translator, source, content_html, content_plain "
        "FROM texts WHERE nikaya = ?",
        (nikaya,),
    ).fetchall()

    dst.executemany(
        "INSERT OR IGNORE INTO texts (uid, title, collection, nikaya, book, chapter, language, translator, source, content_html, content_plain) "
        "VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        rows,
    )
    dst.commit()
    src.close()
    dst.execute("PRAGMA optimize")
    dst.commit()
    dst.close()
    return pack_path


def compress_db(db_path: Path) -> Path:
    gz_path = db_path.with_suffix(".db.gz")
    with open(db_path, "rb") as f_in:
        with gzip.open(str(gz_path), "wb", compresslevel=9) as f_out:
            shutil.copyfileobj(f_in, f_out)
    return gz_path


def sha256_of(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


# ── CLI ──────────────────────────────────────────────────────────────────────


@click.command()
@click.option(
    "--editions-path",
    default="./editions",
    show_default=True,
    help="Path to local suttacentral/editions clone",
)
@click.option(
    "--output-dir",
    default="./output",
    show_default=True,
    help="Directory for output files",
)
@click.option(
    "--packs",
    default="dn,mn,sn,an,kn",
    show_default=True,
    help="Comma-separated nikayas to package",
)
@click.option(
    "--cdn-base-url",
    default="https://cdn.dhamma.app/packs",
    show_default=True,
)
@click.option("--skip-clone", is_flag=True, help="Don't clone if editions dir missing")
def main(editions_path, output_dir, packs, cdn_base_url, skip_clone):
    editions = ensure_editions(Path(editions_path), skip_clone)
    output = Path(output_dir)
    output.mkdir(parents=True, exist_ok=True)
    version = datetime.now().strftime("%Y.%m.%d")
    nikaya_list = [n.strip() for n in packs.split(",")]

    # Discover all HTML editions
    en_dir = editions / "en"
    all_rows = []

    for translator_dir in sorted(en_dir.iterdir()):
        if not translator_dir.is_dir():
            continue
        translator = translator_dir.name

        for collection_dir in sorted(translator_dir.iterdir()):
            if not collection_dir.is_dir():
                continue
            collection = collection_dir.name
            html_dir = collection_dir / "html"
            if not html_dir.exists():
                continue

            html_files = list(html_dir.glob("*.html"))
            if not html_files:
                continue

            # Use the most recent HTML file
            html_file = sorted(html_files)[-1]
            log.info(f"Parsing {collection}/{html_file.name} (translator: {translator})")

            rows = parse_edition_html(html_file, collection, translator)
            log.info(f"  → {len(rows)} suttas")
            all_rows.extend(rows)

    if not all_rows:
        log.error("No suttas extracted")
        return

    log.info(f"Total suttas extracted: {len(all_rows):,}")

    # Write full combined DB
    full_db_path = output / "dhamma_full.db"
    conn = create_database(full_db_path)
    inserted = insert_rows(conn, all_rows)
    conn.execute("PRAGMA optimize")
    conn.commit()
    conn.close()
    log.info(f"Inserted {inserted:,} rows into {full_db_path}")

    # Split into per-nikaya packs
    packs_meta = []
    for nikaya in nikaya_list:
        src = sqlite3.connect(str(full_db_path))
        count = src.execute(
            "SELECT COUNT(*) FROM texts WHERE nikaya = ?", (nikaya,)
        ).fetchone()[0]
        src.close()

        if count == 0:
            log.warning(f"No rows for nikaya={nikaya}, skipping")
            continue

        log.info(f"Building pack: {nikaya} ({count} suttas)")
        pack_db = split_by_nikaya(full_db_path, nikaya, output)
        gz_path = compress_db(pack_db)
        pack_db.unlink()

        size_mb = round(gz_path.stat().st_size / 1_048_576, 2)
        size_conn = sqlite3.connect(str(full_db_path))
        original_size = size_conn.execute(
            "SELECT SUM(LENGTH(content_html)) + SUM(LENGTH(content_plain)) FROM texts WHERE nikaya = ?",
            (nikaya,),
        ).fetchone()[0] or 0
        size_conn.close()
        original_size_mb = round(original_size / 1_048_576, 2)

        packs_meta.append(
            {
                "pack_id": f"{nikaya}_en",
                "pack_name": f"{NIKAYA_LABELS.get(nikaya, nikaya.upper())} — English",
                "language": "en",
                "nikaya": nikaya,
                "size_mb": original_size_mb,
                "compressed_size_mb": size_mb,
                "sutta_count": count,
                "download_url": f"{cdn_base_url}/{nikaya}_pack.db.gz",
                "checksum_sha256": sha256_of(gz_path),
                "version": version,
            }
        )

    # Write manifest
    manifest = {"version": version, "packs": packs_meta}
    manifest_path = output / "pack_manifest.json"
    manifest_path.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    log.info(f"Manifest written to {manifest_path}")

    # Clean up
    full_db_path.unlink()
    log.info(f"Done! {len(all_rows):,} suttas across {len(packs_meta)} packs.")


if __name__ == "__main__":
    main()
