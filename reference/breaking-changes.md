# Breaking Changes in v5

> Important breaking changes when upgrading to Filament v5.

## File Upload Visibility

**Change**: File uploads now default to `private` visibility instead of `public`.

**Impact**: Files uploaded without explicit visibility won't be publicly accessible.

**Migration**:
```php
// Before (v4) - public by default
FileUpload::make('avatar')->image();

// After (v5) - private by default
FileUpload::make('avatar')
    ->image()
    ->visibility('public');  // Add explicit visibility
```

## Grid/Section Column Span

**Change**: `Grid`, `Section`, and `Fieldset` no longer span all columns by default.

**Impact**: Layouts may appear broken after upgrade.

**Migration**:
```php
// Before (v4) - spans all columns by default
Section::make('Details')
    ->schema([...]);

// After (v5) - must specify column span
Section::make('Details')
    ->schema([...])
    ->columnSpan(2);  // or 'full' for all columns

// Or in Grid
Grid::make(3)
    ->schema([
        Section::make('Main')->columnSpan(2),
        Section::make('Sidebar')->columnSpan(1),
    ])
```

## Action Namespace Change

**Change**: All actions moved to `Filament\Actions\` namespace.

**Impact**: Import statements and action references will break.

**Migration**:
```php
// Before (v4)
use Filament\Tables\Actions\EditAction;
use Filament\Tables\Actions\DeleteAction;
use Filament\Pages\Actions\CreateAction;

// After (v5)
use Filament\Actions\EditAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\CreateAction;
```

All actions now use unified `Filament\Actions\` namespace.

## Schema Utilities Namespace

**Change**: `Get` and `Set` utilities moved to `Filament\Schemas\Components\Utilities\`.

**Impact**: Import statements will break.

**Migration**:
```php
// Before (v4)
use Filament\Forms\Components\Get;
use Filament\Forms\Components\Set;

// After (v5)
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Components\Utilities\Set;
```

## Layout Components Namespace

**Change**: Layout components moved from `Filament\Forms\Components\` to `Filament\Schemas\Components\`.

**Impact**: Import statements for Grid, Section, Tabs, Wizard, etc. will break.

**Migration**:
```php
// Before (v4)
use Filament\Forms\Components\Grid;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Tabs;
use Filament\Forms\Components\Wizard;

// After (v5)
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Tabs;
use Filament\Schemas\Components\Wizard;
```

## Form/Infolist Schema Method

**Change**: Forms and Infolists use `Schema` object instead of returning arrays.

**Impact**: Resource form() and table() methods need updating.

**Migration**:
```php
// Before (v4)
public static function form(): array
{
    return [
        TextInput::make('name'),
    ];
}

// After (v5)
use Filament\Schemas\Schema;

public static function form(Schema $schema): Schema
{
    return $schema
        ->components([
            TextInput::make('name'),
        ]);
}
```

## Table Configuration

**Change**: Table actions and bulk actions use new methods.

**Migration**:
```php
// Before (v4)
->actions([
    EditAction::make(),
])
->bulkActions([
    DeleteBulkAction::make(),
])

// After (v5)
->recordActions([
    EditAction::make(),
])
->toolbarActions([
    BulkActionGroup::make([
        DeleteBulkAction::make(),
    ]),
])
```

## Icon Usage

**Change**: Icons should use `Heroicon` enum instead of strings.

**Migration**:
```php
// Before (v4)
protected static ?string $navigationIcon = 'heroicon-o-bolt';

// After (v5)
use Filament\Support\Icons\Heroicon;

protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
```

## CSS Hook Classes

**Change**: Some CSS class names may have changed.

**Impact**: Custom CSS targeting Filament classes may need updates.

## Upgrade Command

Run the upgrade command to help with migration:

```bash
php artisan filament:upgrade
```

## Upgrade Guide

Always check the official upgrade guide for complete details:

`filament/docs/14-upgrade-guide.md`

## Related

- [namespaces.md](namespaces.md) - Namespace reference
- [common-mistakes.md](common-mistakes.md) - Common pitfalls