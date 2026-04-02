#!/bin/bash

# Filament Blueprint - Install Script
# Installs Filament Blueprint into an existing Laravel project
#
# Usage:
#   cd /path/to/your/laravel/project
#   curl -s https://raw.githubusercontent.com/YOUR_USERNAME/filament-blueprint/main/install.sh | bash
#
# Or:
#   ./install.sh

set -e

TARGET_DIR="$(pwd)"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Filament Blueprint - Installation                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "Target directory: $TARGET_DIR"
echo ""

BLUEPRINT_DIR="$TARGET_DIR/filament-blueprint"

# Check if filament-blueprint already exists
if [ -d "$BLUEPRINT_DIR" ]; then
    echo "⚠️  filament-blueprint/ already exists."
    read -p "Remove and reinstall? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
    rm -rf "$BLUEPRINT_DIR"
fi

# Download
echo "Downloading Filament Blueprint..."
REPO_URL="https://github.com/YOUR_USERNAME/filament-blueprint"
git clone --depth 1 "$REPO_URL" "$BLUEPRINT_DIR" 2>/dev/null || {
    echo "❌ Failed to clone repository. Please check your internet connection."
    exit 1
}

# Remove .git from the clone
rm -rf "$BLUEPRINT_DIR/.git"

echo "✓ Downloaded to: filament-blueprint/"
echo ""

# Create .ai directories at PROJECT ROOT
echo "Creating .ai/ directory at project root..."
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# Create symlinks from .ai/ to filament-blueprint/
ln -sf ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -sf ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

echo "✓ Created symlinks in .ai/"
echo "  .ai/guidelines/filament/core.md → filament-blueprint/GUIDELINES.md"
echo "  .ai/skills/filament-development/SKILL.md → filament-blueprint/SKILL.md"
echo ""

# Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Installation complete!                                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Directory structure:"
echo "  $TARGET_DIR/"
echo "  ├── .ai/                          (Laravel Boost)"
echo "  │   ├── guidelines/filament/"
echo "  │   └── skills/filament-development/"
echo "  └── filament-blueprint/           (Documentation)"
echo ""

# Check for Laravel Boost
if [ -f "artisan" ] && [ -d "vendor/laravel/boost" ]; then
    echo "✓ Laravel Boost detected!"
    echo ""
    echo "Next step:"
    echo "  php artisan boost:install"
elif [ -f "artisan" ]; then
    echo "ℹ️  Laravel project detected."
    echo ""
    echo "Install Laravel Boost:"
    echo "  composer require laravel/boost --dev"
    echo "  php artisan boost:install"
else
    echo "ℹ️  Not a Laravel project."
    echo ""
    echo "You can still use the blueprint by reading:"
    echo "  filament-blueprint/BLUEPRINT.md"
fi