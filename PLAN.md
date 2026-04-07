# Filament Compass Update Process

This document instructs agents on how to update the Filament Compass when new versions are released.

## When to Update

Trigger an update when:
- Filament packages are updated (check `source/filament/composer.json` versions)
- New components are added to packages
- Breaking changes appear in upgrade guide
- New patterns are implemented in demo
- Documentation has been significantly revised

## Pre-Update Scan

### 1. Check Package Versions

```bash
# Read current versions
cat source/filament/composer.json | grep -A 50 '"require"'
```

Compare with last recorded versions in `reference/versions.md`.

### 2. Check Upgrade Guide

```bash
# Review breaking changes
cat source/filament/docs/14-upgrade-guide.md
```

### 3. Scan for New Components

For each package, check for new files:

```bash
# Forms components (including subdirs for new types)
ls source/filament/packages/forms/src/Components/

# Tables columns + layout columns
ls source/filament/packages/tables/src/Columns/
ls source/filament/packages/tables/src/Columns/Layout/

# Tables filters + QueryBuilder constraints
ls source/filament/packages/tables/src/Filters/
ls source/filament/packages/query-builder/src/Constraints/

# Infolists entries
ls source/filament/packages/infolists/src/Components/

# Schema components
ls source/filament/packages/schemas/src/Components/

# Actions (including bulk actions)
ls source/filament/packages/actions/src/

# Widgets
ls source/filament/packages/widgets/src/

# Panels Resources pages
ls source/filament/packages/panels/src/Pages/
ls source/filament/packages/panels/src/Resources/

# Panels Auth (check for new MFA or auth features)
ls source/filament/packages/panels/src/Auth/
```

**Known components as of 2026-04-07** (compare against these to spot additions):

| Package | Components |
|---------|-----------|
| forms | TextInput, Select, Checkbox, Toggle, CheckboxList, Radio, DatePicker, DateTimePicker, TimePicker, FileUpload, RichEditor, MarkdownEditor, CodeEditor, Repeater, Builder, TagsInput, Textarea, KeyValue, ColorPicker, ToggleButtons, Slider, Hidden, Placeholder, ModalTableSelect, TableSelect, OneTimeCodeInput, LivewireField, MorphToSelect, ViewField |
| forms (deprecated) | RelationshipRepeater, MultiSelect |
| tables/columns | TextColumn, IconColumn, ImageColumn, ColorColumn, BooleanColumn, BadgeColumn, CheckboxColumn, SelectColumn, TextInputColumn, ToggleColumn, TagsColumn, ViewColumn |
| tables/layout | Split, Stack, Panel, Grid, View |
| tables/filters | Filter, SelectFilter, MultiSelectFilter, TernaryFilter, TrashedFilter, QueryBuilder |
| tables/summarizers | Average, Count, Range, Sum, Values |
| infolists | TextEntry, IconEntry, ImageEntry, ColorEntry, KeyValueEntry, RepeatableEntry, CodeEntry, ViewEntry |
| schemas | Grid, Group, Section, Fieldset, Tabs, Wizard, Actions, Callout, Flex, FusedGroup, Html, Icon, Image, Livewire, Text, UnorderedList, EmptyState, RenderHook, View, EmbeddedSchema, EmbeddedTable, Form |
| actions | Action, BulkAction, ActionGroup, BulkActionGroup, CreateAction, EditAction, ViewAction, DeleteAction, ReplicateAction, RestoreAction, ForceDeleteAction, SelectAction, AssociateAction, DissociateAction, AttachAction, DetachAction, DeleteBulkAction, ForceDeleteBulkAction, RestoreBulkAction, DetachBulkAction, DissociateBulkAction, ImportAction, ExportAction, ExportBulkAction |
| actions (deprecated) | ButtonAction, IconButtonAction |
| widgets | Widget, ChartWidget, StatsOverviewWidget, TableWidget |
| widgets (deprecated) | BarChartWidget, LineChartWidget, PieChartWidget, DoughnutChartWidget, RadarChartWidget, PolarAreaChartWidget, ScatterChartWidget, BubbleChartWidget |

