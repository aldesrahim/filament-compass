# Panels - Resources

> Package: `filament/panels` | Resources are CRUD interfaces for Eloquent models.

## Resource Structure

A resource defines CRUD pages, form schema, table configuration, and optional relation managers.

### Basic Resource

```php
use App\Models\Product;
use Filament\Resources\Resource;
use Filament\Support\Icons\Heroicon;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    protected static ?string $recordTitleAttribute = 'name';
    
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
    
    protected static ?string $navigationGroup = 'Shop';
    
    protected static ?int $navigationSort = 0;
    
    protected static ?string $slug = 'shop/products';
    
    public static function form(Schema $schema): Schema { ... }
    
    public static function table(Table $table): Table { ... }
    
    public static function getPages(): array { ... }
    
    public static function getRelations(): array { ... }
    
    public static function getWidgets(): array { ... }
}
```

## Resource Properties

| Property | Purpose | Example |
|----------|---------|---------|
| `$model` | Eloquent model class | `Product::class` |
| `$recordTitleAttribute` | Column for global search | `'name'` |
| `$navigationIcon` | Sidebar icon | `Heroicon::OutlinedBolt` |
| `$navigationGroup` | Sidebar group | `'Shop'` |
| `$navigationSort` | Sidebar order | `0` (first) |
| `$slug` | URL path | `'shop/products'` |
| `$navigationLabel` | Custom label | `'Products'` |
| `$modelLabel` | Singular label | `'product'` |
| `$pluralModelLabel` | Plural label | `'products'` |

## Pages

Resources define pages via `getPages()`:

```php
public static function getPages(): array
{
    return [
        'index' => ListProducts::route('/'),
        'create' => CreateProduct::route('/create'),
        'edit' => EditProduct::route('/{record}/edit'),
        'view' => ViewProduct::route('/{record}'),  // optional
    ];
}
```

### Page Types

| Page | Purpose | Generated File |
|------|---------|----------------|
| `index` (List) | Table of records | `List{Entity}.php` |
| `create` | Create new record | `Create{Entity}.php` |
| `edit` | Edit existing record | `Edit{Entity}.php` |
| `view` | View record details | `View{Entity}.php` |

### Simple Resources (Modal-based)

```bash
php artisan make:filament-resource Customer --simple
```

Uses modals for create/edit on a single "Manage" page.

## Form Schema

Define in separate class (recommended):

```php
// app/Filament/Resources/Shop/Products/Schemas/ProductForm.php
class ProductForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')->required(),
                Select::make('brand_id')->relationship('brand', 'name'),
            ]);
    }
}

// In resource:
public static function form(Schema $schema): Schema
{
    return ProductForm::configure($schema);
}
```

Or inline:

```php
public static function form(Schema $schema): Schema
{
    return $schema
        ->components([
            TextInput::make('name')->required(),
        ]);
}
```

## Table Configuration

Define in separate class (recommended):

```php
// app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
class ProductsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')->searchable()->sortable(),
            ])
            ->filters([ ... ])
            ->recordActions([ ... ])
            ->toolbarActions([ ... ]);
    }
}

// In resource:
public static function table(Table $table): Table
{
    return ProductsTable::configure($table);
}
```

## Relation Managers

For HasMany, ManyToMany relationships:

```php
public static function getRelations(): array
{
    return [
        CommentsRelationManager::class,
        TagsRelationManager::class,
    ];
}
```

Relation managers are displayed on Edit/View pages.

## Widgets

Resource-specific widgets for the list page:

```php
public static function getWidgets(): array
{
    return [
        ProductStats::class,
    ];
}

public static function getWidgetsPosition(): string
{
    return 'before'; // or 'after' table
}
```

## Global Search

Enable global search with `$recordTitleAttribute`:

```php
protected static ?string $recordTitleAttribute = 'name';

public static function getGloballySearchableAttributes(): array
{
    return ['name', 'sku', 'brand.name'];
}

public static function getGlobalSearchEloquentQuery(): Builder
{
    return parent::getGlobalSearchEloquentQuery()->with(['brand']);
}

public static function getGlobalSearchResultDetails(Model $record): array
{
    return [
        'Brand' => $record->brand->name,
    ];
}
```

