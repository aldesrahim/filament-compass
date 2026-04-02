# Tables - Filters

> Package: `filament/tables` | Filter types and QueryBuilder.

## Namespace

```php
use Filament\Tables\Filters\{Filter};
```

## Available Filters

| Filter | Purpose | Namespace |
|--------|---------|-----------|
| `Filter` | Basic filter | `Filament\Tables\Filters\Filter` |
| `SelectFilter` | Select dropdown | `Filament\Tables\Filters\SelectFilter` |
| `QueryBuilder` | Advanced query builder | `Filament\Tables\Filters\QueryBuilder` |
| `TernaryFilter` | Yes/No/Any filter | `Filament\Tables\Filters\TernaryFilter` |
| `TrashedFilter` | Soft deletes filter | `Filament\Tables\Filters\TrashedFilter` |

## Basic Filter

Simple checkbox filter.

```php
use Filament\Tables\Filters\Filter;
use Illuminate\Database\Eloquent\Builder;

Filter::make('is_featured')
    ->query(fn (Builder $query) => $query->where('is_featured', true))
    ->label('Featured Products')
```

### With Indicator

```php
Filter::make('is_featured')
    ->query(fn (Builder $query) => $query->where('is_featured', true))
    ->indicateUsing(fn (array $state) => 'Featured Products')
```

## SelectFilter

Dropdown filter.

```php
use Filament\Tables\Filters\SelectFilter;

SelectFilter::make('status')
    ->options([
        'draft' => 'Draft',
        'published' => 'Published',
        'archived' => 'Archived',
    ])
    ->attribute('status')
```

### With Relationship

```php
SelectFilter::make('brand_id')
    ->relationship('brand', 'name')
    ->searchable()
    ->preload()
```

### With Multiple

```php
SelectFilter::make('categories')
    ->relationship('categories', 'name')
    ->multiple()
```

### With Query Modification

```php
SelectFilter::make('status')
    ->options(OrderStatus::class)
    ->query(fn (Builder $query, array $state) => $query->where('status', $state['value']))
```

## TernaryFilter

Yes/No/Any (three-state) filter.

```php
use Filament\Tables\Filters\TernaryFilter;

TernaryFilter::make('is_visible')
    ->label('Visibility')
    ->placeholder('All')
    ->trueLabel('Visible')
    ->falseLabel('Hidden')
```

### With Custom Queries

```php
TernaryFilter::make('is_published')
    ->placeholder('All')
    ->trueQuery(fn (Builder $query) => $query->whereNotNull('published_at'))
    ->falseQuery(fn (Builder $query) => $query->whereNull('published_at'))
```

## TrashedFilter

Soft deletes filter.

```php
use Filament\Tables\Filters\TrashedFilter;

TrashedFilter::make('trashed')
    ->label('Deleted Records')
```

## QueryBuilder

Advanced query builder with constraints.

```php
use Filament\Tables\Filters\QueryBuilder;
use Filament\Tables\Filters\QueryBuilder\Constraints\TextConstraint;
use Filament\Tables\Filters\QueryBuilder\Constraints\NumberConstraint;
use Filament\Tables\Filters\QueryBuilder\Constraints\BooleanConstraint;
use Filament\Tables\Filters\QueryBuilder\Constraints\DateConstraint;

QueryBuilder::make()
    ->constraints([
        TextConstraint::make('name')
            ->label('Product Name'),
        NumberConstraint::make('price')
            ->icon(Heroicon::CurrencyDollar),
        BooleanConstraint::make('is_visible')
            ->label('Visibility'),
        DateConstraint::make('published_at')
            ->label('Publishing Date'),
    ])
    ->constraintPickerColumns(2)
```

### Available Constraints

| Constraint | Purpose |
|------------|---------|
| `TextConstraint` | Text search (equals, contains, starts with, etc.) |
| `NumberConstraint` | Numeric comparison (equals, greater than, etc.) |
| `BooleanConstraint` | Boolean filter |
| `DateConstraint` | Date range/comparison |
| `SelectConstraint` | Select from options |
| `RelationshipConstraint` | Filter by relationship |

### Text Constraint Operators

```php
TextConstraint::make('name')
    ->operators([
        TextConstraint\Operators\EqualsOperator::class,
        TextConstraint\Operators\ContainsOperator::class,
        TextConstraint\Operators\StartsWithOperator::class,
        TextConstraint\Operators\EndsWithOperator::class,
    ])
```

### Number Constraint Operators

```php
NumberConstraint::make('price')
    ->operators([
        NumberConstraint\Operators\EqualsOperator::class,
        NumberConstraint\Operators\GreaterThanOperator::class,
        NumberConstraint\Operators\LessThanOperator::class,
        NumberConstraint\Operators\BetweenOperator::class,
    ])
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
QueryBuilder::make()
    ->constraints([
        TextConstraint::make('name'),
        TextConstraint::make('slug'),
        TextConstraint::make('sku')
            ->label('SKU (Stock Keeping Unit)'),
        TextConstraint::make('barcode')
            ->label('Barcode (ISBN, UPC, GTIN, etc.)'),
        NumberConstraint::make('price')
            ->icon(Heroicon::CurrencyDollar),
        NumberConstraint::make('qty')
            ->label('Quantity'),
        BooleanConstraint::make('is_visible')
            ->label('Visibility'),
        DateConstraint::make('published_at')
            ->label('Publishing date'),
    ])
    ->constraintPickerColumns(2)
```

## Filter Configuration

### Layout

```php
// In table configuration
->filters([
    Filter::make('featured'),
    SelectFilter::make('status'),
], layout: FiltersLayout::AboveContent)  // or AboveContentCollapsible, BelowContent, Modal

// Alternative
->filtersLayout(FiltersLayout::AboveContentCollapsible)
```

### Defer Filters

```php
->deferFilters()  // Apply filters on form submit, not on change
```

### Filters Form Columns

```php
->filtersFormColumns(2)  // Filter form grid columns
```

## Common Filter Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `label()` | Custom label | `->label('Status')` |
| `query()` | Apply filter | `->query(fn ($query) => $query->where(...))` |
| `attribute()` | Database column | `->attribute('status')` |
| `indicateUsing()` | Indicator text | `->indicateUsing(fn ($state) => 'Active')` |
| `default()` | Default state | `->default(true)` |
| `hidden()` | Hide filter | `->hidden()` |
| `visible()` | Visible conditionally | `->visible(fn () => auth()->user()->isAdmin())` |
| `formSchema()` | Custom form | `->formSchema([...])` |
| `resetUsing()` | Reset query | `->resetUsing(fn ($query) => $query->where(...))` |

## Custom Filter Form

```php
Filter::make('price_range')
    ->formSchema([
        TextInput::make('min_price')
            ->numeric()
            ->placeholder('Min Price'),
        TextInput::make('max_price')
            ->numeric()
            ->placeholder('Max Price'),
    ])
    ->query(function (Builder $query, array $state) {
        if ($min = $state['min_price']) {
            $query->where('price', '>=', $min);
        }
        if ($max = $state['max_price']) {
            $query->where('price', '<=', $max);
        }
    })
    ->indicateUsing(fn (array $state) => 
        $state['min_price'] || $state['max_price'] 
            ? "Price: {$state['min_price']} - {$state['max_price']}" 
            : null
    )
```

## Related

- [columns.md](columns.md) - Table columns
- [actions.md](actions.md) - Table actions
- [../forms/components.md](../forms/components.md) - Form fields for filters