### 4. Check for Deprecated Methods

Scan for new `@deprecated` annotations that may have appeared since last scan:

```bash
# Find all deprecated items added since last scan date
grep -rn "@deprecated" source/filament/packages/*/src/ | grep -v "vendor/" | grep -v ".phpstan"

# Key areas that have had deprecations before:
# - packages/widgets/src/*.php  (chart widget classes)
# - packages/forms/src/Components/*.php  (e.g. RelationshipRepeater)
# - packages/actions/src/*.php  (ButtonAction, IconButtonAction)
# - packages/widgets/src/TableWidget.php  (getTableQuery, getTableColumns)
# - packages/*/src/Testing/*.php  (test method renames)
```

When you find new deprecations, update both:
- The relevant package doc (add `> **Deprecated**: ...` note near the old pattern)
- `reference/breaking-changes.md` if it's a breaking API change
- `reference/common-mistakes.md` if it's a common error pattern

### 5. Check Package Docs

Each package has its own docs:

```bash
# Package-specific docs
ls source/filament/packages/forms/docs/
ls source/filament/packages/tables/docs/
ls source/filament/packages/infolists/docs/
ls source/filament/packages/actions/docs/
ls source/filament/packages/panels/docs/  # if exists
ls source/filament/packages/notifications/docs/
ls source/filament/packages/widgets/docs/
ls source/filament/packages/schemas/docs/
```

### 6. Review Demo for New Patterns

```bash
# Check for new resources, schemas, tables, widgets
find source/demo/app/Filament -type f -name "*.php" -newer PLAN.md
```

**Demo structure to check for new additions:**

