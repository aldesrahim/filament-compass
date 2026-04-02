#!/bin/bash

# Filament Blueprint - Laravel Boost Integration Setup
# Run this script from YOUR PROJECT ROOT (where artisan is located)
# 
# Usage:
#   cd /path/to/your/laravel/project
#   ./setup-boost.sh

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Filament Blueprint - Laravel Boost Setup                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if we're in a project root (looking for filament-blueprint folder)
if [ ! -d "filament-blueprint" ]; then
    echo "❌ Error: filament-blueprint/ directory not found."
    echo ""
    echo "Please ensure filament-blueprint/ exists in your project root."
    echo "You can install it using:"
    echo "  git submodule add https://github.com/YOUR_USERNAME/filament-blueprint.git filament-blueprint"
    exit 1
fi

echo "✓ Found filament-blueprint/ directory"
echo ""

# Create .ai directories
echo "Creating .ai/ directory structure..."
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# Create symlinks
ln -sf ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -sf ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

echo "✓ Created symlinks:"
echo "  .ai/guidelines/filament/core.md → filament-blueprint/GUIDELINES.md"
echo "  .ai/skills/filament-development/SKILL.md → filament-blueprint/SKILL.md"
echo ""

# Verify symlinks
if [ -f ".ai/guidelines/filament/core.md" ] && [ -f ".ai/skills/filament-development/SKILL.md" ]; then
    echo "✓ Symlinks verified and working"
else
    echo "⚠️  Warning: Symlinks may not be working correctly"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Setup complete!                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check for Laravel Boost
if [ -f "artisan" ] && [ -d "vendor/laravel/boost" ]; then
    echo "✓ Laravel Boost detected!"
    echo ""
    echo "Next steps:"
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