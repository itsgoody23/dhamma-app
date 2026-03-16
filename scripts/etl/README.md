# Dhamma App — ETL Pipeline

Converts SuttaCentral sc-data JSON/HTML into compressed SQLite content packs
that the Flutter app can download and merge.

## Setup

```bash
cd scripts/etl
pip install -r requirements.txt
```

## Usage

### Full run (all nikayas, English + Pali)
```bash
python etl_pipeline.py \
  --sc-data-path /path/to/suttacentral/sc-data \
  --output-dir ./output \
  --languages en,pli \
  --packs dn,mn,sn,an,kn
```

### Seed DB only (for bundling in the APK)
```bash
python etl_pipeline.py --seed
```
Copy `output/dhamma_seed.db` to `assets/db/dhamma_seed.db`.

### Run tests
```bash
pytest tests/ -v
```

## Output

| File | Purpose |
|------|---------|
| `output/dhamma_seed.db` | Bundled in APK — daily suttas only |
| `output/mn_en_v20260315.db.gz` | Downloadable content pack |
| `output/pack_manifest.json` | Index of all available packs |

## Pack manifest format

```json
{
  "version": "2026.03.15",
  "packs": [
    {
      "pack_id": "mn_en",
      "pack_name": "Majjhima Nikāya — English",
      "language": "en",
      "nikaya": "mn",
      "size_mb": 8.2,
      "compressed_size_mb": 3.1,
      "sutta_count": 152,
      "download_url": "https://cdn.dhamma.app/packs/mn_en_v20260315.db.gz",
      "checksum_sha256": "abc123...",
      "version": "2026.03.15"
    }
  ]
}
```

## CI/CD

The ETL runs automatically every Sunday at 3am UTC (`.github/workflows/ci.yml`).
It clones the latest `suttacentral/sc-data`, diffs checksums against the
published manifest, and uploads only changed packs to the CDN.

## sc-data directory structure expected

```
sc-data/
├── structure/              # JSON navigation hierarchy
│   └── *.json
├── html_text/              # HTML text by language
│   ├── en/mn/mn1/bodhi/mn1.html
│   └── pli/mn/mn1.html
└── translation/            # Translation metadata
    └── *.json
```

Clone with:
```bash
git clone https://github.com/suttacentral/sc-data.git
```
