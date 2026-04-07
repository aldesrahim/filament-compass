# Actions - Catalog

> Package: `filament/actions` | All action types and their configuration.

## Namespace

```php
use Filament\Actions\{Action};
```

## CRUD Actions

### EditAction

Edit an existing record.

```php
use Filament\Actions\EditAction;

EditAction::make()
    ->url(fn (Product $record) => ProductResource::getUrl('edit', ['record' => $record]))
```

### DeleteAction

Delete a record with confirmation.

```php
use Filament\Actions\DeleteAction;

DeleteAction::make()
    ->requiresConfirmation()
    ->modalHeading('Delete Product')
```

### ViewAction

View record details.

```php
use Filament\Actions\ViewAction;

ViewAction::make()
    ->url(fn (Product $record) => ProductResource::getUrl('view', ['record' => $record]))
```

### CreateAction

Create new record.

```php
use Filament\Actions\CreateAction;

CreateAction::make()
    ->url(ProductResource::getUrl('create'))
```

### ReplicateAction

Duplicate a record.

```php
use Filament\Actions\ReplicateAction;

ReplicateAction::make()
    ->excludeAttributes(['slug', 'created_at', 'updated_at'])
    ->beforeReplicaSaved(function (Product $replica, Product $record) {
        $replica->name = $record->name . ' (Copy)';
    })
```

### ForceDeleteAction

Permanently delete a soft-deleted record.

```php
use Filament\Actions\ForceDeleteAction;

ForceDeleteAction::make()
    ->requiresConfirmation()
```

### RestoreAction

Restore a soft-deleted record.

```php
use Filament\Actions\RestoreAction;

RestoreAction::make()
    ->requiresConfirmation()
```

## Bulk Actions

### DeleteBulkAction

Delete multiple records.

```php
use Filament\Actions\DeleteBulkAction;

DeleteBulkAction::make()
    ->requiresConfirmation()
```

### ForceDeleteBulkAction

Permanently delete multiple soft-deleted records.

```php
use Filament\Actions\ForceDeleteBulkAction;

ForceDeleteBulkAction::make()
```

### RestoreBulkAction

Restore multiple soft-deleted records.

```php
use Filament\Actions\RestoreBulkAction;

RestoreBulkAction::make()
```

### DetachBulkAction

Detach multiple records in a ManyToMany relationship.

```php
use Filament\Actions\DetachBulkAction;

DetachBulkAction::make()
```

### DissociateBulkAction

Dissociate multiple records in a HasMany relationship.

```php
use Filament\Actions\DissociateBulkAction;

DissociateBulkAction::make()
```

## Import/Export Actions

### ImportAction

Import records from file.

```php
use Filament\Actions\ImportAction;
use App\Filament\Imports\ProductImporter;

ImportAction::make()
    ->importer(ProductImporter::class)
    ->csvDelimiter(',')
    ->label('Import Products')
```

### ExportAction

Export records to file.

```php
use Filament\Actions\ExportAction;
use App\Filament\Exports\ProductExporter;

ExportAction::make()
    ->exporter(ProductExporter::class)
    ->label('Export Products')
```

### ExportBulkAction

Export selected records.

```php
use Filament\Actions\ExportBulkAction;

ExportBulkAction::make()
    ->exporter(ProductExporter::class)
```

## Relationship Actions

### AttachAction

Attach record in ManyToMany relationship.

```php
use Filament\Actions\AttachAction;

AttachAction::make()
    ->recordSelectSearchColumns(['name', 'email'])
    ->preloadRecordSelect()
```

### DetachAction

Detach record in ManyToMany relationship.

```php
use Filament\Actions\DetachAction;

DetachAction::make()
```

### DissociateAction

Dissociate record in BelongsTo relationship.

```php
use Filament\Actions\DissociateAction;

DissociateAction::make()
```

### AssociateAction

Associate record in BelongsTo relationship.

```php
use Filament\Actions\AssociateAction;

AssociateAction::make()
```

## Custom Actions

### Generic Action

