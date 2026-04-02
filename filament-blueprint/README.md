# Filament Blueprint

[![Latest Version](https://img.shields.io/github/release/aldesrahim/filament-blueprint.svg?style=flat-square)](https://github.com/aldesrahim/filament-blueprint/releases)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE)

Comprehensive documentation for Filament v5, designed for LLMs and Laravel Boost integration.

## Quick Start

```bash
# In your Laravel project
curl -s https://raw.githubusercontent.com/aldesrahim/filament-blueprint/main/install.sh | bash
```

## Overview

This blueprint provides two formats for AI context:

| Format | File | Purpose | Loading |
|--------|------|---------|---------|
| **Guidelines** | `GUIDELINES.md` | Essential conventions, quick reference | Upfront (always loaded) |
| **Skills** | `SKILL.md` | Detailed patterns, recipes, examples | On-demand (task-specific) |

---

## Installation Methods

### Method 1: One-Line Install (Recommended)

```bash
cd /path/to/your/laravel/project
curl -s https://raw.githubusercontent.com/aldesrahim/filament-blueprint/main/install.sh | bash
```

This will:
1. Download filament-blueprint to your project
2. Create symlinks in `.ai/` for Laravel Boost
3. Detect if Laravel Boost is installed

### Method 2: Git Submodule

Best for keeping the blueprint updated:

```bash
cd /path/to/your/laravel/project

# Add as submodule
git submodule add https://github.com/aldesrahim/filament-blueprint.git filament-blueprint

# Create symlinks (from project root)
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

# Commit
git add .gitmodules filament-blueprint .ai/
git commit -m "Add Filament Blueprint"
```

**To update:**
```bash
git submodule update --remote filament-blueprint
```

### Method 3: Git Subtree

Embeds the blueprint into your repo (no external dependency):

```bash
cd /path/to/your/laravel/project

# Add as subtree
git subtree add --prefix=filament-blueprint https://github.com/aldesrahim/filament-blueprint.git main --squash

# Create symlinks (from project root)
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

**To update:**
```bash
git subtree pull --prefix=filament-blueprint https://github.com/aldesrahim/filament-blueprint.git main --squash
```

### Method 4: Manual Copy

Simple one-time setup without git integration:

```bash
cd /path/to/your/laravel/project

# Download
wget https://github.com/aldesrahim/filament-blueprint/archive/refs/heads/main.tar.gz
tar -xzf main.tar.gz
mv filament-blueprint-main filament-blueprint
rm main.tar.gz

# Create symlinks (from project root)
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

### Method 5: Composer Package (Future)

```bash
composer require your-vendor/filament-blueprint --dev
```

*Coming soon - requires publishing to Packagist*

---

## After Installation

### With Laravel Boost

```bash
# Install Boost if not already
composer require laravel/boost --dev

# Run Boost installer
php artisan boost:install

# Select your AI agent (Claude Code, Cursor, etc.)
```

### Without Laravel Boost

Add to your `CLAUDE.md`:

```markdown
# Filament Guidelines

Read filament-blueprint/GUIDELINES.md for essential conventions.

## Skills
When working with Filament, read filament-blueprint/SKILL.md for detailed patterns.
```

---

## Comparison of Methods

| Method | Updates | Git History | Complexity |
|--------|---------|-------------|------------|
| One-Line | Manual re-run | No | Easiest |
| Submodule | `git submodule update` | Yes | Medium |
| Subtree | `git subtree pull` | Yes | Medium |
| Manual Copy | Re-download | No | Simple |

**Recommendations:**
- **Personal projects**: One-line install
- **Team projects**: Git submodule
- **Long-term projects**: Git subtree

---

## Directory Structure

```
your-project/
├── .ai/                           # Laravel Boost directories
│   ├── guidelines/
│   │   └── filament/
│   │       └── core.md → ../../../filament-blueprint/GUIDELINES.md
│   └── skills/
│       └── filament-development/
│           └── SKILL.md → ../../../filament-blueprint/SKILL.md
│
├── filament-blueprint/            # Blueprint source (48 files)
│   ├── BLUEPRINT.md
│   ├── SKILL.md
│   ├── GUIDELINES.md
│   ├── README.md
│   ├── PLAN.md
│   ├── architecture/
│   ├── packages/
│   ├── patterns/
│   ├── testing/
│   ├── recipes/
│   └── reference/
│
└── [your Laravel app files]
```

---

## Updating the Blueprint

### If using Git Submodule

```bash
git submodule update --remote filament-blueprint
php artisan boost:update
```

### If using Git Subtree

```bash
git subtree pull --prefix=filament-blueprint https://github.com/aldesrahim/filament-blueprint.git main --squash
php artisan boost:update
```

### If using One-Line/Manual

```bash
# Re-run the installer
curl -s https://raw.githubusercontent.com/aldesrahim/filament-blueprint/main/install.sh | bash
```

---

## For Package Maintainers

If you maintain a Filament package and want to include these docs:

1. Copy `GUIDELINES.md` to `resources/boost/guidelines/core.blade.php`
2. Copy `SKILL.md` to `resources/boost/skills/filament-development/SKILL.md`

Users running `php artisan boost:install` will get your guidelines automatically.

---

## Version

- **Filament**: v5
- **Laravel**: v12
- **Livewire**: v4
- **PHP**: 8.4+

## License

MIT