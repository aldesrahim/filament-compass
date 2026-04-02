#!/bin/bash

# Filament Blueprint - Install Script for Existing Projects
# Usage: curl -s https://raw.githubusercontent.com/YOUR_REPO/filament-blueprint/main/install.sh | bash
# Or: ./install.sh /path/to/your/project

set -e

TARGET_DIR="${1:-.}"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Filament Blueprint - Laravel Boost Integration         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if target exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Get absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
BLUEPRINT_DIR="$TARGET_DIR/filament-blueprint"

echo "Target directory: $TARGET_DIR"
echo ""

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

# Download or copy files
if [ -f "$(dirname "$0")/BLUEPRINT.md" ]; then
    # Running locally
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    echo "Copying from local source..."
    cp -r "$SCRIPT_DIR" "$BLUEPRINT_DIR"
else
    # Download from GitHub
    echo "Downloading from GitHub..."
    REPO_URL="https://github.com/YOUR_USERNAME/filament-blueprint"
    git clone --depth 1 "$REPO_URL" "$BLUEPRINT_DIR"
    rm -rf "$BLUEPRINT_DIR/.git"
fi

echo "✓ Filament Blueprint installed to: $BLUEPRINT_DIR"
echo ""

# Create .ai directories and symlinks
cd "$TARGET_DIR"
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

ln -sf ../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -sf ../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

echo "✓ Created symlinks in .ai/"
echo ""

# Check if this is a Laravel project with Boost
if [ -f "$TARGET_DIR/artisan" ] && [ -d "$TARGET_DIR/vendor/laravel/boost" ]; then
    echo "✓ Laravel Boost detected!"
    echo ""
    echo "Run: php artisan boost:install"
    echo "Then select your AI agent (Claude Code, Cursor, etc.)"
elif [ -f "$TARGET_DIR/artisan" ]; then
    echo "ℹ️  Laravel project detected."
    echo ""
    echo "Install Laravel Boost first:"
    echo "  composer require laravel/boost --dev"
    echo "  php artisan boost:install"
else
    echo "ℹ️  Not a Laravel project."
    echo ""
    echo "You can still use the blueprint manually by reading:"
    echo "  filament-blueprint/BLUEPRINT.md"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Installation complete!                                    ║"
echo "╚════════════════════════════════════════════════════════════╝"