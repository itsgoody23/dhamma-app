#!/usr/bin/env python3
"""Upload ETL pack files to Supabase Storage.

Usage:
  1. Create a Supabase project at https://supabase.com
  2. Create a public Storage bucket called "packs"
  3. Get your project URL and service-role key from Settings > API
  4. Run:
       python scripts/upload_packs.py \
         --supabase-url https://YOUR_PROJECT.supabase.co \
         --supabase-key YOUR_SERVICE_ROLE_KEY

This uploads all .db.gz files and pack_manifest.json to the "packs" bucket,
then prints the public URLs to update in pack_index_service.dart.
"""

import argparse
import sys
from pathlib import Path

try:
    import httpx
except ImportError:
    print("Install httpx first: pip install httpx")
    sys.exit(1)

PACK_DIR = Path(__file__).resolve().parent / "etl" / "output"
BUCKET = "packs"


def upload_file(client: httpx.Client, url: str, key: str, filepath: Path) -> str:
    """Upload a single file to Supabase Storage. Returns public URL."""
    content_type = (
        "application/gzip" if filepath.suffix == ".gz" else "application/json"
    )
    resp = client.post(
        f"{url}/storage/v1/object/{BUCKET}/{filepath.name}",
        headers={
            "apikey": key,
            "Authorization": f"Bearer {key}",
            "Content-Type": content_type,
            "x-upsert": "true",
        },
        content=filepath.read_bytes(),
    )
    if resp.status_code not in (200, 201):
        print(f"  ERROR uploading {filepath.name}: {resp.status_code} {resp.text}")
        return ""
    public_url = f"{url}/storage/v1/object/public/{BUCKET}/{filepath.name}"
    print(f"  Uploaded {filepath.name} -> {public_url}")
    return public_url


def main():
    parser = argparse.ArgumentParser(description="Upload packs to Supabase Storage")
    parser.add_argument("--supabase-url", required=True, help="Supabase project URL")
    parser.add_argument(
        "--supabase-key", required=True, help="Supabase service-role key"
    )
    args = parser.parse_args()

    if not PACK_DIR.exists():
        print(f"Pack directory not found: {PACK_DIR}")
        print("Run the ETL pipeline first: python scripts/etl/etl_pipeline.py")
        sys.exit(1)

    files = list(PACK_DIR.glob("*.db.gz")) + list(PACK_DIR.glob("*.json"))
    if not files:
        print("No pack files found in output directory.")
        sys.exit(1)

    print(f"Uploading {len(files)} files to {args.supabase_url}...")
    client = httpx.Client(timeout=120)
    urls = {}
    for f in sorted(files):
        url = upload_file(client, args.supabase_url, args.supabase_key, f)
        if url:
            urls[f.name] = url
    client.close()

    print(f"\nDone! {len(urls)}/{len(files)} files uploaded.")
    manifest_url = urls.get("pack_manifest.json", "")
    if manifest_url:
        print(f"\nUpdate _manifestUrl in pack_index_service.dart to:")
        print(f"  '{manifest_url}'")


if __name__ == "__main__":
    main()
