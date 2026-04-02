# Filament Blueprint

[![Latest Version](https://img.shields.io/github/release/YOUR_USERNAME/filament-blueprint.svg?style=flat-square)](https://github.com/YOUR_USERNAME/filament-blueprint/releases)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE)

Comprehensive documentation for Filament v5, designed for LLMs and Laravel Boost integration.

## Overview

This blueprint provides two formats for AI context:

| Format | File | Purpose | Loading |
|--------|------|---------|---------|
| **Guidelines** | `GUIDELINES.md` | Essential conventions, quick reference | Upfront (always loaded) |
| **Skills** | `SKILL.md` | Detailed patterns, recipes, examples | On-demand (task-specific) |

---

## Installation

### Method 1: One-Line Install (Recommended)

```bash
cd /path/to/your/laravel/project

# Download and install
curl -s https://raw.githubusercontent.com/YOUR_USERNAME/filament-blueprint/main/install.sh | bash
```

This will:
1. Download `filament-blueprint/` to your project root
2. Create `.ai/` directory with symlinks for Laravel Boost
3. Detect if Laravel Boost is installed

### Method 2: Git Submodule

Best for teams - keeps the blueprint updated:

```bash
cd /path/to/your/laravel/project

# 1. Add as submodule
git submodule add https://github.com/YOUR_USERNAME/filament-blueprint.git filament-blueprint

# 2. Create .ai directory at PROJECT ROOT (not inside filament-blueprint/)
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# 3. Create symlinks (run from PROJECT ROOT)
# Note: Path is relative to symlink's location, not current directory
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

# 4. Commit
git add .gitmodules filament-blueprint .ai/
git commit -m "Add Filament Blueprint"
```

**To update:**
```bash
git submodule update --remote filament-blueprint
```

### Method 3: Git Subtree

Embeds the blueprint into your repo:

```bash
cd /path/to/your/laravel/project

# 1. Add as subtree
git subtree add --prefix=filament-blueprint https://github.com/YOUR_USERNAME/filament-blueprint.git main --squash

# 2. Create .ai directory at PROJECT ROOT
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# 3. Create symlinks (run from PROJECT ROOT)
# Note: Path is relative to symlink's location, not current directory
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

**To update:**
```bash
git subtree pull --prefix=filament-blueprint https://github.com/YOUR_USERNAME/filament-blueprint.git main --squash
```

### Method 4: Manual Download

```bash
cd /path/to/your/laravel/project

# 1. Download
wget https://github.com/YOUR_USERNAME/filament-blueprint/archive/refs/heads/main.tar.gz
tar -xzf main.tar.gz
mv filament-blueprint-main filament-blueprint
rm main.tar.gz

# 2. Create .ai directory at PROJECT ROOT
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# 3. Create symlinks (run from PROJECT ROOT)
# Note: Path is relative to symlink's location, not current directory
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

---

## Directory Structure After Installation

```
your-project/                         # YOUR PROJECT ROOT
├── .ai/                              # Created at project root
│   ├── guidelines/
│   │   └── filament/
│   │       └── core.md → ../../../filament-blueprint/GUIDELINES.md
│   └── skills/
│       └── filament-development/
│           └── SKILL.md → ../../../filament-blueprint/SKILL.md
│
├── filament-blueprint/               # Blueprint (submodule/folder)
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

**Important:**
- `.ai/` is at YOUR project root (where `artisan` is)
- `filament-blueprint/` is also at YOUR project root
- Symlinks go from `.ai/` to `filament-blueprint/`

---

## Symlink Path Explanation

From `.ai/guidelines/filament/core.md`:
- `../` → `.ai/guidelines/`
- `../../` → `.ai/`
- `../../../` → project root
- `../../../filament-blueprint/GUIDELINES.md` ✅

```bash
# Run these commands from YOUR PROJECT ROOT
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

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
| One-Line | Re-run script | No | Easiest |
| Submodule | `git submodule update` | Yes | Medium |
| Subtree | `git subtree pull` | Yes | Medium |
| Manual | Re-download | No | Simple |

**Recommendations:**
- **Personal projects**: One-line install
- **Team projects**: Git submodule
- **Long-term projects**: Git subtree

---

## Updating

```bash
# If using Git Submodule
git submodule update --remote filament-blueprint
php artisan boost:update

# If using Git Subtree  
git subtree pull --prefix=filament-blueprint https://github.com/YOUR_USERNAME/filament-blueprint.git main --squash
php artisan boost:update

# If using One-Line/Manual
curl -s https://raw.githubusercontent.com/YOUR_USERNAME/filament-blueprint/main/install.sh | bash
```

---

## Version

- **Filament**: v5
- **Laravel**: v12
- **Livewire**: v4
- **PHP**: 8.4+

## License

MIT