#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/bump_version.sh 1.2.3

VERSION="${1:?Usage: bump_version.sh <semver>}"

if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Error: version must be semver (e.g. 1.2.3)"
  exit 1
fi

# Build number: strip dots → 123
BUILD_NUMBER=$(echo "$VERSION" | tr -d '.')

PUBSPEC="$(cd "$(dirname "$0")/.." && pwd)/pubspec.yaml"

sed -i "s/^version: .*/version: ${VERSION}+${BUILD_NUMBER}/" "$PUBSPEC"

echo "Updated pubspec.yaml → version: ${VERSION}+${BUILD_NUMBER}"

git add "$PUBSPEC"
git commit -m "chore: bump version to $VERSION"
git tag "v${VERSION}"

echo ""
echo "Done! Push with:"
echo "  git push && git push --tags"
