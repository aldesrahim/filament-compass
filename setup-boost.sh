#!/bin/bash

# Filament Blueprint - Laravel Boost Integration Setup
# This script creates symlinks from filament-blueprint/ to .ai/ for Laravel Boost compatibility

set -e

echo "Setting up Filament Blueprint symlinks for Laravel Boost..."

# Create directories
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# Create symlinks (using relative paths for portability)
cd "$(dirname "$0")"

# Guidelines symlink
ln -sf ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
echo "✓ Created symlink: .ai/guidelines/filament/core.md -> filament-blueprint/GUIDELINES.md"

# Skills symlink
ln -sf ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
echo "✓ Created symlink: .ai/skills/filament-development/SKILL.md -> filament-blueprint/SKILL.md"

echo ""
echo "Done! Filament Blueprint is now integrated with Laravel Boost."
echo ""
echo "After running 'php artisan boost:install', the guidelines and skills will be available."
echo ""
echo "To verify, run:"
echo "  ls -la .ai/guidelines/filament/"
echo "  ls -la .ai/skills/filament-development/"