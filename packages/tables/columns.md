# Tables - Columns

> Package: `filament/tables` | All table column types.

## Namespace

```php
use Filament\Tables\Columns\{Column};
```

## Available Columns

| Column | Purpose | Namespace |
|--------|---------|-----------|
| `TextColumn` | Text display | `Filament\Tables\Columns\TextColumn` |
| `IconColumn` | Icon display | `Filament\Tables\Columns\IconColumn` |
| `ImageColumn` | Image display | `Filament\Tables\Columns\ImageColumn` |
| `ColorColumn` | Color display | `Filament\Tables\Columns\ColorColumn` |
| `BooleanColumn` | Boolean icon | `Filament\Tables\Columns\BooleanColumn` |
| `BadgeColumn` | Badge display | `Filament\Tables\Columns\BadgeColumn` |
| `CheckboxColumn` | Inline checkbox | `Filament\Tables\Columns\CheckboxColumn` |
| `SelectColumn` | Inline select | `Filament\Tables\Columns\SelectColumn` |
| `TextInputColumn` | Inline text input | `Filament\Tables\Columns\TextInputColumn` |
| `ToggleColumn` | Inline toggle | `Filament\Tables\Columns\ToggleColumn` |
| `TagsColumn` | Tags display | `Filament\Tables\Columns\TagsColumn` |

## TextColumn

Display text content.

```php
use Filament\Tables\Columns\TextColumn;

TextColumn::make('name')
    ->label('Product Name')
    ->searchable()
    ->sortable()
    ->weight(FontWeight::Medium)
```

### Text Formatting

```php
TextColumn::make('price')
    ->money('USD')           // Format as money
    ->numeric(decimalPlaces: 2)  // Format as number
    ->formatStateUsing(fn ($state) => number_format($state, 2))

TextColumn::make('created_at')
    ->date()                 // Format as date
    ->dateTime()             // Format as datetime
    ->since()                // "2 hours ago"
    ->timezone('America/New_York')

TextColumn::make('status')
    ->badge()                // Badge styling
    ->color(fn ($state) => match ($state) {
        'draft' => 'gray',
        'published' => 'success',
        'archived' => 'danger',
    })

TextColumn::make('description')
    ->limit(50)              // Truncate with "..."
    ->limit(50, end: ' (...)')  // Custom end
    ->words(10)              // Limit by words
    ->lineClamp(2)           // Multi-line truncate
```

### Relationships

```php
TextColumn::make('brand.name')    // Dot notation for relationship
TextColumn::make('author.email')
```

### Links

```php
TextColumn::make('name')
    ->url(fn ($record) => route('products.view', $record))
    ->openUrlInNewTab()

TextColumn::make('website')
    ->url(fn ($record) => $record->website)
    ->icon('heroicon-o-link')
```

### Custom State

```php
TextColumn::make('full_name')
    ->state(fn ($record) => "{$record->first_name} {$record->last_name}")
```

### Searchable & Sortable

```php
TextColumn::make('name')
    ->searchable()
    ->sortable()
    ->searchable(isIndividual: true)  // Search only this column
    ->sortable(query: fn ($query, $direction) => $query->orderBy('name', $direction))
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
TextColumn::make('name')
    ->searchable()
    ->sortable()
    ->weight(FontWeight::Medium)

TextColumn::make('brand.name')
    ->searchable()
    ->sortable()
    ->toggleable()

TextColumn::make('price')
    ->searchable()
    ->sortable()

TextColumn::make('published_at')
    ->label('Publishing date')
    ->date()
    ->sortable()
    ->toggleable()
    ->toggledHiddenByDefault()
```

## IconColumn

Display icons.

```php
use Filament\Tables\Columns\IconColumn;

IconColumn::make('is_active')
    ->boolean()              // Boolean icons (check/cross)
```

### Boolean Icons

```php
IconColumn::make('is_active')
    ->boolean()
    ->trueIcon('heroicon-o-check-circle')
    ->falseIcon('heroicon-o-x-circle')
    ->trueColor('success')
    ->falseColor('danger')
```

### Custom Icons

```php
IconColumn::make('status')
    ->icon(fn ($state) => match ($state) {
        'draft' => 'heroicon-o-pencil',
        'published' => 'heroicon-o-check',
        'archived' => 'heroicon-o-archive',
    })
    ->color(fn ($state) => match ($state) {
        'draft' => 'gray',
        'published' => 'success',
        'archived' => 'danger',
    })
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
IconColumn::make('is_visible')
    ->label('Visibility')
    ->sortable()
    ->toggleable()
```

