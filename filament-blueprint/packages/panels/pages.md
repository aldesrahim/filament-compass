# Panels - Pages

> Package: `filament/panels` | Page types for resources and custom pages.

## Resource Pages

Each resource generates pages for CRUD operations.

### List Page

Displays table with filters, actions, pagination.

```php
use Filament\Resources\Pages\ListRecords;

class ListProducts extends ListRecords
{
    protected static string $resource = ProductResource::class;
    
    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
    
    protected function getFooterWidgets(): array
    {
        return [
            ProductStats::class,
        ];
    }
}
```

| Method | Purpose |
|--------|---------|
| `getHeaderActions()` | Actions above table (e.g., Create) |
| `getFooterWidgets()` | Widgets below table |
| `getHeaderWidgets()` | Widgets above table |
| `getTableColumns()` | Override table columns |
| `getTableFilters()` | Override table filters |

### Create Page

Form for creating new records.

```php
use Filament\Resources\Pages\CreateRecord;

class CreateProduct extends CreateRecord
{
    protected static string $resource = ProductResource::class;
    
    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
    
    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $data['user_id'] = auth()->id();
        return $data;
    }
    
    protected function afterCreate(): void
    {
        $this->record->sendNotification();
    }
}
```

| Method | Purpose |
|--------|---------|
| `getRedirectUrl()` | URL after creation |
| `mutateFormDataBeforeCreate()` | Modify data before save |
| `mutateFormDataBeforeSave()` | Alias for above |
| `afterCreate()` | Hook after record created |
| `beforeCreate()` | Hook before record created |
| `getFormActions()` | Customize form buttons |

### Edit Page

Form for editing existing records.

```php
use Filament\Resources\Pages\EditRecord;

class EditProduct extends EditRecord
{
    protected static string $resource = ProductResource::class;
    
    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
            ViewAction::make(),
        ];
    }
    
    protected function mutateFormDataBeforeSave(array $data): array
    {
        $data['updated_by'] = auth()->id();
        return $data;
    }
    
    protected function afterSave(): void
    {
        $this->record->logChanges();
    }
}
```

| Method | Purpose |
|--------|---------|
| `getHeaderActions()` | Actions in header (Delete, View) |
| `mutateFormDataBeforeSave()` | Modify data before update |
| `afterSave()` | Hook after record saved |
| `beforeSave()` | Hook before record saved |
| `getFormActions()` | Customize form buttons |
| `getSavedNotification()` | Customize success notification |

### View Page

Read-only display using Infolists.

```php
use Filament\Resources\Pages\ViewRecord;
use Filament\Infolists\Infolist;

class ViewProduct extends ViewRecord
{
    protected static string $resource = ProductResource::class;
    
    protected function getHeaderActions(): array
    {
        return [
            EditAction::make(),
            DeleteAction::make(),
        ];
    }
    
    public static function infolist(Infolist $infolist): Infolist
    {
        return ProductInfolist::configure($infolist);
    }
}
```

## Custom Pages

Full-page Livewire components for custom functionality.

### Create Custom Page

```bash
php artisan make:filament-page Settings
```

### Custom Page Structure

```php
use Filament\Pages\Page;

class Settings extends Page
{
    protected static ?string $navigationIcon = Heroicon::OutlinedCog;
    
    protected static string $view = 'filament.pages.settings';
    
    protected static ?string $navigationLabel = 'Settings';
    
    protected static ?string $title = 'Application Settings';
    
    protected static ?string $navigationGroup = 'System';
    
    protected static ?int $navigationSort = 100;
    
    public function getTitle(): string
    {
        return static::$title;
    }
}
```

### Custom Page with Actions

```php
use Filament\Pages\Page;
use Filament\Actions\Action;

class Settings extends Page
{
    protected static string $view = 'filament.pages.settings';
    
    protected function getHeaderActions(): array
    {
        return [
            Action::make('save')
                ->action(fn () => $this->save()),
        ];
    }
}
```

### Custom Page with Form

```php
use Filament\Pages\Page;
use Filament\Schemas\Schema;
use Filament\Forms\Components\TextInput;

class Settings extends Page
{
    protected static string $view = 'filament.pages.settings';
    
    public function schema(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('site_name'),
                TextInput::make('contact_email'),
            ]);
    }
    
    public function save(): void
    {
        $data = $this->form->getState();
        Settings::set($data);
    }
}
```

## Manage Page (Simple Resources)

For simple/modal resources, single page with table + modals.

```php
use Filament\Resources\Pages\ManageRecords;

class ManageCustomers extends ManageRecords
{
    protected static string $resource = CustomerResource::class;
    
    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
```

## Dashboard

Customize the default dashboard.

```php
use Filament\Pages\Dashboard;

class Dashboard extends \Filament\Pages\Dashboard
{
    protected function getHeaderWidgets(): array
    {
        return [
            WorkforceInsightsStats::class,
            CustomerSegmentsChart::class,
        ];
    }
    
    protected function getColumns(): int
    {
        return 3;
    }
}
```

## Page Hooks

### Create/Edit Hooks

```php
// Before creation
protected function beforeCreate(): void { }

// After creation
protected function afterCreate(): void { }

// Before saving (create or edit)
protected function beforeSave(): void { }

// After saving (create or edit)
protected function afterSave(): void { }

// Before deletion
protected function beforeDelete(): void { }

// After deletion
protected function afterDelete(): void { }
```

### Data Mutation Hooks

```php
// Create page
protected function mutateFormDataBeforeCreate(array $data): array { return $data; }

// Edit page
protected function mutateFormDataBeforeSave(array $data): array { return $data; }

// Delete action
protected function mutateFormDataBeforeDelete(array $data): array { return $data; }
```

## Related

- [resources.md](resources.md) - Resource structure
- [../infolists/entries.md](../infolists/entries.md) - Infolist entries
- [../../recipes/custom-page.md](../../recipes/custom-page.md) - Custom page recipe