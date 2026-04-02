# Tables - Actions

> Package: `filament/tables` | Row actions and bulk actions.

## Namespace

All actions use `Filament\Actions\` namespace (NOT `Filament\Tables\Actions\`).

```php
use Filament\Actions\{Action};
```

## Row Actions

Actions attached to each table row.

```php
use Filament\Actions\EditAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\Action;
use Filament\Actions\ActionGroup;

$table->recordActions([
    EditAction::make(),
    DeleteAction::make(),
    Action::make('feature')
        ->icon(Heroicon::Star)
        ->action(fn (Product $record) => $record->update(['is_featured' => true])),
])
```

### Action Groups

Group multiple actions in dropdown:

```php
$table->recordActions([
    ActionGroup::make([
        EditAction::make(),
        Action::make('duplicate')
            ->icon(Heroicon::DocumentDuplicate)
            ->action(fn (Product $record) => $record->duplicate()),
        DeleteAction::make(),
    ]),
])
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
->recordActions([
    ActionGroup::make([
        EditAction::make(),
        Action::make('toggle_visibility')
            ->icon(fn (Product $record) => $record->is_visible ? Heroicon::EyeSlash : Heroicon::Eye)
            ->label(fn (Product $record) => $record->is_visible ? 'Hide' : 'Show')
            ->color('gray')
            ->action(fn (Product $record) => $record->update(['is_visible' => !$record->is_visible])),
        Action::make('adjust_price')
            ->icon(Heroicon::CurrencyDollar)
            ->color('warning')
            ->modalWidth(Width::Medium)
            ->form([
                TextInput::make('price')->numeric()->prefix('$')->required(),
                TextInput::make('old_price')->label('Compare at price')->numeric()->prefix('$'),
            ])
            ->action(fn (Product $record, array $data) => $record->update($data)),
        DeleteAction::make(),
    ]),
])
```

## Bulk Actions

Actions for selected records.

```php
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\BulkAction;

$table->toolbarActions([
    BulkActionGroup::make([
        DeleteBulkAction::make(),
        BulkAction::make('export')
            ->icon(Heroicon::Download)
            ->action(fn (Collection $records) => $records->export()),
    ]),
])
```

### Grouped Bulk Actions

```php
$table->groupedBulkActions([
    DeleteBulkAction::make(),
    BulkAction::make('mark_as_published')
        ->icon(Heroicon::Check)
        ->action(fn (Collection $records) => $records->each->update(['status' => 'published'])),
])
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php
->groupedBulkActions([
    BulkAction::make('toggle_visibility')
        ->icon(Heroicon::Eye)
        ->color('gray')
        ->schema([
            ToggleButtons::make('is_visible')
                ->label('Visibility')
                ->options(['1' => 'Visible', '0' => 'Hidden'])
                ->inline()
                ->required(),
        ])
        ->action(function (Collection $records, array $data): void {
            $records->each(fn (Product $record) => 
                $record->update(['is_visible' => (bool) $data['is_visible']])
            );
        })
        ->deselectRecordsAfterCompletion(),
    DeleteBulkAction::make(),
])
```

## Built-in Actions

| Action | Purpose |
|--------|---------|
| `EditAction` | Edit record |
| `DeleteAction` | Delete record |
| `ViewAction` | View record details |
| `ReplicateAction` | Duplicate record |
| `ForceDeleteAction` | Force delete (soft deletes) |
| `RestoreAction` | Restore deleted record |
| `DeleteBulkAction` | Bulk delete |
| `ForceDeleteBulkAction` | Bulk force delete |
| `RestoreBulkAction` | Bulk restore |
| `ExportBulkAction` | Bulk export |
| `ImportAction` | Import records |

## Action Configuration

### Modal Actions

```php
Action::make('adjust_price')
    ->modalHeading('Adjust Price')
    ->modalDescription('Set new price for this product')
    ->modalIcon(Heroicon::CurrencyDollar)
    ->modalIconColor('warning')
    ->modalWidth(Width::Medium)  // or Width::Small, Width::Large, Width::ExtraLarge, Width::Screen
    ->modalSubmitActionLabel('Save')
    ->modalCancelActionLabel('Cancel')
    ->form([
        TextInput::make('price')->numeric()->required(),
    ])
    ->action(fn (Product $record, array $data) => $record->update($data))
```

### Confirmation Modal

```php
DeleteAction::make()
    ->requiresConfirmation()
    ->modalHeading('Delete Product')
    ->modalDescription('Are you sure you want to delete this product? This action cannot be undone.')
```

### Action Visibility

```php
Action::make('feature')
    ->visible(fn (Product $record) => !$record->is_featured)
    ->hidden(fn (Product $record) => $record->is_featured)
```

### Action Color

```php
Action::make('approve')
    ->color('success')  // 'success', 'warning', 'danger', 'primary', 'gray'
```

### Action Icon

```php
Action::make('edit')
    ->icon(Heroicon::PencilSquare)
    ->iconSize('lg')  // 'sm', 'md', 'lg', 'xl'
    ->iconColor('warning')
```

### Action Label

```php
Action::make('edit')
    ->label('Edit Product')
    ->hiddenLabel()  // Show only icon
```

### Action URL/Redirect

```php
Action::make('view')
    ->url(fn (Product $record) => route('products.view', $record))
    ->openUrlInNewTab()

Action::make('edit')
    ->action(fn (Product $record) => redirect(ProductResource::getUrl('edit', ['record' => $record])))
```

## Bulk Action Configuration

| Method | Purpose | Example |
|--------|---------|---------|
| `deselectRecordsAfterCompletion()` | Clear selection after action | `->deselectRecordsAfterCompletion()` |
| `schema()` | Form for bulk action | `->schema([...])` |
| `action()` | Bulk action logic | `->action(fn (Collection $records) => ...)` |

## Toolbar Actions

Actions in table header (not per-row).

```php
$table->toolbarActions([
    Action::make('export')
        ->icon(Heroicon::Download)
        ->action(fn () => Product::export()),
    Action::make('import')
        ->icon(Heroicon::Upload)
        ->form([...])
        ->action(fn (array $data) => Product::import($data)),
])
```

## Header Actions

Actions in page header (before table).

```php
// In List page
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

## Common Action Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `label()` | Custom label | `->label('Edit')` |
| `icon()` | Icon | `->icon(Heroicon::Pencil)` |
| `color()` | Color | `->color('success')` |
| `action()` | Action logic | `->action(fn ($record) => ...)` |
| `url()` | URL instead of action | `->url(fn ($record) => ...)` |
| `visible()` | Visible condition | `->visible(fn ($record) => ...)` |
| `hidden()` | Hidden condition | `->hidden(fn ($record) => ...)` |
| `disabled()` | Disabled state | `->disabled(fn ($record) => ...)` |
| `form()` | Modal form | `->form([...])` |
| `requiresConfirmation()` | Confirm before action | `->requiresConfirmation()` |
| `modalHeading()` | Modal title | `->modalHeading('Delete')` |
| `modalWidth()` | Modal width | `->modalWidth(Width::Medium)` |
| `authorize()` | Permission check | `->authorize('delete', $record)` |
| `successNotificationTitle()` | Success message | `->successNotificationTitle('Deleted!')` |
| `failureNotificationTitle()` | Failure message | `->failureNotificationTitle('Failed')` |

## Related

- [columns.md](columns.md) - Table columns
- [filters.md](filters.md) - Table filters
- [../actions/catalog.md](../actions/catalog.md) - All action types