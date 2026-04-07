#!/usr/bin/env bash
set -euo pipefail

PKG="source/filament-compass-pkg"
DOCS_DEST="$PKG/resources/docs"
GUIDELINES_DEST="$PKG/resources/boost/guidelines/core.blade.php"
SKILL_DEST="$PKG/resources/boost/skills/filament-development/SKILL.md"

# Create destination directories
mkdir -p "$DOCS_DEST" \
         "$PKG/resources/boost/guidelines" \
         "$PKG/resources/boost/skills/filament-development"

echo "Syncing doc files..."
rsync -av --delete \
    COMPASS.md \
    packages/ \
    patterns/ \
    testing/ \
    recipes/ \
    reference/ \
    architecture/ \
    "$DOCS_DEST/"

echo "Generating core.blade.php from GUIDELINES.md..."
awk '
    /<code-snippet/ { print "@verbatim" }
    { print }
    /\/code-snippet>/ { print "@endverbatim" }
' GUIDELINES.md > "$GUIDELINES_DEST"

echo "Generating SKILL.md with vendor paths..."
sed 's|filament-compass/|vendor/aldesrahim/filament-compass/resources/docs/|g' \
    SKILL.md > "$SKILL_DEST"

echo "Done. Package synced to $PKG"