## ImageColumn

Display images.

```php
use Filament\Tables\Columns\ImageColumn;

ImageColumn::make('avatar')
    ->circular()
    ->width(40)
    ->height(40)
    ->defaultImageUrl(fn () => asset('default-avatar.png'))
```

### From Storage

```php
ImageColumn::make('image')
    ->disk('s3')
    ->visibility('public')
```

### Spatie Media Library

```php
use Filament\Tables\Columns\SpatieMediaLibraryImageColumn;

SpatieMediaLibraryImageColumn::make('image')
    ->collection('product-images')
    ->conversion('thumb')
    ->circular()
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
SpatieMediaLibraryImageColumn::make('image')
    ->collection('product-images')
    ->conversion('thumb')
```

## ColorColumn

Display color swatch.

```php
use Filament\Tables\Columns\ColorColumn;

ColorColumn::make('background_color')
    ->copyable()
    ->copyableState(fn ($state) => $state)
```

## BadgeColumn

Display badge with color.

```php
use Filament\Tables\Columns\BadgeColumn;

BadgeColumn::make('status')
    ->colors([
        'draft' => 'gray',
        'published' => 'success',
        'archived' => 'danger',
    ])
```

Note: `TextColumn::make('status')->badge()` is preferred.

## CheckboxColumn

Inline checkbox for boolean.

```php
use Filament\Tables\Columns\CheckboxColumn;

CheckboxColumn::make('is_active')
    ->label('Active')
    ->sortable()
```

## SelectColumn

Inline select dropdown.

```php
use Filament\Tables\Columns\SelectColumn;

SelectColumn::make('status')
    ->options([
        'draft' => 'Draft',
        'published' => 'Published',
    ])
    ->sortable()
    ->selectablePlaceholder(false)
```

### With Relationship

```php
SelectColumn::make('brand_id')
    ->options(Brand::pluck('name', 'id'))
    ->sortable()
```

## TextInputColumn

Inline text input.

```php
use Filament\Tables\Columns\TextInputColumn;

TextInputColumn::make('price')
    ->rules(['numeric', 'min:0'])
    ->sortable()
```

## ToggleColumn

Inline toggle switch.

```php
use Filament\Tables\Columns\ToggleColumn;

ToggleColumn::make('is_visible')
    ->label('Visibility')
    ->sortable()
    ->onColor('success')
    ->offColor('danger')
```

## TagsColumn

Display tags/badges array.

```php
use Filament\Tables\Columns\TagsColumn;

TagsColumn::make('tags')
    ->separator(',')
    ->limit(3)
```

## Common Column Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `label()` | Custom label | `->label('Product Name')` |
| `sortable()` | Enable sorting | `->sortable()` |
| `searchable()` | Enable search | `->searchable()` |
| `toggleable()` | Show/hide toggle | `->toggleable()` |
| `toggledHiddenByDefault()` | Hidden by default | `->toggledHiddenByDefault()` |
| `hidden()` | Hidden column | `->hidden()` |
| `visible()` | Visible conditionally | `->visible(fn () => true)` |
| `alignment()` | Text alignment | `->alignment('center')` or `Alignment::Center` |
| `width()` | Column width | `->width('100px')` |
| `grow()` | Expand width | `->grow(false)` |
| `wrap()` | Wrap text | `->wrap()` |
| `copyable()` | Copy to clipboard | `->copyable()` |
| `copyMessage()` | Copy message | `->copyMessage('Copied!')` |
| `tooltip()` | Tooltip text | `->tooltip(fn ($record) => $record->description)` |
| `placeholder()` | Empty placeholder | `->placeholder('N/A')` |
| `default()` | Default value | `->default('Unknown')` |
| `extraAttributes()` | HTML attributes | `->extraAttributes(['class' => 'font-bold'])` |
| `action()` | Click action | `->action(fn ($record) => ...)` |

## Column Groups

```php
use Filament\Tables\Columns\ColumnGroup;

ColumnGroup::make('Product Details')
    ->columns([
        TextColumn::make('name'),
        TextColumn::make('sku'),
        TextColumn::make('price'),
    ])
    ->collapsible()
```

## Related

- [filters.md](filters.md) - Table filters
- [actions.md](actions.md) - Table actions
- [summaries.md](summaries.md) - Column summaries
- [../forms/components.md](../forms/components.md) - Form fields