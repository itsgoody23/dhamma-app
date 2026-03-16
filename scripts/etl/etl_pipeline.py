#!/usr/bin/env python3
"""
Dhamma App — ETL Pipeline
Converts SuttaCentral sc-data JSON/HTML into compressed SQLite content packs.

Usage:
    python etl_pipeline.py \
        --sc-data-path /path/to/sc-data \
        --output-dir ./output \
        --languages en,pli \
        --packs dn,mn,sn,an,kn

    python etl_pipeline.py --seed  # Produce seed.db only (daily suttas)
"""

import json
import os
import re
import gzip
import shutil
import sqlite3
import hashlib
import logging
from pathlib import Path
from datetime import datetime

import click
from bs4 import BeautifulSoup
from tqdm import tqdm

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
log = logging.getLogger(__name__)

# ── Schema ────────────────────────────────────────────────────────────────────

DDL = """
PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

CREATE TABLE IF NOT EXISTS texts (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    uid           TEXT NOT NULL,
    title         TEXT NOT NULL,
    collection    TEXT,
    nikaya        TEXT NOT NULL,
    book          TEXT,
    chapter       TEXT,
    language      TEXT NOT NULL,
    translator    TEXT,
    source        TEXT,
    content_html  TEXT,
    content_plain TEXT,
    UNIQUE(uid, language)
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

SEED_DDL = """
PRAGMA journal_mode=WAL;

