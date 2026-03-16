#!/usr/bin/env python3
"""
Generate a 365-day seed database by selecting diverse suttas from pack DBs.

Usage:
    python scripts/etl/generate_seed_365.py

Reads .db.gz files from scripts/etl/output/, selects 365 suttas with excerpts,
writes assets/db/dhamma_seed.db.
"""

import gzip
import json
import random
import shutil
import sqlite3
import tempfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = SCRIPT_DIR / "output"
SEED_DB_PATH = SCRIPT_DIR.parent.parent / "assets" / "db" / "dhamma_seed.db"

# Target distribution across nikayas (roughly proportional to corpus size, with
# a slight boost for DN/MN since they contain the most well-known suttas)
TARGET_COUNTS = {
    "dn": 34,   # all 34 DN suttas
    "mn": 80,   # ~half of MN's 152
    "sn": 120,  # ~6% of SN's 1917
    "an": 100,  # ~5% of AN's 1898
    "kn": 31,   # from KN's 1024
}
# Total: 365

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


def decompress_pack(gz_path: Path) -> Path:
    """Decompress a .db.gz to a temp file, return path."""
    tmp = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
    with gzip.open(gz_path, "rb") as f_in:
        shutil.copyfileobj(f_in, tmp)
    tmp.close()
    return Path(tmp.name)


def extract_suttas(db_path: Path) -> list[dict]:
    """Extract uid, title, content_plain, nikaya from a pack DB."""
    conn = sqlite3.connect(str(db_path))
    conn.row_factory = sqlite3.Row
    rows = conn.execute(
        "SELECT uid, title, content_plain, nikaya FROM texts ORDER BY uid"
    ).fetchall()
    conn.close()
    return [dict(r) for r in rows]


def pick_excerpt(content_plain: str, max_len: int = 120) -> str:
    """Pick a meaningful excerpt from sutta content.

    Strategy: look for short, quotable sentences in the first ~2000 chars.
    Prefer sentences that start with capital letters and are 20-120 chars.
    """
    if not content_plain:
        return ""

    # Take first portion of text (skip very first line which is often just the title)
    text = content_plain[:3000]

    # Split into sentences
    sentences = []
    for s in text.replace("\n", " ").split("."):
        s = s.strip()
        if len(s) >= 20 and len(s) <= max_len:
            sentences.append(s + ".")

    if not sentences:
        # Fallback: just take first max_len chars
        return text[:max_len].strip() + "…" if len(text) > max_len else text.strip()

    # Prefer sentences that look like direct speech or teachings
    teaching_keywords = [
        "monks", "bhikkhus", "should", "there is", "this is", "one who",
        "just as", "when a", "a person", "the mind", "suffering",
        "mindfulness", "wisdom", "compassion", "happiness", "peace",
        "virtue", "practice", "meditation", "noble", "path",
        "all beings", "may all", "not to", "do not", "let go",
    ]

    scored = []
    for s in sentences:
        score = sum(1 for kw in teaching_keywords if kw.lower() in s.lower())
        scored.append((score, s))

    scored.sort(key=lambda x: -x[0])
    return scored[0][1]


def main():
    random.seed(42)  # Reproducible selection

    all_suttas: dict[str, list[dict]] = {}

    # Load all pack databases
    for gz_file in sorted(OUTPUT_DIR.glob("*_pack.db.gz")):
        nikaya = gz_file.stem.replace("_pack.db", "")
        print(f"Loading {nikaya}...")
        db_path = decompress_pack(gz_file)
        suttas = extract_suttas(db_path)
        db_path.unlink()
        all_suttas[nikaya] = suttas
        print(f"  {len(suttas)} suttas")

    # Select suttas for each nikaya
    selected = []
    for nikaya, count in TARGET_COUNTS.items():
        pool = all_suttas.get(nikaya, [])
        if not pool:
            print(f"WARNING: No suttas for {nikaya}")
            continue

        if count >= len(pool):
            # Take all
            chosen = pool
        else:
            # Evenly sample across the collection
            step = len(pool) / count
            indices = [int(i * step) for i in range(count)]
            chosen = [pool[i] for i in indices]

        for sutta in chosen:
            excerpt = pick_excerpt(sutta["content_plain"])
            selected.append({
                "uid": sutta["uid"],
                "title": sutta["title"],
                "verse_excerpt": excerpt,
                "nikaya": nikaya,
            })

        print(f"  Selected {len(chosen)} from {nikaya}")

    # Shuffle to mix nikayas across the year
    random.shuffle(selected)

    print(f"\nTotal selected: {len(selected)}")

    # Write seed DB
    SEED_DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    if SEED_DB_PATH.exists():
        SEED_DB_PATH.unlink()

    conn = sqlite3.connect(str(SEED_DB_PATH))
    conn.executescript(SEED_DDL)

    for day, sutta in enumerate(selected, start=1):
        conn.execute(
            "INSERT INTO daily_suttas (day_of_year, uid, title, verse_excerpt, nikaya) VALUES (?,?,?,?,?)",
            (day, sutta["uid"], sutta["title"], sutta["verse_excerpt"], sutta["nikaya"]),
        )

    conn.commit()

    # Verify
    count = conn.execute("SELECT COUNT(*) FROM daily_suttas").fetchone()[0]
    conn.close()

    print(f"\nSeed DB written to {SEED_DB_PATH}")
    print(f"Contains {count} daily suttas")

    # Also update SEED_SUTTAS in etl_pipeline.py with the generated data
    print("\nGenerating SEED_SUTTAS list for etl_pipeline.py...")
    generate_seed_list(selected)


def generate_seed_list(selected: list[dict]):
    """Write a seed_suttas_365.json for reference."""
    out_path = SCRIPT_DIR / "output" / "seed_suttas_365.json"
    data = []
    for day, sutta in enumerate(selected, start=1):
        data.append({
            "day_of_year": day,
            "uid": sutta["uid"],
            "title": sutta["title"],
            "verse_excerpt": sutta["verse_excerpt"],
            "nikaya": sutta["nikaya"],
        })

    out_path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"Seed list JSON written to {out_path}")


if __name__ == "__main__":
    main()
