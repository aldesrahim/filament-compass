# Common Mistakes

> Frequently made mistakes when using Filament.

## Namespace Mistakes

### Wrong Action Namespaces

❌ **Wrong**:
```php
use Filament\Tables\Actions\EditAction;
use Filament\Tables\Actions\DeleteAction;
use Filament\Pages\Actions\CreateAction;
```

✅ **Correct**:
```php
use Filament\Actions\EditAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\CreateAction;
```

All actions use `Filament\Actions\` namespace, regardless of where they're used.

### Wrong Layout Component Namespace

❌ **Wrong**:
```php
use Filament\Forms\Components\Grid;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Tabs;
```

✅ **Correct**:
```php
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Tabs;
```

Layout components (Grid, Section, Tabs, Wizard, Fieldset, Group) are in `Filament\Schemas\Components\`.

### Wrong Utility Namespace

❌ **Wrong**:
```php
use Filament\Forms\Components\Get;
use Filament\Forms\Components\Set;
```

✅ **Correct**:
```php
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Components\Utilities\Set;
```

## Icon Mistakes

### Using String Icons

❌ **Wrong**:
```php
protected static ?string $navigationIcon = 'heroicon-o-bolt';

Action::make('edit')->icon('heroicon-o-pencil');
```

✅ **Correct**:
```php
use Filament\Support\Icons\Heroicon;

protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;

Action::make('edit')->icon(Heroicon::PencilSquare);
```

Use the `Heroicon` enum for type safety and IDE autocompletion.

## File Upload Mistakes

### Wrong Visibility

❌ **Wrong**:
```php
FileUpload::make('avatar')
    ->image();
// Default visibility is 'private' - file won't be publicly accessible
```

✅ **Correct**:
```php
FileUpload::make('avatar')
    ->image()
    ->visibility('public');
```

In Filament v5, file visibility defaults to `private`.

## Grid/Section Mistakes

### Missing Column Span

❌ **Wrong**:
```php
Grid::make(3)
    ->schema([
        Section::make('Details')
            ->schema([...]),
        // Section doesn't span all columns
    ])
```

✅ **Correct**:
```php
Grid::make(3)
    ->schema([
        Section::make('Details')
            ->schema([...])
            ->columnSpan(2),  // Explicitly set columns
        
        Section::make('Sidebar')
            ->schema([...])
            ->columnSpan(1),
    ])
```

In Filament v5, Grid, Section, and Fieldset no longer span all columns by default.

## Form Field Mistakes

### Disabled But Not Dehydrated

❌ **Wrong**:
```php
TextInput::make('total')
    ->disabled();
// Value won't be saved because disabled fields are not submitted
```

✅ **Correct**:
```php
TextInput::make('total')
    ->disabled()
    ->dehydrated();  // Include in form data
```

### Missing live() for Conditional Fields

❌ **Wrong**:
```php
Select::make('type')
    ->options(['personal', 'business']);

TextInput::make('company_name')
    ->visible(fn (Get $get) => $get('type') === 'business');
// Won't update because Select isn't live
```

✅ **Correct**:
```php
Select::make('type')
    ->options(['personal', 'business'])
    ->live();  // Triggers re-render

TextInput::make('company_name')
    ->visible(fn (Get $get) => $get('type') === 'business');
```

## Relationship Field Mistakes

### Wrong Relationship Syntax

❌ **Wrong**:
```php
Select::make('brand')
    ->relationship('brand', 'name');
// Should use foreign key name
```

✅ **Correct**:
```php
Select::make('brand_id')
    ->relationship('brand', 'name');
// Use the foreign key column name
```

### Missing multiple() for ManyToMany

❌ **Wrong**:
```php
Select::make('categories')
    ->relationship('categories', 'name');
// Only allows single selection
```

✅ **Correct**:
```php
Select::make('categories')
    ->relationship('categories', 'name')
    ->multiple();  // Enable multiple selection
```

## Table Mistakes

### Wrong Column for Relationships

❌ **Wrong**:
```php
TextColumn::make('brand_id');
// Shows ID, not name
```

✅ **Correct**:
```php
TextColumn::make('brand.name');
// Uses dot notation to access relationship
```

### Missing sortable() or searchable()

❌ **Wrong**:
```php
TextColumn::make('name');
// Can't sort or search
```

✅ **Correct**:
```php
TextColumn::make('name')
    ->sortable()
    ->searchable();
```

## Action Mistakes

### Wrong Action Location

❌ **Wrong**:
```php
// In resource table()
->actions([  // Wrong method
    EditAction::make(),
])
```

✅ **Correct**:
```php
->recordActions([  // Correct method
    EditAction::make(),
])
```

### Wrong Bulk Action Location

❌ **Wrong**:
```php
->recordActions([
    DeleteBulkAction::make(),  // Bulk action in row actions
])
```

✅ **Correct**:
```php
->toolbarActions([
    BulkActionGroup::make([
        DeleteBulkAction::make(),
    ]),
])
```

## Variable Naming Mistakes

❌ **Wrong**:
```php
$e = $record->error;
$comp = $this->component;
$rec = $this->record;
```

✅ **Correct**:
```php
$error = $record->error;
$component = $this->component;
$record = $this->record;
```

Always use descriptive variable names. Only abbreviations like `$id` and `$url` are acceptable.

## Related

- [namespaces.md](namespaces.md) - Namespace reference
- [breaking-changes.md](breaking-changes.md) - Breaking changes
- [../architecture/naming-conventions.md](../architecture/naming-conventions.md) - Naming conventions