# Relationships Pattern

> Eloquent relationship patterns in Filament forms and tables.

## BelongsTo

Single relationship (foreign key).

### Form Field

```php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->searchable()
    ->preload()
    ->required()
```

### Table Column

```php
TextColumn::make('brand.name')
    ->searchable()
    ->sortable()
```

### With Create Option

```php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->createOptionForm([
        TextInput::make('name')->required(),
    ])
```

## HasMany

One-to-many relationship.

### Relation Manager

```php
<?php

namespace App\Filament\Resources\Shop\Products\RelationManagers;

use App\Models\Comment;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables\Actions\CreateAction;
use Filament\Tables\Actions\DeleteAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class CommentsRelationManager extends RelationManager
{
    protected static string $relationship = 'comments';
    
    public function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('content')->limit(50),
                TextColumn::make('user.name'),
                TextColumn::make('created_at')->dateTime(),
            ])
            ->recordActions([
                DeleteAction::make(),
            ])
            ->headerActions([
                CreateAction::make()
                    ->mutateFormDataUsing(function (array $data): array {
                        $data['user_id'] = auth()->id();
                        return $data;
                    }),
            ]);
    }
    
    public static function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Textarea::make('content')->required(),
            ]);
    }
}
```

### Repeater Field

```php
Repeater::make('items')
    ->relationship('items')
    ->schema([
        Select::make('product_id')
            ->relationship('product', 'name'),
        TextInput::make('quantity')->numeric(),
    ])
    ->orderColumn('sort_order')
```

## ManyToMany

Many-to-many relationship.

### Multiple Select

```php
Select::make('categories')
    ->relationship('categories', 'name')
    ->multiple()
    ->searchable()
    ->preload()
```

### Table Column

```php
TextColumn::make('categories.name')
    ->listWithLineBreaks()
    ->badge()
```

### Checkbox List

```php
CheckboxList::make('categories')
    ->relationship('categories', 'name')
    ->columns(2)
    ->searchable()
```

### Relation Manager

```php
class TagsRelationManager extends RelationManager
{
    protected static string $relationship = 'tags';
    
    public function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name'),
            ])
            ->recordActions([
                DetachAction::make(),  // Use Detach, not Delete
            ])
            ->headerActions([
                AttachAction::make(),  // Use Attach
            ]);
    }
}
```

## MorphTo

Polymorphic relationship.

```php
MorphToSelect::make('commentable')
    ->types([
        MorphToSelect\Type::make(Post::class)->titleAttribute('title'),
        MorphToSelect\Type::make(Video::class)->titleAttribute('name'),
    ])
    ->searchable()
```

## HasOne

One-to-one relationship.

### Grid with Relationship

```php
Grid::make(2)
    ->relationship('address')
    ->schema([
        TextInput::make('street'),
        TextInput::make('city'),
        TextInput::make('zip'),
    ])
```

## Real Example: Order with Items

### Order Form

```php
// Order belongsTo Customer
Select::make('customer_id')
    ->relationship('customer', 'name')
    ->searchable()
    ->preload()
    ->required()

// Order hasMany Items via Repeater
Repeater::make('items')
    ->relationship('items')
    ->schema([
        Select::make('product_id')
            ->relationship('product', 'name')
            ->searchable()
            ->required()
            ->live()
            ->afterStateUpdated(function ($state, Set $set) {
                $product = Product::find($state);
                $set('unit_price', $product?->price);
            }),
        
        TextInput::make('quantity')
            ->numeric()
            ->default(1)
            ->minValue(1)
            ->required()
            ->live()
            ->afterStateUpdated(function ($state, Set $set, Get $get) {
                $price = $get('unit_price') ?? 0;
                $set('total', $state * $price);
            }),
        
        TextInput::make('unit_price')
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
        'total' => $data['quantity'] * $data['unit_price'],
    ])
```

### Order Table

```php
// Customer relationship
TextColumn::make('customer.name')
    ->searchable()
    ->sortable()

// Count of items
TextColumn::make('items_count')
    ->counts('items')
    ->label('Items')

// Sum of totals
TextColumn::make('total')
    ->state(fn (Order $record) => $record->items->sum('total'))
    ->money('USD')
```

## Eager Loading

Always eager load relationships for performance:

```php
public static function getEloquentQuery(): Builder
{
    return parent::getEloquentQuery()
        ->with(['customer', 'items.product']);
}
```

## Related

- [../packages/forms/relationships.md](../packages/forms/relationships.md) - Relationship fields
- [../packages/panels/resources.md](../packages/panels/resources.md) - Relation managers