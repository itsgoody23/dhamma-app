#!/usr/bin/env python3
"""
Upload content packs + manifest to Supabase Storage.

Usage:
    python upload_packs.py --service-key YOUR_SERVICE_ROLE_KEY

The service_role key is found in Supabase Dashboard → Settings → API → service_role.
It is NOT the anon key — you need the service_role key for uploads.
"""
import os
import sys
import requests
from pathlib import Path

import click

SUPABASE_PROJECT = "difjbtoydrpspabqbndl"
BUCKET = "packs"
BASE_URL = f"https://{SUPABASE_PROJECT}.supabase.co/storage/v1/object/{BUCKET}"
OUTPUT_DIR = Path(__file__).parent / "output"


def upload_file(filepath: Path, service_key: str, content_type: str = "application/octet-stream") -> bool:
    """Upload a single file to Supabase Storage, overwriting if exists."""
    url = f"{BASE_URL}/{filepath.name}"
    headers = {
        "Authorization": f"Bearer {service_key}",
        "Content-Type": content_type,
        "x-upsert": "true",  # Overwrite existing
    }
    with open(filepath, "rb") as f:
        resp = requests.post(url, headers=headers, data=f)

    if resp.status_code in (200, 201):
        print(f"  OK {filepath.name} ({filepath.stat().st_size / 1_048_576:.2f} MB)")
        return True
    else:
        print(f"  FAIL {filepath.name}: {resp.status_code} {resp.text}")
        return False


@click.command()
@click.option("--service-key", envvar="SUPABASE_SERVICE_KEY", required=True,
              help="Supabase service_role key (or set SUPABASE_SERVICE_KEY env var)")
def main(service_key: str):
    pack_files = sorted(OUTPUT_DIR.glob("*_pack.db.gz"))
    # Filter to only language-specific packs (e.g. mn_en_pack.db.gz, not mn_pack.db.gz)
    lang_packs = [f for f in pack_files if f.stem.count("_") >= 2]
    manifest = OUTPUT_DIR / "pack_manifest.json"

    if not lang_packs:
        print("No language-specific pack files found in output/")
        sys.exit(1)

    print(f"Uploading {len(lang_packs)} packs + manifest to Supabase Storage...")
    print()

    failures = 0
    for pack in lang_packs:
        if not upload_file(pack, service_key):
            failures += 1

    # Upload manifest
    if not upload_file(manifest, service_key, content_type="application/json"):
        failures += 1

    print()
    if failures == 0:
        print(f"All {len(lang_packs) + 1} files uploaded successfully!")
    else:
        print(f"{failures} upload(s) failed.")
        sys.exit(1)


if __name__ == "__main__":
    main()
