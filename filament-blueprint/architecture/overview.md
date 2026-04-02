# Architecture Overview

> Package hierarchy, dependencies, and core concepts.

## Package Hierarchy

Filament packages follow a layered architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                        PANELS                                │
│  Full admin framework: Resources, Pages, Dashboard, Auth    │
├─────────────────────────────────────────────────────────────┤
│   FORMS   │  TABLES  │ INFOLISTS │ ACTIONS │ NOTIFS │ WIDGETS│
│  Input    │  Data    │  Read-only│ Buttons │ Alerts │ Charts │
│  fields   │  display │  display  │ + modals│        │ Stats  │
├─────────────────────────────────────────────────────────────┤
│                        SCHEMAS                               │
│  Layout components: Grid, Section, Tabs, Wizard, Fieldset   │
├─────────────────────────────────────────────────────────────┤
│                        SUPPORT                               │
│  Base utilities: Icons, Colors, helpers, Livewire base      │
└─────────────────────────────────────────────────────────────┘
```

### Package Dependencies

```
support        → no dependencies (base layer)
schemas        → depends on support
forms          → depends on schemas, support
tables         → depends on schemas, support
infolists      → depends on schemas, support
actions        → depends on schemas, support, forms
notifications  → depends on support
widgets        → depends on support, tables
panels         → depends on ALL above packages
```

### Package Purpose

| Package | Purpose | Key Classes |
|---------|---------|-------------|
| `support` | Base utilities | `Heroicon`, colors, helpers |
| `schemas` | Layout & structure | `Grid`, `Section`, `Tabs`, `Wizard` |
| `forms` | User input | `TextInput`, `Select`, `FileUpload`, `Repeater` |
| `tables` | Data display | `TextColumn`, `Filter`, `Action` |
| `infolists` | Read-only display | `TextEntry`, `ImageEntry` |
| `actions` | Operations | `Action`, `DeleteAction`, `CreateAction` |
| `notifications` | User alerts | `Notification` |
| `widgets` | Dashboard stats | `ChartWidget`, `StatsOverviewWidget` |
| `panels` | Admin framework | `Resource`, `Panel`, `Page` |

## Core Concepts

### Schema

A **schema** is a structured collection of components. Used by:
- Forms (input schema)
- Tables (column schema, filter schema)
- Infolists (entry schema)

```php
use Filament\Schemas\Schema;

public static function form(Schema $schema): Schema
{
    return $schema
        ->components([
            TextInput::make('name'),
            Select::make('status'),
        ]);
}
```

### Resource

A **resource** is a CRUD interface for an Eloquent model. Contains:
- Form schema (create/edit)
- Table configuration (list)
- Pages (List, Create, Edit, View)
- Relation managers (optional)

```php
use Filament\Resources\Resource;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    public static function form(Schema $schema): Schema { ... }
    public static function table(Table $table): Table { ... }
    public static function getPages(): array { ... }
}
```

### Action

An **action** is a button with optional modal form and logic. Used in:
- Tables (row actions, bulk actions)
- Pages (header actions)
- Forms (field actions)

```php
use Filament\Actions\Action;

Action::make('approve')
    ->icon(Heroicon::Check)
    ->action(fn (Order $record) => $record->update(['status' => 'approved']))
```

### Component

All UI elements follow the component pattern:
- Created with `make($name)` static factory
- Configured with fluent chainable methods
- Supports `Closure` for dynamic values

```php
Component::make('name')
    ->property(value)          // static value
    ->property(fn () => value) // dynamic via Closure
```

## Server-Driven UI (SDUI)

Filament uses SDUI architecture:
- UI defined in PHP (not Blade templates)
- State managed by Livewire
- Frontend receives configuration objects
- No client-side business logic

Benefits:
- Type-safe configuration
- IDE autocompletion
- Testable in PHP
- Reusable components

## Livewire Integration

All Filament pages are Livewire components:
- Resources → Livewire pages (List, Create, Edit, View)
- Widgets → Livewire components
- Custom pages → Livewire components

Livewire powers:
- Real-time validation
- Dynamic visibility
- State management
- AJAX interactions

## Plugin Architecture

Filament supports plugins for:
- Authentication providers
- Media management (Spatie Media Library)
- Tags (Spatie Tags)
- Settings (Spatie Settings)
- Billing (Laravel Spark)

Plugins add:
- Form components
- Table columns
- Infolist entries
- Panel features

## Extension Points

Filament is designed for extension:
- NO `final` classes (users can extend)
- NO `readonly` classes (users can extend)
- Traits in `Concerns/` directories
- Interfaces in `Contracts/` directories

Extension patterns:
```php
// Extend a component
class CustomTextInput extends TextInput
{
    public function customMethod(): static
    {
        // custom logic
        return $this;
    }
}

// Use a concern trait
use Filament\Forms\Components\Concerns\HasCustomLabel;
```

## Related

- [naming-conventions.md](naming-conventions.md) - Variable/method naming
- [directory-structure.md](directory-structure.md) - File locations