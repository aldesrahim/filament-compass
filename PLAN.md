# Filament Blueprint Update Process

This document instructs agents on how to update the Filament Blueprint when new versions are released.

## When to Update

Trigger an update when:
- Filament packages are updated (check `source/source/filament/composer.json` versions)
- New components are added to packages
- Breaking changes appear in upgrade guide
- New patterns are implemented in demo
- Documentation has been significantly revised

## Pre-Update Scan

### 1. Check Package Versions

```bash
# Read current versions
cat source/source/filament/composer.json | grep -A 50 '"require"'
```

Compare with last recorded versions in `reference/versions.md`.

### 2. Check Upgrade Guide

```bash
# Review breaking changes
cat source/source/filament/docs/14-upgrade-guide.md
```

### 3. Scan for New Components

For each package, check for new files:

```bash
# Forms components
ls source/source/filament/packages/forms/src/Components/

# Tables columns
ls source/source/filament/packages/tables/src/Columns/

# Infolists entries
ls source/source/filament/packages/infolists/src/Components/

# Schema components
ls source/source/filament/packages/schemas/src/Components/

# Actions
ls source/source/filament/packages/actions/src/

# Widgets
ls source/filament/packages/widgets/src/

# Panels Resources pages
ls source/filament/packages/panels/src/Pages/
ls source/filament/packages/panels/src/Resources/
```

### 4. Check Package Docs

Each package has its own docs:

```bash
# Package-specific docs
ls source/filament/packages/forms/docs/
ls source/filament/packages/tables/docs/
ls source/filament/packages/infolists/docs/
ls source/filament/packages/actions/docs/
ls source/filament/packages/panels/docs/  # if exists
```

### 5. Review Demo for New Patterns

```bash
# Check for new resources, schemas, tables, widgets
find source/demo/app/Filament -type f -name "*.php" -newer filament-blueprint/PLAN.md
```

## Update Checklist

Run through this checklist during each update:

### Architecture (`architecture/`)

- [ ] `overview.md` - Update if package hierarchy changes
- [ ] `naming-conventions.md` - Update if naming patterns change
- [ ] `directory-structure.md` - Update if file locations change

### Packages (`packages/`)

Update each package section if components/methods change:

- [ ] `panels/resources.md` - Resources, pages, relationships
- [ ] `panels/pages.md` - List, Create, Edit, View, Custom pages
- [ ] `panels/panels.md` - Panel configuration
- [ ] `panels/widgets.md` - Dashboard widgets
- [ ] `forms/components.md` - All form field components
- [ ] `forms/validation.md` - Validation rules and patterns
- [ ] `forms/relationships.md` - Select, Repeater, relationship fields
- [ ] `tables/columns.md` - All table column components
- [ ] `tables/filters.md` - Filters, QueryBuilder
- [ ] `tables/actions.md` - Row and bulk actions
- [ ] `tables/summaries.md` - Summarizers
- [ ] `infolists/entries.md` - All infolist entry components
- [ ] `actions/overview.md` - Action architecture
- [ ] `actions/catalog.md` - All action types
- [ ] `schemas/layout.md` - Grid, Section, Tabs, Wizard
- [ ] `notifications/overview.md` - Notification patterns
- [ ] `support/utilities.md` - Icons, colors, helpers
- [ ] `plugins/media-library.md` - Spatie Media Library
- [ ] `plugins/tags.md` - Spatie Tags
- [ ] `plugins/settings.md` - Spatie Settings

### Patterns (`patterns/`)

- [ ] `separated-concerns.md` - Update if demo patterns change
- [ ] `conditional-fields.md` - Get/Set patterns
- [ ] `state-transitions.md` - Status/workflow patterns
- [ ] `relationships.md` - Eloquent relationship patterns
- [ ] `imports-exports.md` - Import/Export patterns
- [ ] `authorization.md` - Policy/gate patterns

### Testing (`testing/`)

- [ ] `overview.md` - Testing approach
- [ ] `resources.md` - Resource testing
- [ ] `actions.md` - Action testing
- [ ] `tables.md` - Table testing

### Recipes (`recipes/`)

- [ ] `quick-start.md` - Minimal setup
- [ ] `crud-resource.md` - Complete CRUD
- [ ] `master-detail.md` - RelationManagers
- [ ] `wizard-form.md` - Multi-step forms
- [ ] `dashboard.md` - Dashboard widgets
- [ ] `custom-page.md` - Custom pages

### Reference (`reference/`)

- [ ] `artisan-commands.md` - Always update
- [ ] `namespaces.md` - Always update
- [ ] `common-mistakes.md` - If new pitfalls discovered
- [ ] `breaking-changes.md` - ALWAYS update from upgrade guide

## Content Format Rules

### Writing Style

