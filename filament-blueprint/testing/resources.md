# Testing Resources

> Testing Filament resources (list, create, edit, view pages).

## List Page

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;
use function Pest\Livewire\livewire;

it('can list products', function () {
    $products = Product::factory()->count(5)->create();
    
    livewire(ListProducts::class)
        ->assertCanSeeTableRecords($products)
        ->assertCountTableRecords(5);
});

it('can search products', function () {
    $product = Product::factory()->create(['name' => 'Test Product']);
    $other = Product::factory()->create(['name' => 'Other Product']);
    
    livewire(ListProducts::class)
        ->searchTable('Test')
        ->assertCanSeeTableRecords([$product])
        ->assertCanNotSeeTableRecords([$other]);
});

it('can sort products', function () {
    $productA = Product::factory()->create(['price' => 100]);
    $productB = Product::factory()->create(['price' => 200]);
    
    livewire(ListProducts::class)
        ->sortTable('price', 'asc')
        ->assertCanSeeTableRecords([$productA, $productB], inOrder: true);
});
```

## Create Page

```php
use App\Filament\Resources\Shop\Products\Pages\CreateProduct;
use App\Models\Shop\Product;

it('can create a product', function () {
    $newData = Product::factory()->make();
    
    livewire(CreateProduct::class)
        ->fillForm([
            'name' => $newData->name,
            'price' => $newData->price,
            'sku' => $newData->sku,
        ])
        ->call('create')
        ->assertNotified()
        ->assertRedirect();
    
    $this->assertDatabaseHas(Product::class, [
        'name' => $newData->name,
        'price' => $newData->price,
        'sku' => $newData->sku,
    ]);
});

it('can validate product creation', function () {
    livewire(CreateProduct::class)
        ->fillForm([
            'name' => null,
            'price' => 'invalid',
        ])
        ->call('create')
        ->assertHasFormErrors([
            'name' => 'required',
            'price' => 'numeric',
        ])
        ->assertNotNotified();
});
```

## Edit Page

```php
use App\Filament\Resources\Shop\Products\Pages\EditProduct;
use App\Models\Shop\Product;

it('can edit a product', function () {
    $product = Product::factory()->create();
    $newData = Product::factory()->make();
    
    livewire(EditProduct::class, ['record' => $product->id])
        ->fillForm([
            'name' => $newData->name,
            'price' => $newData->price,
        ])
        ->call('save')
        ->assertNotified();
    
    $this->assertDatabaseHas(Product::class, [
        'id' => $product->id,
        'name' => $newData->name,
        'price' => $newData->price,
    ]);
});

it('can populate form with existing data', function () {
    $product = Product::factory()->create();
    
    livewire(EditProduct::class, ['record' => $product->id])
        ->assertFormSet([
            'name' => $product->name,
            'price' => $product->price,
        ]);
});
```

## View Page

```php
use App\Filament\Resources\HR\Projects\Pages\ViewProject;
use App\Models\HR\Project;

it('can view a project', function () {
    $project = Project::factory()->create();
    
    livewire(ViewProject::class, ['record' => $project->id])
        ->assertSee($project->name)
        ->assertSee($project->description);
});
```

## Delete Action

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;
use Filament\Actions\DeleteAction;

it('can delete a product', function () {
    $product = Product::factory()->create();
    
    livewire(ListProducts::class)
        ->callTableAction(DeleteAction::class, $product)
        ->assertNotified();
    
    $this->assertModelMissing($product);
});
```

## Bulk Delete

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;
use Filament\Actions\DeleteBulkAction;

it('can bulk delete products', function () {
    $products = Product::factory()->count(3)->create();
    
    livewire(ListProducts::class)
        ->callTableBulkAction(DeleteBulkAction::class, $products)
        ->assertNotified();
    
    foreach ($products as $product) {
        $this->assertModelMissing($product);
    }
});
```

## Related

- [overview.md](overview.md) - Testing overview
- [actions.md](actions.md) - Action testing
- [tables.md](tables.md) - Table testing