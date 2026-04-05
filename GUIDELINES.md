# Filament Compass Guidelines

> This file contains guidelines for Laravel Boost. Copy relevant sections to your CLAUDE.md file.

## Filament Guidelines Format

Add this to your CLAUDE.md within the `<laravel-boost-guidelines>` section:

```markdown
=== filament/filament rules ===

# Filament

Filament is a Server-Driven UI (SDUI) framework for Laravel that lets you define user interfaces in PHP using structured configuration objects. Built on Livewire, Alpine.js, and Tailwind CSS.

## Critical Namespace Rules

**All actions use unified namespace:**
- ❌ WRONG: `Filament\Tables\Actions\EditAction`, `Filament\Pages\Actions\CreateAction`
- ✅ CORRECT: `Filament\Actions\EditAction`, `Filament\Actions\CreateAction`

**Layout components location:**
- ❌ WRONG: `Filament\Forms\Components\Grid`, `Filament\Forms\Components\Section`
- ✅ CORRECT: `Filament\Schemas\Components\Grid`, `Filament\Schemas\Components\Section`

**Schema utilities location:**
- ❌ WRONG: `Filament\Forms\Components\Get`, `Filament\Forms\Components\Set`
- ✅ CORRECT: `Filament\Schemas\Components\Utilities\Get`, `Filament\Schemas\Components\Utilities\Set`

## Quick Namespace Reference

| Category | Namespace |
|----------|-----------|
| Form fields | `Filament\Forms\Components\` |
| Table columns | `Filament\Tables\Columns\` |
| Infolist entries | `Filament\Infolists\Components\` |
| Layout components | `Filament\Schemas\Components\` |
| Actions | `Filament\Actions\` |
| Icons | `Filament\Support\Icons\Heroicon` |

## Icons

Always use `Heroicon` enum instead of strings:

```php
// GOOD
use Filament\Support\Icons\Heroicon;

protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
Action::make('edit')->icon(Heroicon::PencilSquare);

// BAD
protected static ?string $navigationIcon = 'heroicon-o-bolt';
```

## Breaking Changes in v5

1. **File visibility defaults to `private`** - Use `->visibility('public')` for public access
2. **Grid/Section/Fieldset don't span all columns** - Use `->columnSpan(2)` or `->columnSpan('full')`
3. **Actions unified namespace** - All actions in `Filament\Actions\`

## Patterns

### Conditional Fields with Get/Set

```php
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Components\Utilities\Set;

Select::make('type')
    ->options(['personal', 'business'])
    ->live()

TextInput::make('company_name')
    ->visible(fn (Get $get): bool => $get('type') === 'business')
```

### Form Schema in Resource

```php
use Filament\Schemas\Schema;

public static function form(Schema $schema): Schema
{
    return $schema
        ->components([
            TextInput::make('name')->required(),
        ]);
}
```

### Table with Actions

```php
use Filament\Tables\Table;

public static function table(Table $table): Table
{
    return $table
        ->columns([
            TextColumn::make('name')->searchable(),
        ])
        ->recordActions([
            EditAction::make(),
        ])
        ->toolbarActions([
            BulkActionGroup::make([
                DeleteBulkAction::make(),
            ]),
        ]);
}
```

## Verification

After writing or modifying any Filament code, check if FilaCheck is installed and run it:

```bash
# Check if installed
composer show laraveldaily/filacheck 2>/dev/null && vendor/bin/filacheck --dirty
```

If installed, fix any reported issues before considering the task complete. If not installed, skip this step.

## Skills Activation

This project has Filament-specific skills available. Activate the relevant skill when working with Filament:

- `filament-compass` — Comprehensive Filament v5 documentation and patterns. Activates when creating resources, forms, tables, actions, widgets, planning Filament applications, or when the user mentions Filament, Laravel admin, CRUD, resources, or panels.

## Artisan Commands

```bash
# Create resource with separated concerns
php artisan make:filament-resource Product --generate --separate

# Create relation manager
php artisan make:filament-relation-manager OrderResource items

# Create widget
php artisan make:filament-widget SalesChart
```

## Testing

Authenticate before testing panel functionality. Filament uses Livewire:

```php
use function Pest\Livewire\livewire;

livewire(ListProducts::class)
    ->assertCanSeeTableRecords($products)
    ->searchTable('name')
    ->assertCanSeeTableRecords($products->take(1));

livewire(CreateProduct::class)
    ->fillForm(['name' => 'Test'])
    ->call('create')
    ->assertNotified();
```
```

## Integration Instructions

### For Laravel Boost Projects

1. **Copy guidelines** to your `CLAUDE.md` file inside the `<laravel-boost-guidelines>` section:

```xml
<laravel-boost-guidelines>
=== foundation rules ===
...existing rules...

=== filament/filament rules ===
[Filament guidelines from above]

=== boost rules ===
...existing rules...
</laravel-boost-guidelines>
```

2. **Install the skill** for on-demand detailed patterns:

```bash
# The SKILL.md file in filament-compass/ acts as an on-demand skill
# Point to it when working on Filament-specific tasks
```

### For Non-Boost Projects

Simply add the Filament guidelines section to your `CLAUDE.md` or `.cursorrules` file.

## What's the Difference?

| Aspect | Guidelines | Skills |
|--------|-----------|--------|
| Loading | Upfront, always loaded | On-demand, task-specific |
| Content | Essential conventions, quick reference | Detailed patterns, recipes, examples |
| Size | Compact | Comprehensive |
| Use case | Prevent common mistakes | Implement specific features |

### Guidelines (This File)
- Namespace rules
- Common mistakes to avoid
- Quick patterns
- Artisan commands
- Testing basics

### Skills (SKILL.md)
- Complete component catalogs
- Detailed implementation patterns
- Step-by-step recipes
- Testing guides
- Planning workflows