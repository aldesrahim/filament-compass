---
name: filament-development
description: Build and work with Filament v5 admin panels, resources, forms, tables, actions, widgets, and Livewire-based CRUD interfaces.
---

# Filament Compass Skill

> On-demand skill for detailed Filament v5 implementation patterns.
> 
> **Prerequisites**: Basic Filament guidelines should already be loaded from GUIDELINES.md.

## Activation Triggers

Activate this skill when:
- Creating or modifying Filament resources, forms, tables, actions
- Planning a Filament application architecture
- Implementing relationships, state transitions, authorization
- Writing tests for Filament components
- User asks "how do I create X in Filament?"
- User mentions: Filament, Laravel admin, CRUD, Resource, Form, Table, Action, Widget, Panel

## Skill Content Location

> **Important**: All paths below are relative to the **project root** (where `filament-compass/` is installed as a submodule or directory). Do NOT resolve them relative to this skill file's location.

This skill reads from:
```
<project-root>/filament-compass/
├── COMPASS.md           # Main entry - read first
├── packages/              # Component catalogs
├── patterns/              # Implementation patterns
├── testing/               # Testing guides
├── recipes/               # Step-by-step guides
└── reference/             # Quick lookup tables
```

## How to Use This Skill

### Step 1: Read the Compass Entry

Start by reading `filament-compass/COMPASS.md` for:
- Quick namespace reference
- Common mistakes
- Structure overview
- Links to detailed documentation

### Step 2: Consult Package Documentation

Based on the task, read from `filament-compass/packages/`:

| Task | Read |
|------|------|
| Create Resource | `filament-compass/packages/panels/resources.md` |
| Build Form | `filament-compass/packages/forms/components.md` |
| Configure Table | `filament-compass/packages/tables/columns.md`, `filament-compass/packages/tables/filters.md` |
| Add Actions | `filament-compass/packages/actions/overview.md`, `filament-compass/packages/actions/catalog.md` |
| Layout Components | `filament-compass/packages/schemas/layout.md` |
| Read-only Display | `filament-compass/packages/infolists/entries.md` |
| Notifications | `filament-compass/packages/notifications/overview.md` |

### Step 3: Apply Patterns

Read from `filament-compass/patterns/` for implementation patterns:

| Pattern | File |
|---------|------|
| Separated concerns | `filament-compass/patterns/separated-concerns.md` |
| Conditional fields | `filament-compass/patterns/conditional-fields.md` |
| State transitions | `filament-compass/patterns/state-transitions.md` |
| Relationships | `filament-compass/patterns/relationships.md` |
| Import/Export | `filament-compass/patterns/imports-exports.md` |
| Authorization | `filament-compass/patterns/authorization.md` |

### Step 4: Follow Recipes

For step-by-step implementation, read from `filament-compass/recipes/`:

- `filament-compass/recipes/quick-start.md` - Minimal setup
- `filament-compass/recipes/crud-resource.md` - Complete CRUD
- `filament-compass/recipes/master-detail.md` - With RelationManagers
- `filament-compass/recipes/wizard-form.md` - Multi-step forms
- `filament-compass/recipes/dashboard.md` - Custom dashboard
- `filament-compass/recipes/custom-page.md` - Custom pages

### Step 5: Reference Tables

Use `filament-compass/reference/` for quick lookup:

- `filament-compass/reference/namespaces.md` - Import statements
- `filament-compass/reference/artisan-commands.md` - CLI commands
- `filament-compass/reference/common-mistakes.md` - Pitfalls to avoid
- `filament-compass/reference/breaking-changes.md` - v5 migration

## Planning Mode

When asked to plan a Filament application:

1. **Identify entities** → Map to Resources
2. **Identify relationships** → Map to RelationManagers
3. **Identify state flows** → Map to Actions
4. **Identify permissions** → Map to Policies

Then produce:
- Resource definitions
- Form schemas
- Table configurations
- Action definitions
- Authorization rules

Read `filament-compass/COMPASS.md` section "Planning a Filament Application" for the complete process.

## Quick Code Patterns

### Resource

```php
use Filament\Resources\Resource;
use Filament\Support\Icons\Heroicon;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
    
    public static function form(Schema $schema): Schema { ... }
    public static function table(Table $table): Table { ... }
    public static function getPages(): array { ... }
}
```

### Form Field

```php
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Utilities\Get;

TextInput::make('name')
    ->required()
    ->live(onBlur: true)
    ->afterStateUpdated(fn (Set $set, $state) => $set('slug', Str::slug($state)))
```

### Table Column

```php
use Filament\Tables\Columns\TextColumn;

TextColumn::make('name')
    ->searchable()
    ->sortable()
    ->weight(FontWeight::Medium)
```

### Action

```php
use Filament\Actions\Action;

Action::make('approve')
    ->icon(Heroicon::Check)
    ->color('success')
    ->action(fn (Order $record) => $record->update(['status' => 'approved']))
```

### Conditional Visibility

```php
use Filament\Schemas\Components\Utilities\Get;

TextInput::make('company_name')
    ->visible(fn (Get $get): bool => $get('type') === 'business')
```

## Testing Patterns

Read `filament-compass/testing/overview.md`, `filament-compass/testing/resources.md`, `filament-compass/testing/actions.md`, `filament-compass/testing/tables.md` for:

```php
// List page test
livewire(ListProducts::class)
    ->assertCanSeeTableRecords($products)
    ->searchTable('name');

// Create test
livewire(CreateProduct::class)
    ->fillForm(['name' => 'Test'])
    ->call('create')
    ->assertNotified();

// Action test
livewire(ListProducts::class)
    ->callTableAction(DeleteAction::class, $product);
```

## Version Info

- Filament: v5
- Laravel: v12
- Livewire: v4

## Do NOT

- Do NOT provide Filament help without reading the compass first
- Do NOT use incorrect namespaces (check `reference/namespaces.md`)
- Do NOT use string icons - use `Heroicon` enum
- Do NOT forget `visibility('public')` for file uploads
- Do NOT forget `->columnSpan()` for Grid/Section components