```php
Action::make('custom')
    ->label('Custom Action')
    ->icon(Heroicon::Star)
    ->action(fn (Product $record) => $record->update(['featured' => true]))
```

### Action with Form

```php
Action::make('update_status')
    ->form([
        Select::make('status')
            ->options(['draft', 'published', 'archived'])
            ->required(),
    ])
    ->action(function (array $data, Product $record) {
        $record->update(['status' => $data['status']]);
    })
```

### Action with Database Transaction

```php
Action::make('process')
    ->databaseTransaction()
    ->action(function (Order $record) {
        $record->update(['status' => 'processed']);
        $record->customer->increment('order_count');
    })
```

### ActionGroup

Group multiple actions in dropdown.

```php
use Filament\Actions\ActionGroup;

ActionGroup::make([
    EditAction::make(),
    Action::make('duplicate')
        ->icon(Heroicon::DocumentDuplicate)
        ->action(fn (Product $record) => $record->replicate()),
    DeleteAction::make(),
])
    ->label('Actions')
    ->icon(Heroicon::EllipsisVertical)
    ->color('gray')
```

### BulkAction

Custom bulk action.

```php
use Filament\Actions\BulkAction;

BulkAction::make('mark_featured')
    ->label('Mark as Featured')
    ->icon(Heroicon::Star)
    ->action(fn (Collection $records) => $records->each->update(['is_featured' => true]))
    ->deselectRecordsAfterCompletion()
```

### BulkAction with Form

```php
BulkAction::make('update_status')
    ->form([
        Select::make('status')
            ->options(['draft', 'published'])
            ->required(),
    ])
    ->action(function (Collection $records, array $data) {
        $records->each->update(['status' => $data['status']]);
    })
```

## SelectAction

Inline select dropdown rendered as an action.

```php
use Filament\Actions\SelectAction;

SelectAction::make('status')
    ->options(OrderStatus::class)
    ->action(fn (array $data, Order $record) => $record->update(['status' => $data['status']]))
```

### With Placeholder

```php
SelectAction::make('assign_to')
    ->options(User::pluck('name', 'id'))
    ->placeholder('Assign to...')
    ->action(fn (array $data, Task $record) => $record->update(['user_id' => $data['assign_to']]))
```

## Button Variants

```php
// Default button
Action::make('edit')->button()

// Link style
Action::make('edit')->link()

// Icon button
Action::make('edit')->iconButton()

// Outlined button
Action::make('edit')->outlined()
```

> **Deprecated**: `ButtonAction` and `IconButtonAction` classes are deprecated. Use `Action::make()->button()` and `Action::make()->iconButton()` instead.

## Action Sizes

```php
Action::make('edit')->size('xs')  // 'xs', 'sm', 'md', 'lg'
```

## Action Authorization

### Require All Abilities

```php
Action::make('publish')
    ->authorize('publish', Product::class)
```

### Require Any Ability

```php
Action::make('manage')
    ->authorizeAny(['edit', 'delete'], $record)
```

### Custom Message When Denied

```php
Action::make('approve')
    ->authorize('approve')
    ->authorizationMessage('You do not have permission to approve records.')
```

### Show Tooltip When Unauthorized (Instead of Hiding)

```php
Action::make('delete')
    ->authorize('delete')
    ->authorizationTooltip()  // Shows the denial message as tooltip
```

### Show Notification When Unauthorized (Instead of Hiding)

```php
Action::make('export')
    ->authorize('export')
    ->authorizationNotification()  // Shows notification on click
```

### Per-Record Authorization in Bulk Actions

```php
BulkAction::make('approve')
    ->authorizeIndividualRecords('approve')
    ->action(fn (Collection $records) => $records->each->approve())
```

Or with a closure:

```php
BulkAction::make('delete')
    ->authorizeIndividualRecords(fn (Model $record) => auth()->user()->can('delete', $record))
    ->action(fn (Collection $records) => $records->each->delete())
```

## Related

- [overview.md](overview.md) - Action architecture
- [../tables/actions.md](../tables/actions.md) - Table-specific actions
- [../../patterns/imports-exports.md](../../patterns/imports-exports.md) - Import/Export patterns