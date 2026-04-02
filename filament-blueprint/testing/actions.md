# Testing Actions

> Testing Filament actions (table actions, bulk actions, header actions).

## Row Actions

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;
use Filament\Actions\DeleteAction;
use Filament\Actions\EditAction;
use function Pest\Livewire\livewire;

it('can delete a product', function () {
    $product = Product::factory()->create();
    
    livewire(ListProducts::class)
        ->callTableAction(DeleteAction::class, $product)
        ->assertNotified()
        ->assertNoRedirect();
    
    $this->assertModelMissing($product);
});

it('can edit a product via action', function () {
    $product = Product::factory()->create(['price' => 100]);
    
    livewire(ListProducts::class)
        ->callTableAction('adjust_price', $product, [
            'price' => 200,
        ])
        ->assertNotified();
    
    expect($product->fresh()->price)->toBe(200.0);
});
```

## Bulk Actions

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;
use Filament\Actions\DeleteBulkAction;

it('can bulk delete products', function () {
    $products = Product::factory()->count(5)->create();
    
    livewire(ListProducts::class)
        ->callTableBulkAction(DeleteBulkAction::class, $products)
        ->assertNotified();
    
    foreach ($products as $product) {
        $this->assertModelMissing($product);
    }
});

it('can bulk update visibility', function () {
    $products = Product::factory()->count(3)->create(['is_visible' => false]);
    
    livewire(ListProducts::class)
        ->callTableBulkAction('toggle_visibility', $products, [
            'is_visible' => '1',
        ])
        ->assertNotified();
    
    foreach ($products as $product) {
        expect($product->fresh()->is_visible)->toBeTrue();
    }
});
```

## Header Actions

```php
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Models\Shop\Product;

it('can create product via header action', function () {
    $newData = Product::factory()->make();
    
    livewire(ListProducts::class)
        ->callAction('create', [
            'name' => $newData->name,
            'price' => $newData->price,
        ])
        ->assertNotified()
        ->assertRedirect();
    
    $this->assertDatabaseHas(Product::class, [
        'name' => $newData->name,
    ]);
});
```

## Action Visibility

```php
it('hides delete action for locked products', function () {
    $product = Product::factory()->create(['is_locked' => true]);
    
    livewire(ListProducts::class)
        ->assertTableActionHidden(DeleteAction::class, $product);
});

it('shows delete action for unlocked products', function () {
    $product = Product::factory()->create(['is_locked' => false]);
    
    livewire(ListProducts::class)
        ->assertTableActionVisible(DeleteAction::class, $product);
});
```

## Action Authorization

```php
it('prevents unauthorized users from deleting products', function () {
    $user = User::factory()->create(); // Non-admin
    $this->actingAs($user);
    
    $product = Product::factory()->create();
    
    livewire(ListProducts::class)
        ->assertTableActionHidden(DeleteAction::class, $product);
});
```

## Action Confirmation

```php
it('requires confirmation for delete action', function () {
    $product = Product::factory()->create();
    
    livewire(ListProducts::class)
        ->assertTableActionRequiresConfirmation(DeleteAction::class, $product);
});
```

## Custom Actions

```php
use Filament\Actions\Testing\TestAction;

it('can toggle product visibility', function () {
    $product = Product::factory()->create(['is_visible' => true]);
    
    livewire(ListProducts::class)
        ->callTableAction(
            TestAction::make('toggle_visibility')
                ->table($product)
        )
        ->assertNotified();
    
    expect($product->fresh()->is_visible)->toBeFalse();
});
```

## Related

- [overview.md](overview.md) - Testing overview
- [resources.md](resources.md) - Resource testing
- [tables.md](tables.md) - Table testing