#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$REPO_ROOT/source/filament-compass-pkg"

# ── 1. Pull sources ─────────────────────────────────────────────
echo "==> Pulling sources..."
for dir in boost demo filament; do
  echo "  Pulling source/$dir..."
  git -C "$REPO_ROOT/source/$dir" pull
done

# ── 2. Claude pause ─────────────────────────────────────────────
echo ""
echo "==> Update docs with Claude Code (use PLAN.md as guide)."
echo "    Press Enter when done..."
read -r

# ── 3. Sync ─────────────────────────────────────────────────────
echo "==> Running sync.sh..."
"$REPO_ROOT/sync.sh"

# ── 4. Commit blueprint-clone ────────────────────────────────────
echo "==> Committing blueprint-clone..."
git -C "$REPO_ROOT" add -A
if git -C "$REPO_ROOT" diff --cached --quiet; then
  echo "  No changes in blueprint-clone, skipping commit."
else
  git -C "$REPO_ROOT" commit -m "docs: sync documentation"
fi

# ── 5. Commit filament-compass-pkg ──────────────────────────────
echo "==> Committing filament-compass-pkg..."
git -C "$PKG_DIR" add -A
if git -C "$PKG_DIR" diff --cached --quiet; then
  echo "  No changes in pkg — nothing to release. Exiting."
  exit 0
fi
git -C "$PKG_DIR" commit -m "chore: sync docs from blueprint-clone"

# ── 6. Push pkg branch ──────────────────────────────────────────
echo "==> Pushing filament-compass-pkg..."
git -C "$PKG_DIR" push origin HEAD

# ── 7. Version prompt ───────────────────────────────────────────
LATEST_TAG=$(git -C "$REPO_ROOT" tag --sort=-v:refname | head -1)
LATEST_TAG="${LATEST_TAG:-0.0.0}"
echo ""
echo "  Latest tag: $LATEST_TAG"
IFS='.' read -r MAJOR MINOR PATCH <<< "$LATEST_TAG"

echo "  Bump: [p]atch (default) / [m]inor / [M]ajor / [c]ustom"
read -r BUMP
case "${BUMP:-p}" in
  M) MAJOR=$((MAJOR+1)); MINOR=0; PATCH=0 ;;
  m) MINOR=$((MINOR+1)); PATCH=0 ;;
  c) read -rp "  Enter version (e.g. 1.2.0): " NEW_TAG ;;
  *) PATCH=$((PATCH+1)) ;;
esac
NEW_TAG="${NEW_TAG:-${MAJOR}.${MINOR}.${PATCH}}"

# ── 8. Tag + push blueprint-clone ───────────────────────────────
echo "==> Tagging blueprint-clone as $NEW_TAG..."
git -C "$REPO_ROOT" tag "$NEW_TAG"
git -C "$REPO_ROOT" push origin HEAD
git -C "$REPO_ROOT" push origin "$NEW_TAG"

echo ""
echo "Done. Tag $NEW_TAG pushed. GitHub Action will mirror to pkg."
