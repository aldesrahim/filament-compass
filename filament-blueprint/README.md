# Filament Blueprint

Comprehensive documentation for Filament v5, designed for LLMs and Laravel Boost integration.

## Overview

This blueprint provides two formats for AI context:

| Format | File | Purpose | Loading |
|--------|------|---------|---------|
| **Guidelines** | `GUIDELINES.md` | Essential conventions, quick reference | Upfront (always loaded) |
| **Skills** | `SKILL.md` | Detailed patterns, recipes, examples | On-demand (task-specific) |

## Laravel Boost Integration

### Quick Setup

```bash
# Run the setup script to create symlinks
./setup-boost.sh

# Then run Boost install
php artisan boost:install
```

### Manual Setup

If you prefer to set up manually:

```bash
# Create directories
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# Create symlinks
ln -s ../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

### What Gets Created

```
.ai/
├── guidelines/
│   └── filament/
│       └── core.md -> ../../filament-blueprint/GUIDELINES.md
└── skills/
    └── filament-development/
        └── SKILL.md -> ../../filament-blueprint/SKILL.md
```

### How Boost Uses These Files

**Guidelines** (loaded upfront):
- Boost loads `.ai/guidelines/filament/core.md` when the agent starts
- Provides essential namespace rules, common mistakes, quick patterns
- Always available in agent context

**Skills** (loaded on-demand):
- Boost activates `filament-development` skill when working with Filament
- Contains detailed component catalogs, patterns, recipes
- Only loaded when relevant to reduce context bloat

### Symlinks in Git

Symlinks are committed to Git and work on Linux/macOS. On Windows:

1. Enable Developer Mode in Windows Settings
2. Or run Git Bash as Administrator
3. Use `git config --global core.symlinks true`

### Committing Symlinks

```bash
# Add symlinks to git (they will be tracked as symlinks, not file contents)
git add .ai/guidelines/filament/core.md
git add .ai/skills/filament-development/SKILL.md
git add setup-boost.sh

# Commit
git commit -m "Add Filament Blueprint integration for Laravel Boost"
```

When cloned, the symlinks will point to the correct relative paths as long as the directory structure is preserved.

## Directory Structure

```
filament-blueprint/
├── BLUEPRINT.md           # Main entry point
├── SKILL.md               # On-demand skill definition
├── GUIDELINES.md          # Upfront guidelines for Boost
├── PLAN.md                # Update instructions
│
├── architecture/          # Core concepts
│   ├── overview.md
│   ├── naming-conventions.md
│   └── directory-structure.md
│
├── packages/              # Component catalogs
│   ├── panels/            # Resources, pages, widgets, panels
│   ├── forms/             # Fields, validation, relationships
│   ├── tables/            # Columns, filters, actions, summaries
│   ├── infolists/         # Entry components
│   ├── actions/           # Action types
│   ├── schemas/           # Layout components
│   ├── notifications/     # Notifications
│   ├── support/           # Icons, colors, utilities
│   └── plugins/           # Spatie integrations
│
├── patterns/              # Implementation patterns
│   ├── separated-concerns.md
│   ├── conditional-fields.md
│   ├── state-transitions.md
│   ├── relationships.md
│   ├── imports-exports.md
│   └── authorization.md
│
├── testing/               # Testing guides
│   ├── overview.md
│   ├── resources.md
│   ├── actions.md
│   └── tables.md
│
├── recipes/               # Step-by-step guides
│   ├── quick-start.md
│   ├── crud-resource.md
│   ├── master-detail.md
│   ├── wizard-form.md
│   ├── dashboard.md
│   └── custom-page.md
│
└── reference/             # Quick lookup
    ├── artisan-commands.md
    ├── namespaces.md
    ├── common-mistakes.md
    └── breaking-changes.md
```

## Usage Without Laravel Boost

### For Any AI Agent

Add to your `CLAUDE.md`, `.cursorrules`, or similar:

```markdown
# Filament Guidelines

[COPY CONTENT FROM GUIDELINES.md]

# Skills
When working with Filament, read filament-blueprint/SKILL.md for detailed patterns.
```

## Updating

When Filament releases new versions:

```bash
# Read update instructions
cat filament-blueprint/PLAN.md

# After updating blueprint, refresh Boost
php artisan boost:update
```

## Third-Party Package Integration

If you're a package maintainer and want to include Filament Blueprint:

1. Copy `GUIDELINES.md` to your package at `resources/boost/guidelines/core.blade.php`
2. Copy `SKILL.md` to your package at `resources/boost/skills/filament-development/SKILL.md`
3. Users running `php artisan boost:install` will get your guidelines automatically

## Version

- **Filament**: v5
- **Laravel**: v12
- **Livewire**: v4
- **PHP**: 8.4+

## Files

- 48 markdown documentation files
- Symlinks for Laravel Boost integration
- Setup script for easy installation

## License

MIT