- **Compact**: Minimal prose, maximum code
- **Code-focused**: Every concept has a code example
- **Real examples**: Use demo code where applicable
- **Include imports**: Always show `use` statements
- **Cross-reference**: Link related sections

### Section Template

```markdown
## Component/Pattern Name

Brief 1-2 sentence description.

### Basic Usage

```php
use Namespace\ClassName;

ClassName::make('name')
    ->method()
```

### Key Methods

| Method | Description | Example |
|--------|-------------|---------|
| `method()` | What it does | `->method(value)` |

### Real Example

```php
// From: source/demo/app/Filament/Path/File.php
ClassName::make('name')
    ->method()
    ->anotherMethod()
```

### Related

- [Related Section](../path/to/section.md)
```

### Metadata Blocks

Each file should start with:

```markdown
# Title

> Package: `filament/{package}` | Version: v5.x
> 
> Source: `source/filament/packages/{package}/src/`
> Docs: `source/filament/packages/{package}/docs/`
```

## Key Source Files

### Primary Documentation Sources

| Source | Content |
|--------|---------|
| `source/filament/docs/` | Main panel docs |
| `source/filament/docs/14-upgrade-guide.md` | Breaking changes |
| `source/filament/packages/{package}/docs/` | Package-specific docs |
| `filament/CLAUDE.md` | Coding patterns |
| `demo/CLAUDE.md` | Demo conventions |

### Component Source Locations

| Package | Components Location |
|---------|---------------------|
| forms | `packages/forms/src/Components/` |
| tables | `packages/tables/src/Columns/`, `packages/tables/src/Filters/` |
| infolists | `packages/infolists/src/Components/` |
| actions | `packages/actions/src/` |
| schemas | `packages/schemas/src/Components/` |
| widgets | `packages/widgets/src/` |
| panels | `packages/panels/src/Resources/`, `packages/panels/src/Pages/` |
| support | `packages/support/src/Icons/`, `packages/support/src/Colors/` |

### Demo Pattern Locations

| Pattern | Location |
|---------|----------|
| Resources | `source/demo/app/Filament/Resources/` |
| Schemas (Forms) | `source/demo/app/Filament/Resources/*/Schemas/` |
| Tables | `source/demo/app/Filament/Resources/*/Tables/` |
| Widgets | `source/demo/app/Filament/Resources/*/Widgets/`, `source/demo/app/Filament/Widgets/` |
| RelationManagers | `source/demo/app/Filament/Resources/*/RelationManagers/` |
| Imports | `source/demo/app/Filament/Imports/` |
| Exports | `source/demo/app/Filament/Exports/` |
| Custom Pages | `source/demo/app/Filament/App/Pages/` |

## Update Execution Steps

1. **Record current state**: Note package versions
2. **Run pre-update scan**: Check all source locations
3. **Process upgrade guide**: Extract breaking changes
4. **Update component catalogs**: Add new components, update methods
5. **Update patterns**: Incorporate new demo patterns
6. **Update reference**: Commands, namespaces, breaking changes
7. **Verify cross-references**: Ensure links are valid
8. **Update version record**: Write new versions to `reference/versions.md`

## Version Tracking

Create/update `reference/versions.md`:

```markdown
# Filament Versions

Last scanned: YYYY-MM-DD

| Package | Version |
|---------|---------|
| filament/filament | v5.x |
| laravel/framework | v12.x |
| livewire/livewire | v4.x |
```

## Breaking Change Handling

When processing `source/filament/docs/14-upgrade-guide.md`:

1. Extract all breaking changes
2. Classify by impact:
   - **Critical**: Changes that break existing code
   - **Recommended**: Changes that improve but not required
   - **Deprecated**: Features being phased out
3. Add to `reference/breaking-changes.md`
4. Update `common-mistakes.md` if new pitfalls identified
5. Update affected package sections with new patterns

## Quality Checks

After updating, verify:

- [ ] All imports use correct namespaces (see `reference/namespaces.md`)
- [ ] Code examples are syntactically correct
- [ ] Real examples path references exist in demo
- [ ] Cross-references point to valid sections
- [ ] Breaking changes are accurately documented
- [ ] No deprecated patterns are recommended

---

## Quick Commands Reference

```bash
# List all form components
ls source/filament/packages/forms/src/Components/*.php | xargs -I {} basename {} .php

# List all table columns
ls source/filament/packages/tables/src/Columns/*.php | xargs -I {} basename {} .php

# List all infolist entries
ls source/filament/packages/infolists/src/Components/*.php | xargs -I {} basename {} .php

# List all actions
ls source/filament/packages/actions/src/*.php | xargs -I {} basename {} .php

# Find demo resources
find source/demo/app/Filament/Resources -name "*Resource.php"

# Check package docs
ls source/filament/packages/forms/docs/*.md
ls source/filament/packages/tables/docs/*.md
```