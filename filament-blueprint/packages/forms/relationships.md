# Forms - Relationships

> Package: `filament/forms` | Fields for Eloquent relationships.

## BelongsTo (Single Select)

```php
use Filament\Forms\Components\Select;

Select::make('brand_id')
    ->relationship('brand', 'name')
    ->searchable()
    ->preload()
    ->required()
```

### With Create Option

```php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->createOptionForm([
        TextInput::make('name')->required(),
        TextInput::make('website')->url(),
    ])
    ->createOptionUsing(fn (array $data) => Brand::create($data)->id)
```

### With Edit Option

```php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->editOptionForm([
        TextInput::make('name')->required(),
    ])
    ->editOptionUsing(fn (Brand $record, array $data) => $record->update($data))
```

### Custom Query

```php
Select::make('brand_id')
    ->relationship('brand', 'name', fn (Builder $query) => $query->where('active', true))
```

### Custom Title Attribute

```php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->getOptionLabelFromRecordUsing(fn (Brand $record) => "{$record->name} ({$record->country})")
```

## ManyToMany (Multiple Select)

```php
Select::make('categories')
    ->relationship('categories', 'name')
    ->multiple()
    ->searchable()
    ->preload()
```

### With Order Column

```php
Select::make('tags')
    ->relationship('tags', 'name')
    ->multiple()
    ->orderColumn('sort_order')
```

## HasMany (Repeater)

```php
use Filament\Forms\Components\Repeater;

Repeater::make('items')
    ->relationship('items')
    ->schema([
        Select::make('product_id')
            ->relationship('product', 'name'),
        TextInput::make('quantity')
            ->numeric()
            ->default(1),
        TextInput::make('price')
            ->numeric(),
    ])
    ->columns(3)
    ->orderColumn('sort_order')
```

### With Delete Rules

```php
Repeater::make('items')
    ->relationship('items')
    ->schema([ ... ])
    ->deleteExistingItemUsing(fn (Item $item) => $item->canDelete())
```

## MorphTo (Polymorphic)

```php
use Filament\Forms\Components\MorphToSelect;

MorphToSelect::make('commentable')
    ->types([
        MorphToSelect\Type::make(Post::class)->titleAttribute('title'),
        MorphToSelect\Type::make(Video::class)->titleAttribute('name'),
    ])
    ->searchable()
```

### Custom MorphTo Options

```php
MorphToSelect::make('commentable')
    ->types([
        MorphToSelect\Type::make(Post::class)
            ->titleAttribute('title')
            ->options(fn () => Post::published()->pluck('title', 'id')),
    ])
```

## HasOne (Single Field Group)

```php
use Filament\Schemas\Components\Grid;

Grid::make(2)
    ->relationship('address')
    ->schema([
        TextInput::make('street'),
        TextInput::make('city'),
        TextInput::make('zip'),
    ])
```

## Real Examples

### BelongsTo

```php
// From: demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->searchable()
    ->hiddenOn(ProductsRelationManager::class)

Select::make('productCategories')
    ->relationship('productCategories', 'name')
    ->multiple()
    ->required()
```

### HasMany via Repeater

```php
// Order items relationship
Repeater::make('items')
    ->relationship('items')
    ->schema([
        Select::make('product_id')
            ->relationship('product', 'name')
            ->searchable(),
        TextInput::make('quantity')
            ->numeric()
            ->default(1)
            ->live()
            ->afterStateUpdated(fn ($state, Set $set, Get $get) => 
                $set('total', $state * $get('price'))
            ),
        TextInput::make('price')
            ->numeric()
            ->disabled()
            ->dehydrated(),
        TextInput::make('total')
            ->numeric()
            ->disabled()
            ->dehydrated(),
    ])
    ->columns(4)
    ->mutateRelationshipDataBeforeSaveUsing(fn (array $data) => [
        ...$data,
        'total' => $data['quantity'] * $data['price'],
    ])
```

## Relationship Methods Summary

| Method | Purpose | Example |
|--------|---------|---------|
| `relationship()` | Define relationship | `->relationship('brand', 'name')` |
| `multiple()` | ManyToMany | `->multiple()` |
| `searchable()` | Enable search | `->searchable()` |
| `preload()` | Load all options | `->preload()` |
| `orderColumn()` | Sort order column | `->orderColumn('sort')` |
| `createOptionForm()` | Create modal form | `->createOptionForm([...])` |
| `editOptionForm()` | Edit modal form | `->editOptionForm([...])` |
| `getOptionLabelFromRecordUsing()` | Custom label | `->getOptionLabelFromRecordUsing(fn ($record) => ...)` |
| `mutateRelationshipDataBeforeSaveUsing()` | Modify data before save | `->mutateRelationshipDataBeforeSaveUsing(fn ($data) => ...)` |
| `deleteExistingItemUsing()` | Custom delete logic | `->deleteExistingItemUsing(fn ($item) => ...)` |

## Related

- [components.md](components.md) - Form fields (Select, Repeater)
- [../../patterns/relationships.md](../../patterns/relationships.md) - Relationship patterns
- [../panels/resources.md](../panels/resources.md) - Resource relation managers