# Testing Overview

> Testing approach for Filament applications.

## Setup

Use Pest for testing. Filament provides testing utilities.

### Test Case

```php
<?php

namespace Tests;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Pest\TestSuite;

uses(RefreshDatabase::class);

beforeEach(function () {
    $this->actingAs(User::factory()->admin()->create());
});
```

## Authentication

Always authenticate before testing panel functionality:

```php
beforeEach(function () {
    $this->admin = User::factory()->admin()->create();
    $this->actingAs($this->admin);
});
```

## Livewire Testing

Filament pages are Livewire components. Use `livewire()` helper:

```php
use function Pest\Livewire\livewire;

it('can list products', function () {
    $products = Product::factory()->count(5)->create();
    
    livewire(ListProducts::class)
        ->assertCanSeeTableRecords($products);
});
```

## Available Assertions

### Table Assertions

| Method | Purpose |
|--------|---------|
| `assertCanSeeTableRecords($records)` | Records are visible |
| `assertCanNotSeeTableRecords($records)` | Records not visible |
| `assertCountTableRecords($count)` | Record count |
| `assertTableColumnExists($column)` | Column exists |
| `assertTableColumnFormatted($column, $value)` | Column formatted correctly |
| `searchTable($search)` | Search table |
| `sortTable($column, $direction)` | Sort table |
| `callTableAction($action, $record)` | Call row action |
| `callTableBulkAction($action, $records)` | Call bulk action |

### Form Assertions

| Method | Purpose |
|--------|---------|
| `fillForm($data)` | Fill form |
| `assertFormSet($data)` | Form has values |
| `call($method)` | Call component method |
| `assertHasFormErrors($errors)` | Form has errors |
| `assertHasNoFormErrors()` | Form has no errors |

### Notification Assertions

| Method | Purpose |
|--------|---------|
| `assertNotified()` | Notification sent |
| `assertNotNotified()` | No notification |

### Redirect Assertions

| Method | Purpose |
|--------|---------|
| `assertRedirect()` | Redirects |
| `assertRedirectToRoute($route)` | Redirects to route |
| `assertNoRedirect()` | No redirect |

## Related

- [resources.md](resources.md) - Resource testing
- [actions.md](actions.md) - Action testing
- [tables.md](tables.md) - Table testing