```
source/demo/app/Filament/
├── Resources/{Domain}/{Entity}/
│   ├── Schemas/    ← form and infolist examples
│   ├── Tables/     ← table configuration examples
│   ├── Pages/      ← page-specific patterns
│   ├── Widgets/    ← resource-scoped stats
│   └── RelationManagers/
├── Widgets/        ← dashboard-level charts and stats
├── Imports/        ← import configuration examples
├── Exports/        ← export configuration examples
└── App/Pages/      ← custom page examples
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
- [ ] `closures.md` - If new injectable parameters or utilities are added
- [ ] `common-mistakes.md` - If new pitfalls discovered
- [ ] `breaking-changes.md` - ALWAYS update from upgrade guide
- [ ] `versions.md` - Always update scan date

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
| forms (concerns) | `packages/forms/src/Components/Concerns/` — HasHint, HasValidation, etc. |
| tables/columns | `packages/tables/src/Columns/` |
| tables/layout | `packages/tables/src/Columns/Layout/` — Split, Stack, Panel, Grid |
| tables/filters | `packages/tables/src/Filters/` |
| tables/summarizers | `packages/tables/src/Columns/Summarizers/` |
| query-builder | `packages/query-builder/src/Constraints/` — constraint types |
| infolists | `packages/infolists/src/Components/` |
| infolists (concerns) | `packages/infolists/src/Components/Concerns/` — HasHint, etc. |
| actions | `packages/actions/src/` |
| actions (concerns) | `packages/actions/src/Concerns/` — CanBeAuthorized, etc. |
| schemas | `packages/schemas/src/Components/` |
| schemas (utilities) | `packages/schemas/src/Components/Utilities/` — Get, Set |
| schemas (concerns) | `packages/schemas/src/Components/Concerns/` — HasState, CanBeHidden, etc. |
| widgets | `packages/widgets/src/` |
| panels | `packages/panels/src/Resources/`, `packages/panels/src/Pages/` |
| panels/auth | `packages/panels/src/Auth/` — MultiFactor, Pages, Http |
| panels/authorization | `packages/panels/src/Resources/Resource/Concerns/HasAuthorization.php` |
| support | `packages/support/src/Icons/`, `packages/support/src/Colors/` |
| support (closure eval) | `packages/support/src/Concerns/EvaluatesClosures.php` |
| testing | `packages/*/src/Testing/` — test helpers per package |
| upgrade/rector | `packages/upgrade/src/rector.php` — method rename rules |

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

1. **Record current state**: Note package versions, compare against `reference/versions.md`
2. **Run pre-update scan**: Check all source locations against known-component tables in step 3 above
3. **Check deprecations**: Grep for `@deprecated` in packages — update docs to warn and suggest alternatives
4. **Process upgrade guide**: Read `source/filament/docs/14-upgrade-guide.md` and extract breaking changes
5. **Check rector rules**: Read `source/filament/packages/upgrade/src/rector.php` for method renames
6. **Update component catalogs**: Add new components, remove or mark deprecated ones
7. **Update method signatures**: If component APIs changed, update method tables and closure param docs
8. **Update closures reference**: If new injectable parameters appear, update `reference/closures.md`
9. **Update patterns**: Incorporate new demo patterns from `source/demo/app/Filament/`
10. **Update reference**: Commands, namespaces, breaking changes
11. **Sync to package**: Run `bash sync.sh`
12. **Commit both repos**: Commit `filament-blueprint-clone` then `source/filament-compass-pkg`
13. **Update version record**: Write new versions and scan date to `reference/versions.md`

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

Also check the rector upgrade rules for method renames:

```bash
cat source/filament/packages/upgrade/src/rector.php
cat source/filament/packages/upgrade/src/check-compatibility.php
```

When a method is deprecated/renamed:
- Add a `> **Deprecated**: old method → use new method instead.` note in the relevant doc section
- Do NOT remove the old documentation — add the note immediately after the old example
- Add an entry to `reference/breaking-changes.md`

## Closure/API Change Handling

When source files in `packages/*/src/Components/Concerns/` or `packages/support/src/Concerns/EvaluatesClosures.php` change:

1. Check if new named parameters were added to `resolveDefaultClosureDependencyForEvaluationByName()`
2. Update `reference/closures.md` with any new injectable parameters
3. Update relevant package sections if a specific method's closure callback signature changed

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

# List all table columns (including layout)
ls source/filament/packages/tables/src/Columns/*.php | xargs -I {} basename {} .php
ls source/filament/packages/tables/src/Columns/Layout/*.php | xargs -I {} basename {} .php

# List all table summarizers
ls source/filament/packages/tables/src/Columns/Summarizers/*.php | xargs -I {} basename {} .php

# List all table filters
ls source/filament/packages/tables/src/Filters/*.php | xargs -I {} basename {} .php

# List all query-builder constraints
ls source/filament/packages/query-builder/src/Constraints/*.php | xargs -I {} basename {} .php

# List all infolist entries
ls source/filament/packages/infolists/src/Components/*.php | xargs -I {} basename {} .php

# List all schema components
ls source/filament/packages/schemas/src/Components/*.php | xargs -I {} basename {} .php

# List all actions
ls source/filament/packages/actions/src/*.php | xargs -I {} basename {} .php

# List all widgets
ls source/filament/packages/widgets/src/*.php | xargs -I {} basename {} .php

# Find all deprecated items in packages
grep -rn "@deprecated" source/filament/packages/*/src/ --include="*.php" -l

# Find deprecated items with their messages
grep -rn "@deprecated" source/filament/packages/*/src/ --include="*.php" -h | sort -u

# Find files changed since last scan date
find source/filament/packages -name "*.php" -newer reference/versions.md | grep -v "/tests/" | grep -v "/vendor/"

# Find demo app files changed since last scan
find source/demo/app -name "*.php" -newer reference/versions.md

# Find demo resources
find source/demo/app/Filament/Resources -name "*Resource.php"

# Check rector upgrade rules (method renames)
cat source/filament/packages/upgrade/src/rector.php

# Check package docs
ls source/filament/packages/forms/docs/*.md
ls source/filament/packages/tables/docs/*.md
ls source/filament/packages/infolists/docs/*.md
ls source/filament/packages/actions/docs/*.md
ls source/filament/packages/schemas/docs/*.md
ls source/filament/packages/notifications/docs/*.md
ls source/filament/packages/widgets/docs/*.md

# After all edits: sync and commit
bash sync.sh
git add -p && git commit
cd source/filament-compass-pkg && git add -p && git commit
```