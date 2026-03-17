#!/usr/bin/env python3
"""Convert the NCPED Pali-English dictionary JSON into a SQLite database.

Reads: sc-data/dictionaries/simple/en/pli2en_ncped.json
Writes: assets/db/dhamma_dictionary.db

The database contains:
  - pali_dictionary      — main table (id, entry, grammar, definition, cross_refs)
  - pali_dictionary_fts  — FTS5 virtual table for fast prefix / fuzzy search
  - Triggers to keep FTS5 in sync with the main table
"""

import json
import os
import sqlite3
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.abspath(os.path.join(SCRIPT_DIR, '..', '..'))

INPUT_PATH = os.path.join(
    ROOT_DIR, '..', 'sc-data', 'dictionaries', 'simple', 'en', 'pli2en_ncped.json'
)
OUTPUT_PATH = os.path.join(ROOT_DIR, 'assets', 'db', 'dhamma_dictionary.db')


DDL = """
CREATE TABLE IF NOT EXISTS pali_dictionary (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    entry       TEXT    NOT NULL,
    grammar     TEXT,
    definition  TEXT    NOT NULL,
    cross_refs  TEXT
);

CREATE INDEX IF NOT EXISTS idx_pali_dictionary_entry
    ON pali_dictionary(entry);

CREATE VIRTUAL TABLE IF NOT EXISTS pali_dictionary_fts
    USING fts5(
        entry,
        definition,
        content='pali_dictionary',
        content_rowid='id',
        tokenize='unicode61 remove_diacritics 1'
    );

-- Keep FTS5 in sync with the main table.
CREATE TRIGGER IF NOT EXISTS pali_dictionary_ai AFTER INSERT ON pali_dictionary BEGIN
    INSERT INTO pali_dictionary_fts(rowid, entry, definition)
    VALUES (new.id, new.entry, new.definition);
END;

CREATE TRIGGER IF NOT EXISTS pali_dictionary_ad AFTER DELETE ON pali_dictionary BEGIN
    INSERT INTO pali_dictionary_fts(pali_dictionary_fts, rowid, entry, definition)
    VALUES ('delete', old.id, old.entry, old.definition);
END;

CREATE TRIGGER IF NOT EXISTS pali_dictionary_au AFTER UPDATE ON pali_dictionary BEGIN
    INSERT INTO pali_dictionary_fts(pali_dictionary_fts, rowid, entry, definition)
    VALUES ('delete', old.id, old.entry, old.definition);
    INSERT INTO pali_dictionary_fts(rowid, entry, definition)
    VALUES (new.id, new.entry, new.definition);
END;
"""


def _normalise_list(value):
    """Return a string from a value that may be a string or list of strings."""
    if value is None:
        return None
    if isinstance(value, list):
        return '; '.join(str(v) for v in value)
    return str(value)


def main():
    if not os.path.exists(INPUT_PATH):
        print(f'Error: input file not found: {INPUT_PATH}', file=sys.stderr)
        sys.exit(1)

    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)

    # Remove old database so we start fresh.
    if os.path.exists(OUTPUT_PATH):
        os.remove(OUTPUT_PATH)

    print(f'Reading {INPUT_PATH} …')
    with open(INPUT_PATH, 'r', encoding='utf-8') as f:
        entries = json.load(f)

    print(f'Loaded {len(entries):,} dictionary entries.')

    conn = sqlite3.connect(OUTPUT_PATH)
    conn.executescript(DDL)

    rows = []
    for entry in entries:
        word = entry.get('entry', '').strip()
        if not word:
            continue
        grammar = entry.get('grammar')
        definition = _normalise_list(entry.get('definition', ''))
        cross_refs = _normalise_list(entry.get('xr'))
        rows.append((word, grammar, definition, cross_refs))

    conn.executemany(
        'INSERT INTO pali_dictionary (entry, grammar, definition, cross_refs) VALUES (?, ?, ?, ?)',
        rows,
    )
    conn.commit()

    count = conn.execute('SELECT COUNT(*) FROM pali_dictionary').fetchone()[0]
    print(f'Inserted {count:,} rows into pali_dictionary.')

    fts_count = conn.execute(
        'SELECT COUNT(*) FROM pali_dictionary_fts'
    ).fetchone()[0]
    print(f'FTS5 index contains {fts_count:,} rows.')

    conn.execute('ANALYZE')
    conn.execute('VACUUM')
    conn.commit()
    conn.close()

    size_mb = os.path.getsize(OUTPUT_PATH) / (1024 * 1024)
    print(f'Wrote {OUTPUT_PATH} ({size_mb:.1f} MB)')


if __name__ == '__main__':
    main()
