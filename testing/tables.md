# Testing Tables

> Testing Filament table functionality (columns, filters, sorting).

## Columns

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;
use function Pest\Livewire\livewire;

it('displays product columns', function () {
    Product::factory()->create(['name' => 'Test Product']);
    
    livewire(ListProducts::class)
        ->assertTableColumnExists('name')
        ->assertTableColumnExists('price')
        ->assertTableColumnExists('brand.name');
});

it('formats price column correctly', function () {
    $product = Product::factory()->create(['price' => 99.99]);
    
    livewire(ListProducts::class)
        ->assertTableColumnFormatted('price', '99.99', $product);
});
```

## Sorting

```php
it('can sort products by name', function () {
    $productA = Product::factory()->create(['name' => 'Alpha']);
    $productB = Product::factory()->create(['name' => 'Beta']);
    $productC = Product::factory()->create(['name' => 'Gamma']);
    
    livewire(ListProducts::class)
        ->sortTable('name', 'asc')
        ->assertCanSeeTableRecords([$productA, $productB, $productC], inOrder: true)
        
        ->sortTable('name', 'desc')
        ->assertCanSeeTableRecords([$productC, $productB, $productA], inOrder: true);
});

it('can sort products by price', function () {
    $productA = Product::factory()->create(['price' => 100]);
    $productB = Product::factory()->create(['price' => 200]);
    
    livewire(ListProducts::class)
        ->sortTable('price', 'asc')
        ->assertCanSeeTableRecords([$productA, $productB], inOrder: true);
});
```

## Searching

```php
it('can search products by name', function () {
    $product = Product::factory()->create(['name' => 'Laptop']);
    $other = Product::factory()->create(['name' => 'Phone']);
    
    livewire(ListProducts::class)
        ->searchTable('Laptop')
        ->assertCanSeeTableRecords([$product])
        ->assertCanNotSeeTableRecords([$other]);
});

it('can search products by multiple columns', function () {
    $productA = Product::factory()->create(['name' => 'Laptop', 'sku' => 'SKU-001']);
    $productB = Product::factory()->create(['name' => 'Phone', 'sku' => 'SKU-002']);
    
    livewire(ListProducts::class)
        ->searchTable('SKU-001')
        ->assertCanSeeTableRecords([$productA])
        ->assertCanNotSeeTableRecords([$productB]);
});
```

## Filters

```php
it('can filter products by status', function () {
    $visible = Product::factory()->create(['is_visible' => true]);
    $hidden = Product::factory()->create(['is_visible' => false]);
    
    livewire(ListProducts::class)
        ->filterTable('is_visible', true)
        ->assertCanSeeTableRecords([$visible])
        ->assertCanNotSeeTableRecords([$hidden]);
});

it('can filter products by brand', function () {
    $brandA = Brand::factory()->create();
    $brandB = Brand::factory()->create();
    
    $productA = Product::factory()->create(['brand_id' => $brandA->id]);
    $productB = Product::factory()->create(['brand_id' => $brandB->id]);
    
    livewire(ListProducts::class)
        ->filterTable('brand_id', $brandA->id)
        ->assertCanSeeTableRecords([$productA])
        ->assertCanNotSeeTableRecords([$productB]);
});

it('can remove filters', function () {
    $visible = Product::factory()->create(['is_visible' => true]);
    $hidden = Product::factory()->create(['is_visible' => false]);
    
    livewire(ListProducts::class)
        ->filterTable('is_visible', true)
        ->removeTableFilter('is_visible')
        ->assertCanSeeTableRecords([$visible, $hidden]);
});
```

## Pagination

```php
it('paginates products', function () {
    Product::factory()->count(15)->create();
    
    livewire(ListProducts::class)
        ->assertCountTableRecords(10);  // Default pagination
});

it('can change pagination per page', function () {
    Product::factory()->count(30)->create();
    
    livewire(ListProducts::class)
        ->set('tableRecordsPerPage', 25)
        ->assertCountTableRecords(25);
});
```

## Reordering

```php
it('can reorder products', function () {
    $productA = Product::factory()->create(['sort_order' => 1]);
    $productB = Product::factory()->create(['sort_order' => 2]);
    
    livewire(ListProducts::class)
        ->call('reorderTable', [
            ['id' => $productB->id],
            ['id' => $productA->id],
        ]);
    
    expect($productA->fresh()->sort_order)->toBe(2);
    expect($productB->fresh()->sort_order)->toBe(1);
});
```

## Column Visibility

```php
it('can toggle column visibility', function () {
    Product::factory()->create(['description' => 'Test Description']);
    
    livewire(ListProducts::class)
        ->toggleTableColumnVisibility('description')
        ->assertTableColumnHidden('description');
});
```

## Related

- [overview.md](overview.md) - Testing overview
- [resources.md](resources.md) - Resource testing
- [actions.md](actions.md) - Action testing