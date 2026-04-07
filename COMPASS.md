# Filament Compass

> A comprehensive reference for building Filament v5 applications with Laravel v12.
> 
> **Version**: Filament v5 | Laravel v12 | Livewire v4

Filament is a full-stack UI framework for Laravel built with Livewire, Alpine.js, and Tailwind CSS. It provides admin panels, forms, tables, notifications, actions, infolists, and widgets as composable packages.

## Quick Reference

### Core Namespace Map

| Category | Namespace |
|----------|-----------|
| **Form fields** | `Filament\Forms\Components\` |
| **Table columns** | `Filament\Tables\Columns\` |
| **Infolist entries** | `Filament\Infolists\Components\` |
| **Layout components** | `Filament\Schemas\Components\` |
| **Actions** | `Filament\Actions\` |
| **Icons** | `Filament\Support\Icons\Heroicon` |
| **Utilities (Get/Set)** | `Filament\Schemas\Components\Utilities\` |

### Package Hierarchy

```
support (base utilities)
  ↓
schemas (UI layouts - Grid, Section, Tabs, Wizard)
  ↓
forms, tables, infolists, actions, notifications, widgets
  ↓
panels (full admin framework - Resources, Pages, Dashboard)
```

### Typical Resource Structure

```
app/Filament/Resources/{Domain}/{Entity}/
├── {Entity}Resource.php      # Resource definition
├── Schemas/
│   └── {Entity}Form.php      # Form schema (create/edit)
│   └── {Entity}Infolist.php  # Infolist schema (view)
├── Tables/
│   └── {Entity}Table.php     # Table configuration (list)
├── Pages/
│   ├── List{Entity}.php      # List page
│   ├── Create{Entity}.php    # Create page
│   ├── Edit{Entity}.php      # Edit page
│   └── View{Entity}.php      # View page (optional)
├── RelationManagers/
│   └── {Relation}RelationManager.php
└── Widgets/
    └── {Entity}Stats.php     # Resource-specific widgets
```

## Compass Structure

```
filament-compass/
├── architecture/       # Core concepts, naming, directory structure
├── packages/           # Component catalogs by package
│   ├── panels/         # Resources, pages, widgets, panels
│   ├── forms/          # Form fields, validation, relationships
│   ├── tables/         # Columns, filters, actions, summaries
│   ├── infolists/      # Entry components
│   ├── actions/        # Action types and patterns
│   ├── schemas/        # Layout components
│   ├── notifications/  # Notification patterns
│   ├── support/        # Icons, colors, helpers
│   └── plugins/        # Spatie integrations
├── patterns/           # Implementation patterns
├── testing/            # Testing guides
├── recipes/            # Step-by-step implementation guides
└── reference/          # Quick lookup tables
```

## When Building a Feature, Read These Sections

### For a new Resource

1. [architecture/overview.md](architecture/overview.md) - Package hierarchy
2. [packages/panels/resources.md](packages/panels/resources.md) - Resource structure
3. [packages/forms/components.md](packages/forms/components.md) - Form fields
4. [packages/tables/columns.md](packages/tables/columns.md) - Table columns
5. [recipes/crud-resource.md](recipes/crud-resource.md) - Full implementation guide

### For conditional/dynamic forms

1. [patterns/conditional-fields.md](patterns/conditional-fields.md) - Get/Set patterns
2. [packages/forms/validation.md](packages/forms/validation.md) - Validation

### For state transitions (status changes)

1. [patterns/state-transitions.md](patterns/state-transitions.md) - Workflow patterns
2. [packages/actions/catalog.md](packages/actions/catalog.md) - Action types

### For relationships (BelongsTo, HasMany, ManyToMany)

1. [patterns/relationships.md](patterns/relationships.md) - Relationship patterns
2. [packages/forms/relationships.md](packages/forms/relationships.md) - Relationship fields

### For imports/exports

1. [patterns/imports-exports.md](patterns/imports-exports.md) - Import/Export patterns
2. [packages/actions/catalog.md](packages/actions/catalog.md) - ImportAction, ExportAction

### For testing

1. [testing/overview.md](testing/overview.md) - Testing approach
2. [testing/resources.md](testing/resources.md) - Resource tests

## Common Mistakes to Avoid

See [reference/common-mistakes.md](reference/common-mistakes.md) for detailed pitfalls.

**Quick checklist**:
- ✅ Use `Filament\Actions\` namespace (NOT `Filament\Tables\Actions\` etc.)
- ✅ Layout components use `Filament\Schemas\Components\` namespace
- ✅ Use `Heroicon::OutlinedBolt` enum for icons (NOT string `'heroicon-o-bolt'`)
- ✅ File uploads: `visibility('public')` for public access (default is `private`)
- ✅ Grid/Section/Fieldset: specify `->columns()` explicitly (no longer spans all by default)

## Breaking Changes in v5

See [reference/breaking-changes.md](reference/breaking-changes.md) for complete list.

**Critical changes**:
- File visibility is `private` by default
- `Grid`, `Section`, `Fieldset` no longer span all columns automatically
- Use `Filament\Actions\` namespace for all actions (no package-specific action namespaces)
- Schema utilities (`Get`, `Set`) moved to `Filament\Schemas\Components\Utilities\`

## Artisan Commands

See [reference/artisan-commands.md](reference/artisan-commands.md) for complete list.

```bash
# Create a resource
php artisan make:filament-resource Product --generate

