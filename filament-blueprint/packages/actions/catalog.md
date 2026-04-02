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

## Button Variants

```php
// Default button
Action::make('edit')->button()

// Link style
Action::make('edit')->link()

// Outlined button
Action::make('edit')->outlined()
```

## Action Sizes

```php
Action::make('edit')->size('xs')  // 'xs', 'sm', 'md', 'lg'
```

## Related

- [overview.md](overview.md) - Action architecture
- [../tables/actions.md](../tables/actions.md) - Table-specific actions
- [../../patterns/imports-exports.md](../../patterns/imports-exports.md) - Import/Export patterns