## Navigation Badge

Show count in sidebar:

```php
public static function getNavigationBadge(): ?string
{
    return (string) static::$model::where('status', 'pending')->count();
}

public static function getNavigationBadgeColor(): string | array | null
{
    return 'warning'; // or 'success', 'danger', 'primary', 'gray'
}
```

## Authorization

Use model policies:

```php
// app/Policies/ProductPolicy.php
class ProductPolicy
{
    public function viewAny(User $user): bool { ... }
    public function view(User $user, Product $product): bool { ... }
    public function create(User $user): bool { ... }
    public function update(User $user, Product $product): bool { ... }
    public function delete(User $user, Product $product): bool { ... }
}
```

Or override in resource:

```php
public static function canViewAny(): bool
{
    return auth()->user()->can('view_products');
}
```

### Skip Authorization (dev/testing)

```php
// Disable all policy checks for this resource
ProductResource::skipAuthorization();
```

### Disable Policy Existence Check

By default, Filament checks that a policy exists before calling it. Disable to allow missing policies to pass silently:

```php
ProductResource::checkPolicyExistence(false);
```

## Artisan Commands

```bash
# Create resource
php artisan make:filament-resource Product --generate

# With separated concerns (recommended)
php artisan make:filament-resource Product --generate --separate

# Simple (modal) resource
php artisan make:filament-resource Customer --simple

# With soft deletes
php artisan make:filament-resource Product --soft-deletes

# With View page
php artisan make:filament-resource Product --view

# Create model, migration, factory
php artisan make:filament-resource Product --model --migration --factory
```

## Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/ProductResource.php`

```php
<?php

namespace App\Filament\Resources\Shop\Products;

use App\Filament\Resources\Shop\Products\Pages\CreateProduct;
use App\Filament\Resources\Shop\Products\Pages\EditProduct;
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Filament\Resources\Shop\Products\RelationManagers\CommentsRelationManager;
use App\Filament\Resources\Shop\Products\Schemas\ProductForm;
use App\Filament\Resources\Shop\Products\Tables\ProductsTable;
use App\Filament\Resources\Shop\Products\Widgets\ProductStats;
use App\Models\Shop\Product;
use Filament\Resources\Resource;
use Filament\Support\Icons\Heroicon;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    protected static ?string $recordTitleAttribute = 'name';
    
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
    
    protected static ?string $navigationGroup = 'Shop';
    
    protected static ?int $navigationSort = 0;
    
    protected static ?string $slug = 'shop/products';
    
    public static function form(Schema $schema): Schema
    {
        return ProductForm::configure($schema);
    }
    
    public static function table(Table $table): Table
    {
        return ProductsTable::configure($table);
    }
    
    public static function getRelations(): array
    {
        return [
            CommentsRelationManager::class,
        ];
    }
    
    public static function getWidgets(): array
    {
        return [
            ProductStats::class,
        ];
    }
    
    public static function getPages(): array
    {
        return [
            'index' => ListProducts::route('/'),
            'create' => CreateProduct::route('/create'),
            'edit' => EditProduct::route('/{record}/edit'),
        ];
    }
    
    public static function getGloballySearchableAttributes(): array
    {
        return ['name', 'sku', 'brand.name'];
    }
    
    public static function getNavigationBadge(): ?string
    {
        return (string) static::$model::whereColumn('qty', '<', 'security_stock')->count();
    }
}
```

## Related

- [pages.md](pages.md) - List, Create, Edit, View pages
- [../forms/components.md](../forms/components.md) - Form fields
- [../tables/columns.md](../tables/columns.md) - Table columns
- [../../patterns/separated-concerns.md](../../patterns/separated-concerns.md) - Separation pattern
- [../../recipes/crud-resource.md](../../recipes/crud-resource.md) - Full implementation guide