# Create a resource with separated concerns
php artisan make:filament-resource Product --generate --separate

# Create a relation manager
php artisan make:filament-relation-manager ProductResource orders

# Create a custom page
php artisan make:filament-page Settings

# Create a widget
php artisan make:filament-widget SalesChart
```

## Component Creation Pattern

All Filament components follow the fluent API pattern:

```php
use Filament\Forms\Components\TextInput;

TextInput::make('field_name')
    ->label('Display Label')
    ->required()
    ->maxLength(255)
    ->visible(fn (Get $get): bool => $get('other_field') === 'value')
```

Key patterns:
- **`make($name)`** - Static factory method, accepts field name
- **Chained methods** - Configuration methods return `static`
- **Closure support** - Most methods accept `Closure` for dynamic values
- **Get/Set utilities** - Use `Get $get` / `Set $set` for cross-field logic
- **Closure injection** - Declare any of `$state`, `$record`, `$operation`, `$get`, `$set`, `$livewire`, `$rowLoop` by name — Filament injects them automatically. See [reference/closures.md](reference/closures.md).

## Real Example: Complete Resource

From demo: `demo/app/Filament/Resources/Shop/Products/ProductResource.php`

```php
<?php

namespace App\Filament\Resources\Shop\Products;

use App\Filament\Resources\Shop\Products\Pages\CreateProduct;
use App\Filament\Resources\Shop\Products\Pages\EditProduct;
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Filament\Resources\Shop\Products\Schemas\ProductForm;
use App\Filament\Resources\Shop\Products\Tables\ProductsTable;
use App\Models\Shop\Product;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    protected static ?string $recordTitleAttribute = 'name';
    
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
    
    protected static ?string $navigationGroup = 'Shop';
    
    protected static ?int $navigationSort = 0;
    
    public static function form(Schema $schema): Schema
    {
        return ProductForm::configure($schema);
    }
    
    public static function table(Table $table): Table
    {
        return ProductsTable::configure($table);
    }
    
    public static function getPages(): array
    {
        return [
            'index' => ListProducts::route('/'),
            'create' => CreateProduct::route('/create'),
            'edit' => EditProduct::route('/{record}/edit'),
        ];
    }
}
```

## Planning a Filament Application

When asked to create a Filament Compass for an application, follow this process:

### 1. Domain Analysis

Identify:
- **Entities** (what Resources are needed)
- **Relationships** (what RelationManagers)
- **State flows** (what Actions trigger transitions)
- **Permissions** (what Policies/Gates)

### 2. Map to Filament Primitives

For each entity:
- **Resource** → CRUD pages (List, Create, Edit, View)
- **Form Schema** → Fields with validation
- **Table** → Columns, filters, row/bulk actions
- **RelationManagers** → HasMany, ManyToMany relationships
- **Widgets** → Dashboard statistics

### 3. Define User Flows

Document:
- Entry points (navigation, dashboard)
- Create/Edit flows (form steps, validation)
- Action flows (state transitions, confirmations)
- Search/Filter flows (query patterns)

### 4. Specify Components

For each form:
- List all fields with types
- Define validation rules
- Specify conditional visibility
- Note relationship fields

For each table:
- List all columns with types
- Define filters (simple or QueryBuilder)
- Specify row actions (Edit, Delete, custom)
- Specify bulk actions

### 5. Output Specification

Generate:
- Resource definitions with all configuration
- Form schemas with all fields
- Table configurations with all features
- Action definitions for state transitions
- Policy/Gate authorization rules

---

## Section Index

### Architecture
- [overview.md](architecture/overview.md) - Package hierarchy, dependencies
- [naming-conventions.md](architecture/naming-conventions.md) - Variable/method names
- [directory-structure.md](architecture/directory-structure.md) - Where files go

### Packages

#### Panels
- [resources.md](packages/panels/resources.md) - Resource structure
- [pages.md](packages/panels/pages.md) - List, Create, Edit, View pages
- [panels.md](packages/panels/panels.md) - Panel configuration
- [widgets.md](packages/panels/widgets.md) - Dashboard widgets

#### Forms
- [components.md](packages/forms/components.md) - All field types
- [validation.md](packages/forms/validation.md) - Validation rules
- [relationships.md](packages/forms/relationships.md) - Relationship fields

#### Tables
- [columns.md](packages/tables/columns.md) - All column types
- [filters.md](packages/tables/filters.md) - Filters, QueryBuilder
- [actions.md](packages/tables/actions.md) - Row/bulk actions
- [summaries.md](packages/tables/summaries.md) - Summarizers

#### Infolists
- [entries.md](packages/infolists/entries.md) - All entry types

#### Actions
- [overview.md](packages/actions/overview.md) - Action architecture
- [catalog.md](packages/actions/catalog.md) - All action types

#### Schemas
- [layout.md](packages/schemas/layout.md) - Grid, Section, Tabs, Wizard

#### Notifications
- [overview.md](packages/notifications/overview.md) - Notification patterns

#### Support
- [utilities.md](packages/support/utilities.md) - Icons, colors, helpers

#### Plugins
- [media-library.md](packages/plugins/media-library.md) - Spatie Media Library
- [tags.md](packages/plugins/tags.md) - Spatie Tags
- [settings.md](packages/plugins/settings.md) - Spatie Settings

### Patterns
- [separated-concerns.md](patterns/separated-concerns.md) - Schema/Table separation
- [conditional-fields.md](patterns/conditional-fields.md) - Get/Set patterns
- [state-transitions.md](patterns/state-transitions.md) - Status workflows
- [relationships.md](patterns/relationships.md) - Eloquent relationship patterns
- [imports-exports.md](patterns/imports-exports.md) - Import/Export patterns
- [authorization.md](patterns/authorization.md) - Policies, Gates

### Testing
- [overview.md](testing/overview.md) - Testing approach
- [resources.md](testing/resources.md) - Resource testing
- [actions.md](testing/actions.md) - Action testing
- [tables.md](testing/tables.md) - Table testing

### Recipes
- [quick-start.md](recipes/quick-start.md) - Minimal setup
- [crud-resource.md](recipes/crud-resource.md) - Complete CRUD resource
- [master-detail.md](recipes/master-detail.md) - Resource + RelationManagers
- [wizard-form.md](recipes/wizard-form.md) - Multi-step wizard
- [dashboard.md](recipes/dashboard.md) - Dashboard with widgets
- [custom-page.md](recipes/custom-page.md) - Custom page

### Reference
- [artisan-commands.md](reference/artisan-commands.md) - All commands
- [namespaces.md](reference/namespaces.md) - Namespace quick reference
- [closures.md](reference/closures.md) - Closure injection parameters ($state, $get, $set, $record, $operation, $rowLoop, etc.)
- [common-mistakes.md](reference/common-mistakes.md) - Pitfalls
- [breaking-changes.md](reference/breaking-changes.md) - v5 changes