CREATE TABLE IF NOT EXISTS daily_suttas (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    day_of_year  INTEGER NOT NULL UNIQUE,
    uid          TEXT NOT NULL,
    title        TEXT NOT NULL,
    verse_excerpt TEXT,
    nikaya       TEXT NOT NULL
);
"""

# ── HTML helpers ──────────────────────────────────────────────────────────────

def sanitise_html(raw_html: str) -> str:
    """Strip scripts/styles; keep semantic tags."""
    soup = BeautifulSoup(raw_html, "html.parser")
    for tag in soup(["script", "style", "meta", "link"]):
        tag.decompose()
    return str(soup.body or soup)


def html_to_plain(html: str) -> str:
    """Strip all HTML tags → plain text for FTS5 indexing."""
    soup = BeautifulSoup(html, "html.parser")
    return soup.get_text(separator=" ", strip=True)


# ── SuttaCentral parser ───────────────────────────────────────────────────────

def load_structure(sc_data_path: Path) -> dict:
    """
    Parse sc-data/structure/ to build uid → metadata mapping.
    Returns: {uid: {nikaya, collection, book, chapter, title}}
    """
    structure = {}
    structure_dir = sc_data_path / "structure"

    if not structure_dir.exists():
        log.warning(f"No structure dir at {structure_dir}")
        return structure

    for json_file in structure_dir.glob("*.json"):
        try:
            data = json.loads(json_file.read_text(encoding="utf-8"))
            _flatten_structure(data, structure, nikaya=json_file.stem)
        except Exception as e:
            log.warning(f"Could not parse {json_file}: {e}")

    log.info(f"Loaded {len(structure):,} UIDs from structure")
    return structure


def _flatten_structure(node, result: dict, nikaya: str, book: str = None, chapter: str = None):
    """Recursively flatten the nested sc-data structure JSON."""
    if isinstance(node, list):
        for item in node:
            _flatten_structure(item, result, nikaya, book, chapter)
        return

    if not isinstance(node, dict):
        return

    uid = node.get("uid") or node.get("id")
    title = node.get("name") or node.get("title") or uid or ""
    node_type = node.get("node_type", "")

    if uid and node_type in ("leaf", "sutta", "text", ""):
        result[uid] = {
            "nikaya": nikaya,
            "collection": node.get("collection"),
            "book": book,
            "chapter": chapter,
            "title": title,
        }

    # Recurse into children
    new_book = title if node_type in ("book", "division") else book
    new_chapter = title if node_type == "chapter" else chapter
    for child in node.get("children", []):
        _flatten_structure(child, result, nikaya, new_book, new_chapter)


def parse_html_texts(sc_data_path: Path, languages: list[str], structure: dict) -> list[dict]:
    """
    Parse bilara-data JSON translations from sc_bilara_data/translation/{lang}/{translator}/sutta/
    Merges HTML templates from sc_bilara_data/html/ with translated segments.
    """
    bilara_root = sc_data_path / "sc_bilara_data"
    translation_root = bilara_root / "translation"
    html_template_root = bilara_root / "html"
    rows = []

    for lang in languages:
        lang_dir = translation_root / lang
        if not lang_dir.exists():
            log.warning(f"No sc_bilara_data/translation/{lang} directory")
            continue

        # Each subdirectory is a translator
        for translator_dir in sorted(lang_dir.iterdir()):
            if not translator_dir.is_dir():
                continue
            translator = translator_dir.name
            sutta_dir = translator_dir / "sutta"
            if not sutta_dir.exists():
                continue

            trans_files = list(sutta_dir.rglob("*.json"))
            log.info(f"Processing {len(trans_files):,} bilara files for lang={lang} translator={translator}")

            for trans_file in tqdm(trans_files, desc=f"{lang}/{translator}", unit="file"):
                try:
                    row = _parse_bilara_file(
                        trans_file, lang, translator, sutta_dir,
                        html_template_root, structure,
                    )
                    if row:
                        rows.append(row)
                except Exception as e:
                    log.debug(f"Skip {trans_file}: {e}")

    log.info(f"Total rows extracted: {len(rows):,}")
    return rows


def _parse_bilara_file(
    trans_file: Path,
    lang: str,
    translator: str,
    sutta_dir: Path,
    html_template_root: Path,
    structure: dict,
) -> dict | None:
    """
    Build a sutta row from a bilara translation JSON file.
    File naming: {uid}_translation-{lang}-{translator}.json
    """
    # Extract UID from filename: mn1_translation-en-sujato.json → mn1
    stem = trans_file.stem  # mn1_translation-en-sujato
    uid = stem.split("_")[0]

    # Derive nikaya from path: sutta/mn/mn1_... → mn
    rel = trans_file.relative_to(sutta_dir)
    nikaya = rel.parts[0] if len(rel.parts) > 1 else uid[:2]

    # Load translation segments
    trans_segments: dict = json.loads(trans_file.read_text(encoding="utf-8"))
    if not trans_segments:
        return None

    # Load HTML template if available
    # Template path mirrors translation path but under html/pli/ms/
    html_template_path = html_template_root / "pli" / "ms" / "sutta" / nikaya / f"{uid}_html.json"
    html_segments: dict = {}
    if html_template_path.exists():
        html_segments = json.loads(html_template_path.read_text(encoding="utf-8"))

    # Merge: fill {} placeholders in HTML template with translated text
    content_html = _merge_bilara(html_segments, trans_segments, uid)
    content_plain = html_to_plain(content_html) if content_html else " ".join(
        v for v in trans_segments.values() if v
    )

    # Title: first two segments are typically division name + sutta title
    title = _extract_bilara_title(trans_segments, uid)

    meta = structure.get(uid, {})

    return {
        "uid": uid,
        "title": title,
        "collection": meta.get("collection"),
        "nikaya": nikaya,
        "book": meta.get("book"),
        "chapter": meta.get("chapter"),
        "language": lang,
        "translator": translator,
        "source": "sc",
        "content_html": content_html or content_plain,
        "content_plain": content_plain,
    }


def _merge_bilara(html_segments: dict, trans_segments: dict, uid: str) -> str:
    """
    Merge bilara HTML template with translation segments.
    Each HTML value contains {} where translated text is inserted.
    """
    if not html_segments:
        # No template: wrap paragraphs in <p> tags
        parts = []
        current_para: list[str] = []
        for seg_id, text in trans_segments.items():
            if not text:
                continue
            # New paragraph on segment number boundary (e.g. mn1:1.1 → mn1:2.1)
            parts.append(text.strip())
        return "<p>" + "</p><p>".join(parts) + "</p>" if parts else ""

    result_parts = []
    for seg_id, html_template in html_segments.items():
        text = trans_segments.get(seg_id, "")
        # Count {} placeholders
        placeholder_count = html_template.count("{}")
        if placeholder_count == 1:
            result_parts.append(html_template.replace("{}", text, 1))
        elif placeholder_count == 0:
            result_parts.append(html_template)
        else:
            # Multiple placeholders — fill first with text, rest with ""
            filled = html_template.replace("{}", text, 1).replace("{}", "")
            result_parts.append(filled)

    return "".join(result_parts)


def _extract_bilara_title(trans_segments: dict, uid: str) -> str:
    """Extract sutta title from bilara segments (typically the second segment value)."""
    values = [v.strip() for v in trans_segments.values() if v and v.strip()]
    if len(values) >= 2:
        # First value is usually collection name (e.g. "Middle Discourses 1")
        # Second is the sutta title
        return values[1]
    elif values:
        return values[0]
    return uid


def parse_root_texts(sc_data_path: Path, structure: dict) -> list[dict]:
    """
    Parse Pāli root texts from sc_bilara_data/root/pli/ms/sutta/.
    Same segment-keyed JSON format as translations.
    """
    bilara_root = sc_data_path / "sc_bilara_data"
    root_dir = bilara_root / "root" / "pli" / "ms" / "sutta"
    html_template_root = bilara_root / "html"
    rows = []

    if not root_dir.exists():
        log.warning(f"No Pāli root text directory at {root_dir}")
        return rows

    root_files = list(root_dir.rglob("*.json"))
    log.info(f"Processing {len(root_files):,} Pāli root text files")

    for root_file in tqdm(root_files, desc="pli/ms", unit="file"):
        try:
            # Extract UID from filename: mn1_root-pli-ms.json → mn1
            stem = root_file.stem
            uid = stem.split("_")[0]

            # Derive nikaya from path
            rel = root_file.relative_to(root_dir)
            nikaya = rel.parts[0] if len(rel.parts) > 1 else uid[:2]

            # Load root text segments
            segments: dict = json.loads(root_file.read_text(encoding="utf-8"))
            if not segments:
                continue

            # Load HTML template
            html_template_path = html_template_root / "pli" / "ms" / "sutta" / nikaya / f"{uid}_html.json"
            html_segments: dict = {}
            if html_template_path.exists():
                html_segments = json.loads(html_template_path.read_text(encoding="utf-8"))

            content_html = _merge_bilara(html_segments, segments, uid)
            content_plain = html_to_plain(content_html) if content_html else " ".join(
                v for v in segments.values() if v
            )

            title = _extract_bilara_title(segments, uid)
            meta = structure.get(uid, {})

            rows.append({
                "uid": uid,
                "title": title,
                "collection": meta.get("collection"),
                "nikaya": nikaya,
                "book": meta.get("book"),
                "chapter": meta.get("chapter"),
                "language": "pli",
                "translator": "ms",
                "source": "sc",
                "content_html": content_html or content_plain,
                "content_plain": content_plain,
            })
        except Exception as e:
            log.debug(f"Skip {root_file}: {e}")

    log.info(f"Pāli root texts extracted: {len(rows):,}")
    return rows


# ── Database helpers ──────────────────────────────────────────────────────────

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


def finalise_database(conn: sqlite3.Connection):
    """Optimise and compact."""
    conn.execute("PRAGMA optimize")
    conn.commit()
    conn.close()


def split_by_nikaya(source_db_path: Path, nikaya: str, output_dir: Path, language: str | None = None) -> Path:
    """Create a per-nikaya (optionally per-language) pack DB by copying matching rows from the full DB."""
    if language:
        pack_path = output_dir / f"{nikaya}_{language}_pack.db"
    else:
        pack_path = output_dir / f"{nikaya}_pack.db"

    src = sqlite3.connect(str(source_db_path))
    dst = sqlite3.connect(str(pack_path))
    dst.executescript(DDL)
    dst.executescript(FTS5_DDL)
    dst.commit()

    if language:
        rows = src.execute(
            "SELECT uid, title, collection, nikaya, book, chapter, language, translator, source, content_html, content_plain FROM texts WHERE nikaya = ? AND language = ?",
            (nikaya, language),
        ).fetchall()
    else:
        rows = src.execute(
            "SELECT uid, title, collection, nikaya, book, chapter, language, translator, source, content_html, content_plain FROM texts WHERE nikaya = ?",
            (nikaya,),
        ).fetchall()

    dst.executemany(
        "INSERT OR IGNORE INTO texts (uid, title, collection, nikaya, book, chapter, language, translator, source, content_html, content_plain) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
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


def build_manifest(packs_meta: list[dict], version: str) -> dict:
    return {"version": version, "packs": packs_meta}


# ── Seed DB ───────────────────────────────────────────────────────────────────

def _load_seed_suttas() -> list[tuple]:
    """Load seed suttas from seed_suttas_365.json if available, else use built-in fallback."""
    seed_json = Path(__file__).resolve().parent / "output" / "seed_suttas_365.json"
    if seed_json.exists():
        data = json.loads(seed_json.read_text(encoding="utf-8"))
        return [
            (s["day_of_year"], s["uid"], s["title"], s["verse_excerpt"], s["nikaya"])
            for s in data
        ]
    # Fallback: 10 well-known suttas for dev/test
    return [
        (1, "dhp1-20", "The Pairs (Yamaka-vagga)", "Mind is the forerunner of all actions.", "kn"),
        (2, "mn10", "The Discourse on the Foundations of Mindfulness", "There is one way, monks, for the purification of beings.", "mn"),
        (3, "sn56.11", "Setting the Wheel of Dhamma in Motion", "These two extremes should not be practised.", "sn"),
        (4, "dn22", "The Great Discourse on the Foundations of Mindfulness", "This is the direct path for the purification of beings.", "dn"),
        (5, "an4.159", "With Metta", "May all beings be happy and secure.", "an"),
        (6, "dhp183-220", "The Buddha (Buddha-vagga)", "Not to do evil, to cultivate good.", "kn"),
        (7, "mn118", "Mindfulness of Breathing", "Mindfulness of breathing, developed and cultivated, is of great fruit.", "mn"),
        (8, "sn22.59", "Not Self (Anattalakkhaṇa Sutta)", "Form is not self. Were form self, then form would not lead to affliction.", "sn"),
        (9, "dn2", "The Fruits of the Contemplative Life", "Just as if there were a lake in a mountain glen.", "dn"),
        (10, "an8.53", "On Gifts", "There are these eight reasons for giving a gift.", "an"),
    ]


def create_seed_db(output_dir: Path) -> Path:
    seed_path = output_dir / "dhamma_seed.db"
    seed_suttas = _load_seed_suttas()
    conn = sqlite3.connect(str(seed_path))
    conn.executescript(SEED_DDL)
    conn.executemany(
        "INSERT OR IGNORE INTO daily_suttas (day_of_year, uid, title, verse_excerpt, nikaya) VALUES (?,?,?,?,?)",
        seed_suttas,
    )
    conn.commit()
    conn.close()
    log.info(f"Seed DB written to {seed_path} ({len(seed_suttas)} entries)")
    return seed_path


# ── CLI ───────────────────────────────────────────────────────────────────────

@click.command()
@click.option("--sc-data-path", type=click.Path(exists=True), help="Path to local sc-data clone")
@click.option("--output-dir", default="./output", show_default=True, help="Directory for output files")
@click.option("--languages", default="en", show_default=True, help="Comma-separated language codes")
@click.option("--packs", default="dn,mn,sn,an,kn", show_default=True, help="Comma-separated nikayas to package")
@click.option("--cdn-base-url", default="https://cdn.dhamma.app/packs", show_default=True)
@click.option("--seed", is_flag=True, help="Only produce the seed DB (daily suttas)")
def main(sc_data_path, output_dir, languages, packs, cdn_base_url, seed):
    output = Path(output_dir)
    output.mkdir(parents=True, exist_ok=True)
    version = datetime.now().strftime("%Y.%m.%d")

    # Always produce the seed DB
    seed_path = create_seed_db(output)

    if seed:
        log.info("Seed-only mode complete.")
        return

    if not sc_data_path:
        raise click.UsageError("--sc-data-path is required unless --seed is used")

    sc_data = Path(sc_data_path)
    lang_list = [l.strip() for l in languages.split(",")]
    nikaya_list = [n.strip() for n in packs.split(",")]

    # Build structure index
    structure = load_structure(sc_data)

    # Parse translation texts (en, de, etc.)
    translation_langs = [l for l in lang_list if l != "pli"]
    all_rows = parse_html_texts(sc_data, translation_langs, structure) if translation_langs else []

    # Parse Pāli root texts if requested
    if "pli" in lang_list:
        pli_rows = parse_root_texts(sc_data, structure)
        all_rows.extend(pli_rows)

    if not all_rows:
        log.error("No rows extracted — check sc-data path and language codes")
        return

    # Write full combined DB (used as source for splitting)
    full_db_path = output / "dhamma_full.db"
    log.info(f"Writing full DB to {full_db_path}")
    conn = create_database(full_db_path)
    inserted = insert_rows(conn, all_rows)
    finalise_database(conn)
    log.info(f"Inserted {inserted:,} rows")

    # Split into per-nikaya per-language packs, compress, build manifest
    packs_meta = []
    for nikaya in nikaya_list:
        for lang in lang_list:
            log.info(f"Building pack: {nikaya}_{lang}")
            pack_db = split_by_nikaya(full_db_path, nikaya, output, language=lang)

            # Count suttas in pack before compressing
            src = sqlite3.connect(str(pack_db))
            count = src.execute("SELECT COUNT(*) FROM texts").fetchone()[0]
            original_size_mb = round(pack_db.stat().st_size / 1_048_576, 2)
            src.close()

            if count == 0:
                log.warning(f"No texts for {nikaya}_{lang}, skipping")
                pack_db.unlink()
                continue

            gz_path = compress_db(pack_db)
            pack_db.unlink()  # Remove uncompressed pack

            size_mb = round(gz_path.stat().st_size / 1_048_576, 2)
            checksum = sha256_of(gz_path)
            filename = gz_path.name

            packs_meta.append({
                "pack_id": f"{nikaya}_{lang}",
                "pack_name": _nikaya_label(nikaya, lang),
                "language": lang,
                "nikaya": nikaya,
                "size_mb": original_size_mb,
                "compressed_size_mb": size_mb,
                "sutta_count": count,
                "download_url": f"{cdn_base_url}/{filename}",
                "checksum_sha256": checksum,
                "version": version,
            })

    # Write manifest
    manifest = build_manifest(packs_meta, version)
    manifest_path = output / "pack_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    log.info(f"Manifest written to {manifest_path}")

    # Clean up full DB
    full_db_path.unlink()
    log.info("ETL complete.")


def _nikaya_label(nikaya: str, lang: str) -> str:
    labels = {
        "dn": "Dīgha Nikāya",
        "mn": "Majjhima Nikāya",
        "sn": "Saṃyutta Nikāya",
        "an": "Aṅguttara Nikāya",
        "kn": "Khuddaka Nikāya",
    }
    lang_labels = {"en": "English", "pli": "Pāli", "de": "Deutsch", "fr": "Français"}
    name = labels.get(nikaya, nikaya.upper())
    lang_name = lang_labels.get(lang, lang.upper())
    return f"{name} — {lang_name}"


if __name__ == "__main__":
    main()
