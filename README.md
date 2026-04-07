# Filament Compass

[![Latest Version](https://img.shields.io/github/release/aldesrahim/filament-compass.svg?style=flat-square)](https://github.com/aldesrahim/filament-compass/releases)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE)

Comprehensive documentation for Filament v5, designed for LLMs and AI-assisted development.

## Recommended Stack

Filament Compass works best as part of this AI-assisted development workflow:

| Tool | Role |
|------|------|
| **[laravel/boost](https://github.com/laravel/boost)** | MCP server that loads `.ai/` context files into Claude Code, giving your AI assistant Laravel-specific knowledge |
| **Filament Compass** (this repo) | Provides Filament-specific patterns, conventions, and recipes — loaded into Boost via `.ai/` symlinks |
| **[laraveldaily/filacheck](https://github.com/laraveldaily/filacheck)** | Static analyzer that validates AI-generated Filament code, catching deprecated methods and wrong namespaces |

**The workflow:** Boost loads Compass into the AI → AI generates accurate Filament code → FilaCheck validates the output.

### Full Stack Setup

```bash
cd /path/to/your/laravel/project

# Step 1 — Install Filament Compass (this repo)
curl -s https://raw.githubusercontent.com/aldesrahim/filament-compass/main/install.sh | bash

# Step 2 — Install Laravel Boost
composer require laravel/boost --dev
php artisan boost:install

# Step 3 — Register Boost MCP with Claude Code (usually auto-registered by boost:install)
claude mcp add -s local -t stdio laravel-boost php artisan boost:mcp

# Step 4 — Install FilaCheck
composer require laraveldaily/filacheck --dev
```

After setup, run FilaCheck to validate AI-generated Filament code:

```bash
vendor/bin/filacheck              # scan app/Filament
vendor/bin/filacheck --dirty      # scan only uncommitted files
vendor/bin/filacheck --fix        # auto-fix detected issues (beta)
```

---

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
curl -s https://raw.githubusercontent.com/aldesrahim/filament-compass/main/install.sh | bash
```

This will:
1. Download `filament-compass/` to your project root
2. Create `.ai/` directory with symlinks for Laravel Boost
3. Detect if Laravel Boost is installed

### Method 2: Git Submodule

Best for teams - keeps the filament-compass updated:

```bash
cd /path/to/your/laravel/project

# 1. Add as submodule
git submodule add https://github.com/aldesrahim/filament-compass.git filament-compass

# 2. Create .ai directory at PROJECT ROOT (not inside filament-compass/)
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-compass

# 3. Create symlinks (run from PROJECT ROOT)
# Note: Path is relative to symlink's location, not current directory
ln -s ../../../filament-compass/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-compass/SKILL.md .ai/skills/filament-compass/SKILL.md

# 4. Commit
git add .gitmodules filament-compass .ai/
git commit -m "Add Filament Compass"
```

**To update:**
```bash
git submodule update --remote filament-compass
```

### Method 3: Git Subtree

Embeds the filament-compass into your repo:

```bash
cd /path/to/your/laravel/project

# 1. Add as subtree
git subtree add --prefix=filament-compass https://github.com/aldesrahim/filament-compass.git main --squash

# 2. Create .ai directory at PROJECT ROOT
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-compass

# 3. Create symlinks (run from PROJECT ROOT)
# Note: Path is relative to symlink's location, not current directory
ln -s ../../../filament-compass/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-compass/SKILL.md .ai/skills/filament-compass/SKILL.md
```

**To update:**
```bash
git subtree pull --prefix=filament-compass https://github.com/aldesrahim/filament-compass.git main --squash
```

### Method 4: Manual Download

```bash
cd /path/to/your/laravel/project

# 1. Download
wget https://github.com/aldesrahim/filament-compass/archive/refs/heads/main.tar.gz
tar -xzf main.tar.gz
mv filament-compass-main filament-compass
rm main.tar.gz

# 2. Create .ai directory at PROJECT ROOT
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-compass

# 3. Create symlinks (run from PROJECT ROOT)
# Note: Path is relative to symlink's location, not current directory
ln -s ../../../filament-compass/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-compass/SKILL.md .ai/skills/filament-compass/SKILL.md
```

---

## Directory Structure After Installation

```
your-project/                         # YOUR PROJECT ROOT
├── .ai/                              # Created at project root
│   ├── guidelines/
│   │   └── filament/
│   │       └── core.md → ../../../filament-compass/GUIDELINES.md
│   └── skills/
│       └── filament-compass/
│           └── SKILL.md → ../../../filament-compass/SKILL.md
│
├── filament-compass/               # Compass (submodule/folder)
│   ├── COMPASS.md
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
- `filament-compass/` is also at YOUR project root
- Symlinks go from `.ai/` to `filament-compass/`

---

## Symlink Path Explanation

From `.ai/guidelines/filament/core.md`:
- `../` → `.ai/guidelines/`
- `../../` → `.ai/`
- `../../../` → project root
- `../../../filament-compass/GUIDELINES.md` ✅

```bash
# Run these commands from YOUR PROJECT ROOT
ln -s ../../../filament-compass/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-compass/SKILL.md .ai/skills/filament-compass/SKILL.md
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

Read filament-compass/GUIDELINES.md for essential conventions.

## Skills
When working with Filament, read filament-compass/SKILL.md for detailed patterns.
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
git submodule update --remote filament-compass
php artisan boost:update

# If using Git Subtree  
git subtree pull --prefix=filament-compass https://github.com/aldesrahim/filament-compass.git main --squash
php artisan boost:update

# If using One-Line/Manual
curl -s https://raw.githubusercontent.com/aldesrahim/filament-compass/main/install.sh | bash
```

---

## Version

- **Filament**: v5
- **Laravel**: v12
- **Livewire**: v4
- **PHP**: 8.4+

## License

MIT