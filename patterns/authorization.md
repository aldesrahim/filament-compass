# Authorization Pattern

> Implementing authorization with policies, gates, and permissions.

## Model Policies

### Create Policy

```bash
php artisan make:policy ProductPolicy --model=Product
```

### Policy Class

```php
<?php

namespace App\Policies;

use App\Models\Product;
use App\Models\User;

class ProductPolicy
{
    public function viewAny(User $user): bool
    {
        return $user->can('view_products');
    }
    
    public function view(User $user, Product $product): bool
    {
        return $user->can('view_product');
    }
    
    public function create(User $user): bool
    {
        return $user->can('create_product');
    }
    
    public function update(User $user, Product $product): bool
    {
        return $user->can('update_product');
    }
    
    public function delete(User $user, Product $product): bool
    {
        return $user->can('delete_product');
    }
    
    public function restore(User $user, Product $product): bool
    {
        return $user->can('restore_product');
    }
    
    public function forceDelete(User $user, Product $product): bool
    {
        return $user->can('force_delete_product');
    }
}
```

## Resource Authorization

Filament automatically checks policies. Just register the policy:

```php
// AppServiceProvider.php
use App\Models\Product;
use App\Policies\ProductPolicy;

protected $policies = [
    Product::class => ProductPolicy::class,
];
```

### Custom Authorization in Resource

```php
public static function canViewAny(): bool
{
    return auth()->user()->can('view_products');
}

public static function canCreate(): bool
{
    return auth()->user()->can('create_product');
}

public static function canEdit(Model $record): bool
{
    return auth()->user()->can('update_product', $record);
}

public static function canDelete(Model $record): bool
{
    return auth()->user()->can('delete_product', $record);
}
```

## Action Authorization

### With Policy Ability

```php
DeleteAction::make()
    ->authorize('delete', $record)
```

### Require Any Ability (`OR` logic)

```php
Action::make('manage')
    ->authorizeAny(['edit', 'delete'])
```

### With Gate (Closure)

```php
Action::make('publish')
    ->authorize(fn () => auth()->user()->can('publish_products'))
```

### With visible() for UI

```php
DeleteAction::make()
    ->visible(fn (Product $record) => auth()->user()->can('delete', $record))
```

### Show Denial UX (instead of hiding)

```php
// Show a tooltip with the denial message
Action::make('approve')
    ->authorize('approve')
    ->authorizationTooltip()

// Show a notification when clicked while unauthorized
Action::make('export')
    ->authorize('export')
    ->authorizationNotification()

// Custom denial message
Action::make('delete')
    ->authorize('delete')
    ->authorizationMessage('Contact your administrator to delete records.')
```

### Per-Record Authorization on Bulk Actions

```php
BulkAction::make('approve')
    ->authorizeIndividualRecords('approve')
    ->action(fn (Collection $records) => $records->each->approve())
```

## Navigation Authorization

Hide resources from navigation:

```php
public static function shouldRegisterNavigation(): bool
{
    return auth()->user()->can('view_products');
}
```

## Bulk Action Authorization

```php
// Authorize at the action level (checks once for the whole bulk operation)
DeleteBulkAction::make()
    ->authorize('delete', Product::class)

// Authorize per individual record (filters out unauthorized records)
BulkAction::make('approve')
    ->authorizeIndividualRecords('approve')
    ->action(fn (Collection $records) => $records->each->approve())
```

## Tenant Authorization

For multi-tenant applications:

```php
public static function getEloquentQuery(): Builder
{
    return parent::getEloquentQuery()
        ->where('team_id', auth()->user()->current_team_id);
}

public static function canViewAny(): bool
{
    return auth()->user()->belongsToCurrentTeam();
}
```

## Super Admin Bypass

```php
// In policy
public function viewAny(User $user): bool
{
    if ($user->isSuperAdmin()) {
        return true;
    }
    
    return $user->can('view_products');
}
```

## Spatie Permission Integration

Using `spatie/laravel-permission`:

```php
// Policy
public function viewAny(User $user): bool
{
    return $user->hasPermissionTo('view_products');
}

// Or use Gates
Gate::before(function (User $user, string $ability) {
    if ($user->hasRole('super_admin')) {
        return true;
    }
});

// Middleware
protected function panel(Panel $panel): Panel
{
    return $panel
        ->middleware([
            'auth',
            'verified',
            'role:admin',  // Spatie middleware
        ]);
}
```

## Filament Shield

For comprehensive authorization management:

```bash
composer require bezhansalleh/filament-shield
```

Generates policies and permissions automatically.

## Related

- [../packages/panels/resources.md](../packages/panels/resources.md) - Resource authorization
- [../packages/actions/overview.md](../packages/actions/overview.md) - Action authorization