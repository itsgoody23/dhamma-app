"""Tests for the ETL pipeline."""
import json
import sqlite3
import tempfile
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent.parent))

from etl_pipeline import (
    sanitise_html,
    html_to_plain,
    create_database,
    insert_rows,
    create_seed_db,
    build_manifest,
    compress_db,
)


def test_sanitise_html_strips_scripts():
    html = '<html><body><p>Hello</p><script>evil()</script></body></html>'
    result = sanitise_html(html)
    assert '<script>' not in result
    assert 'Hello' in result


def test_sanitise_html_keeps_paragraphs():
    html = '<p>This is <b>bold</b> text.</p>'
    result = sanitise_html(html)
    assert '<b>bold</b>' in result
    assert '<p>' in result


def test_html_to_plain_strips_tags():
    html = '<p>The <b>Dhamma</b> is timeless.</p>'
    result = html_to_plain(html)
    assert '<b>' not in result
    assert 'Dhamma' in result
    assert 'timeless' in result


def test_create_database_has_fts5():
    with tempfile.TemporaryDirectory() as tmp:
        db_path = Path(tmp) / "test.db"
        conn = create_database(db_path)
        conn.close()

        conn = sqlite3.connect(str(db_path))
        tables = [r[0] for r in conn.execute(
            "SELECT name FROM sqlite_master WHERE type='table'"
        ).fetchall()]
        conn.close()

    assert 'texts' in tables
    assert 'texts_fts' in tables
    assert 'translations' in tables


def test_insert_rows_and_fts_search():
    with tempfile.TemporaryDirectory() as tmp:
        db_path = Path(tmp) / "test.db"
        conn = create_database(db_path)
        rows = [
            {
                "uid": "mn10",
                "title": "Mindfulness Discourse",
                "collection": None,
                "nikaya": "mn",
                "book": "Majjhima Nikaya",
                "chapter": None,
                "language": "en",
                "translator": "bodhi",
                "source": "sc",
                "content_html": "<p>There is one way for the purification of beings.</p>",
                "content_plain": "There is one way for the purification of beings.",
            },
            {
                "uid": "sn56.11",
                "title": "Dhammacakkappavattana Sutta",
                "collection": None,
                "nikaya": "sn",
                "book": None,
                "chapter": None,
                "language": "en",
                "translator": "bodhi",
                "source": "sc",
                "content_html": "<p>Thus have I heard.</p>",
                "content_plain": "Thus have I heard.",
            },
        ]
        count = insert_rows(conn, rows)
        assert count == 2

        # Test FTS5 search
        results = conn.execute(
            "SELECT uid FROM texts_fts WHERE texts_fts MATCH 'purification*'"
        ).fetchall()
        assert len(results) >= 1
        assert results[0][0] == 'mn10'

        conn.close()


def test_fts5_diacritic_search():
    """Verify that 'unicode61 remove_diacritics 1' allows ASCII search for Pali."""
    with tempfile.TemporaryDirectory() as tmp:
        db_path = Path(tmp) / "test.db"
        conn = create_database(db_path)
        rows = [{
            "uid": "mn10",
            "title": "Satipaṭṭhāna Sutta",
            "collection": None,
            "nikaya": "mn",
            "book": None,
            "chapter": None,
            "language": "pli",
            "translator": None,
            "source": "sc",
            "content_html": "<p>Satipaṭṭhāna — the four foundations of mindfulness.</p>",
            "content_plain": "Satipaṭṭhāna — the four foundations of mindfulness.",
        }]
        insert_rows(conn, rows)

        # ASCII search should match diacritic title
        results = conn.execute(
            "SELECT uid FROM texts_fts WHERE texts_fts MATCH 'satipatthana*'"
        ).fetchall()
        assert len(results) >= 1

        conn.close()


def test_create_seed_db():
    with tempfile.TemporaryDirectory() as tmp:
        output_dir = Path(tmp)
        seed_path = create_seed_db(output_dir)
        assert seed_path.exists()

        conn = sqlite3.connect(str(seed_path))
        rows = conn.execute("SELECT COUNT(*) FROM daily_suttas").fetchone()
        conn.close()
        assert rows[0] > 0


def test_compress_db():
    with tempfile.TemporaryDirectory() as tmp:
        db_path = Path(tmp) / "test.db"
        conn = sqlite3.connect(str(db_path))
        conn.execute("CREATE TABLE t (x TEXT)")
        conn.commit()
        conn.close()

        gz_path = compress_db(db_path)
        assert gz_path.exists()
        assert gz_path.suffix == '.gz'
        assert gz_path.stat().st_size > 0


def test_build_manifest():
    packs = [{"pack_id": "mn_en", "pack_name": "MN English", "language": "en",
               "nikaya": "mn", "size_mb": 8.0, "compressed_size_mb": 3.0,
               "sutta_count": 152, "download_url": "https://example.com/mn.db.gz",
               "checksum_sha256": "abc123", "version": "2026.03.15"}]
    manifest = build_manifest(packs, "2026.03.15")
    assert manifest["version"] == "2026.03.15"
    assert len(manifest["packs"]) == 1
    assert manifest["packs"][0]["pack_id"] == "mn_en"


def test_insert_no_duplicates():
    with tempfile.TemporaryDirectory() as tmp:
        db_path = Path(tmp) / "test.db"
        conn = create_database(db_path)
        row = [{
            "uid": "mn1",
            "title": "Root of All Things",
            "collection": None,
            "nikaya": "mn",
            "book": None,
            "chapter": None,
            "language": "en",
            "translator": "bodhi",
            "source": "sc",
            "content_html": "<p>Thus have I heard.</p>",
            "content_plain": "Thus have I heard.",
        }]
        insert_rows(conn, row)
        insert_rows(conn, row)  # Duplicate — should be ignored
        count = conn.execute("SELECT COUNT(*) FROM texts").fetchone()[0]
        assert count == 1
        conn.close()
