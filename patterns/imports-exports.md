# Imports/Exports Pattern

> Import and export functionality with Filament.

## Import Action

### Create Importer

```bash
php artisan make:filament-importer Product
```

### Importer Class

```php
<?php

namespace App\Filament\Imports;

use App\Models\Product;
use Filament\Actions\Imports\ImportColumn;
use Filament\Actions\Imports\Importer;
use Filament\Actions\Imports\Models\Import;

class ProductImporter extends Importer
{
    protected static ?string $model = Product::class;
    
    public static function getColumns(): array
    {
        return [
            ImportColumn::make('name')
                ->requiredMapping()
                ->rules(['required', 'max:255']),
            
            ImportColumn::make('sku')
                ->requiredMapping()
                ->rules(['required', 'unique:products,sku']),
            
            ImportColumn::make('price')
                ->numeric()
                ->rules(['numeric', 'min:0']),
            
            ImportColumn::make('brand.name')  // Relationship
                ->relationship(resolveUsing: 'name'),
        ];
    }
    
    public function resolveRecord(): ?Product
    {
        return Product::firstOrNew(['sku' => $this->data['sku']]);
    }
    
    public static function getCompletedNotificationBody(Import $import): string
    {
        $body = 'Your product import has completed. ' . 
            number_format($import->successful_rows) . ' ' . 
            str('row')->plural($import->successful_rows) . ' imported.';
        
        if ($failedRowsCount = $import->getFailedRowsCount()) {
            $body .= ' ' . number_format($failedRowsCount) . ' ' . 
                str('row')->plural($failedRowsCount) . ' failed.';
        }
        
        return $body;
    }
}
```

### Import Action in Table

```php
use App\Filament\Imports\ProductImporter;
use Filament\Actions\ImportAction;

->headerActions([
    ImportAction::make()
        ->importer(ProductImporter::class)
        ->csvDelimiter(',')
        ->maxRows(1000)
        ->chunkSize(100),
])
```

### Real Example

From demo: `demo/app/Filament/Imports/Shop/CategoryImporter.php`

```php
<?php

namespace App\Filament\Imports\Shop;

use App\Models\Shop\Category;
use Filament\Actions\Imports\ImportColumn;
use Filament\Actions\Imports\Importer;
use Filament\Actions\Imports\Models\Import;

class CategoryImporter extends Importer
{
    protected static ?string $model = Category::class;
    
    public static function getColumns(): array
    {
        return [
            ImportColumn::make('name')
                ->requiredMapping()
                ->rules(['required']),
        ];
    }
    
    public function resolveRecord(): ?Category
    {
        return Category::firstOrNew(['name' => $this->data['name']]);
    }
}
```

## Export Action

### Create Exporter

```bash
php artisan make:filament-exporter Product
```

### Exporter Class

```php
<?php

namespace App\Filament\Exports;

use App\Models\Product;
use Filament\Actions\Exports\ExportColumn;
use Filament\Actions\Exports\Exporter;
use Filament\Actions\Exports\Models\Export;

class ProductExporter extends Exporter
{
    protected static ?string $model = Product::class;
    
    public static function getColumns(): array
    {
        return [
            ExportColumn::make('id'),
            ExportColumn::make('name'),
            ExportColumn::make('sku'),
            ExportColumn::make('price'),
            ExportColumn::make('brand.name')->label('Brand'),
            ExportColumn::make('created_at'),
        ];
    }
    
    public static function getCompletedNotificationBody(Export $export): string
    {
        $body = 'Your product export has completed. ' . 
            number_format($export->successful_rows) . ' ' . 
            str('row')->plural($export->successful_rows) . ' exported.';
        
        return $body;
    }
}
```

### Export Action in Table

```php
use App\Filament\Exports\ProductExporter;
use Filament\Actions\ExportAction;
use Filament\Actions\ExportBulkAction;

// Export all records
->headerActions([
    ExportAction::make()
        ->exporter(ProductExporter::class)
        ->fileName(fn () => 'products-' . now()->format('Y-m-d') . '.csv')
        ->formats([
            ExportFormat::Csv,
            ExportFormat::Xlsx,
        ]),
])

// Export selected records
->groupedBulkActions([
    ExportBulkAction::make()
        ->exporter(ProductExporter::class),
])
```

### Real Example

From demo: `demo/app/Filament/Exports/Shop/BrandExporter.php`

```php
<?php

namespace App\Filament\Exports\Shop;

use App\Models\Shop\Brand;
use Filament\Actions\Exports\ExportColumn;
use Filament\Actions\Exports\Exporter;
use Filament\Actions\Exports\Models\Export;

class BrandExporter extends Exporter
{
    protected static ?string $model = Brand::class;
    
    public static function getColumns(): array
    {
        return [
            ExportColumn::make('id'),
            ExportColumn::make('name'),
            ExportColumn::make('website'),
        ];
    }
}
```

## Import Column Options

```php
ImportColumn::make('name')
    ->requiredMapping()           // Must be mapped
    ->guess(['name', 'title'])    // Auto-match columns
    ->relationship(resolveUsing: 'name')  // For relationships
    ->rules(['required', 'max:255'])
    ->ignoreBlankState()          // Don't update if blank
    ->fillRecordUsing(fn ($record, $state) => $record->name = strtoupper($state))
```

## Export Column Options

```php
ExportColumn::make('name')
    ->label('Product Name')
    ->state(fn (Product $record) => strtoupper($record->name))
    ->enabledByDefault(false)
    ->formatStateUsing(fn ($state) => trim($state))
```

## CSV Options

```php
ImportAction::make()
    ->csvDelimiter(',')
    ->csvEnclosure('"')
    ->csvEscapeCharacter('\\')
```

## File Formats

```php
ExportAction::make()
    ->formats([
        ExportFormat::Csv,
        ExportFormat::Xlsx,
    ])
```

## Related

- [../packages/actions/catalog.md](../packages/actions/catalog.md) - Import/Export actions