# Actions - Overview

> Package: `filament/actions` | Action architecture and patterns.

## Namespace

All actions use `Filament\Actions\` namespace.

```php
use Filament\Actions\{Action};
```

## Action Types

| Action | Purpose | Usage |
|--------|---------|-------|
| `Action` | Generic action | Tables, pages, forms |
| `EditAction` | Edit record | Table rows, pages |
| `DeleteAction` | Delete record | Table rows, pages |
| `ViewAction` | View record | Table rows, pages |
| `CreateAction` | Create record | Pages |
| `ReplicateAction` | Duplicate record | Table rows |
| `ForceDeleteAction` | Force delete | Table rows (soft deletes) |
| `RestoreAction` | Restore deleted | Table rows (soft deletes) |
| `ImportAction` | Import records | Tables |
| `ExportAction` | Export records | Tables |
| `BulkAction` | Bulk operation | Table selections |
| `DeleteBulkAction` | Bulk delete | Table selections |
| `ActionGroup` | Grouped actions | Table rows, pages |

## Action Architecture

Actions are:
- Buttons with optional modal forms
- Executable on records or standalone
- Attachable to tables, pages, and forms
- Customizable with closures for dynamic behavior

### Basic Action

```php
Action::make('approve')
    ->label('Approve')
    ->icon(Heroicon::Check)
    ->color('success')
    ->action(fn (Order $record) => $record->update(['status' => 'approved']))
```

### Action with Modal Form

```php
Action::make('adjust_price')
    ->icon(Heroicon::CurrencyDollar)
    ->form([
        TextInput::make('price')
            ->numeric()
            ->required(),
    ])
    ->action(function (array $data, Product $record) {
        $record->update($data);
    })
```

### Action with Confirmation

```php
DeleteAction::make()
    ->requiresConfirmation()
    ->modalHeading('Delete Product')
    ->modalDescription('Are you sure? This cannot be undone.')
```

## Action Locations

### Table Row Actions

```php
// In table configuration
->recordActions([
    EditAction::make(),
    DeleteAction::make(),
])
```

### Table Bulk Actions

```php
->toolbarActions([
    BulkActionGroup::make([
        DeleteBulkAction::make(),
    ]),
])

// Or grouped
->groupedBulkActions([
    DeleteBulkAction::make(),
])
```

### Page Header Actions

```php
// In page class
protected function getHeaderActions(): array
{
    return [
        CreateAction::make(),
        Action::make('export')
            ->icon(Heroicon::Download)
            ->action(fn () => Product::export()),
    ];
}
```

### Form Actions (Buttons)

```php
// In form schema
TextInput::make('name'),

Actions::make([
    Action::make('generate_slug')
        ->icon(Heroicon::Link)
        ->action(fn (Set $set, Get $get) => $set('slug', Str::slug($get('name')))),
])
```

## Action Configuration

### Appearance

```php
Action::make('edit')
    ->label('Edit Product')
    ->icon(Heroicon::PencilSquare)
    ->iconSize('lg')
    ->color('primary')  // 'primary', 'success', 'warning', 'danger', 'gray'
    ->size('sm')        // 'xs', 'sm', 'md', 'lg'
    ->button()          // Render as button (default)
    ->link()            // Render as link
    ->outlined()        // Outlined button style
```

### Modal

```php
Action::make('edit')
    ->modalHeading('Edit Product')
    ->modalDescription('Update the product details below.')
    ->modalIcon(Heroicon::Pencil)
    ->modalWidth(Width::Medium)  // Small, Medium, Large, ExtraLarge, Screen
    ->modalSubmitActionLabel('Save Changes')
    ->modalCancelActionLabel('Cancel')
    ->modalFooterActions([...])  // Custom modal actions
    ->slideOver()                // Slide-over modal instead of centered
```

### Behavior

```php
Action::make('edit')
    ->action(fn (Product $record, array $data) => $record->update($data))
    ->url(fn (Product $record) => route('products.edit', $record))  // Or URL instead
    ->openUrlInNewTab()
    ->visible(fn (Product $record) => $record->canEdit())
    ->hidden(fn (Product $record) => $record->cannotEdit())
    ->disabled(fn (Product $record) => $record->isLocked())
    ->authorize('update', $record)  // Policy check
```

### Notifications

```php
Action::make('approve')
    ->action(function (Order $record) {
        $record->update(['status' => 'approved']);
        
        Notification::make()
            ->title('Order approved')
            ->success()
            ->send();
    })
    ->successNotificationTitle('Order approved successfully')
    ->failureNotificationTitle('Failed to approve order')
```

## Action Hooks

```php
Action::make('process')
    ->before(function (Product $record) {
        // Runs before action
    })
    ->after(function (Product $record) {
        // Runs after action
    })
```

## Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php`

```php
Action::make('adjust_price')
    ->icon(Heroicon::CurrencyDollar)
    ->color('warning')
    ->modalWidth(Width::Medium)
    ->modalSubmitActionLabel('Save')
    ->modalIcon(Heroicon::CurrencyDollar)
    ->modalIconColor('warning')
    ->fillForm(fn (Product $record): array => [
        'price' => $record->price,
        'old_price' => $record->old_price,
    ])
    ->schema([
        TextInput::make('price')
            ->numeric()
            ->prefix('$')
            ->minValue(0)
            ->maxValue(99999999.99)
            ->required(),
        TextInput::make('old_price')
            ->label('Compare at price')
            ->numeric()
            ->prefix('$')
            ->minValue(0)
            ->maxValue(99999999.99),
    ])
    ->action(fn (Product $record, array $data) => $record->update($data))
```

## Related

- [catalog.md](catalog.md) - All action types
- [../tables/actions.md](../tables/actions.md) - Table-specific actions
- [../../patterns/state-transitions.md](../../patterns/state-transitions.md) - State transition actions