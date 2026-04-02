# CRUD Resource Recipe

> Complete CRUD resource implementation.

## 1. Generate Resource

```bash
php artisan make:filament-resource Product --generate --separate --view
```

## 2. Model

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use HasFactory, SoftDeletes;
    
    protected $fillable = [
        'name',
        'slug',
        'description',
        'price',
        'old_price',
        'sku',
        'qty',
        'is_visible',
        'brand_id',
    ];
    
    protected $casts = [
        'price' => 'decimal:2',
        'old_price' => 'decimal:2',
        'qty' => 'integer',
        'is_visible' => 'boolean',
        'published_at' => 'datetime',
    ];
    
    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }
}
```

## 3. Resource Class

```php
<?php

namespace App\Filament\Resources\Shop\Products;

use App\Filament\Resources\Shop\Products\Pages;
use App\Filament\Resources\Shop\Products\Schemas\ProductForm;
use App\Filament\Resources\Shop\Products\Tables\ProductsTable;
use App\Models\Shop\Product;
use Filament\Resources\Resource;
use Filament\Support\Icons\Heroicon;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    protected static ?string $recordTitleAttribute = 'name';
    
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
    
    protected static ?string $navigationGroup = 'Shop';
    
    protected static ?int $navigationSort = 0;
    
    protected static ?string $slug = 'shop/products';
    
    public static function form(Schema $schema): Schema
    {
        return ProductForm::configure($schema);
    }
    
    public static function table(Table $table): Table
    {
        return ProductsTable::configure($table);
    }
    
    public static function getPages(): array
    {
        return [
            'index' => Pages\ListProducts::route('/'),
            'create' => Pages\CreateProduct::route('/create'),
            'edit' => Pages\EditProduct::route('/{record}/edit'),
        ];
    }
    
    public static function getGloballySearchableAttributes(): array
    {
        return ['name', 'sku', 'brand.name'];
    }
    
    public static function getNavigationBadge(): ?string
    {
        return (string) static::$model::whereColumn('qty', '<', 'security_stock')->count();
    }
}
```

## 4. Form Schema

```php
<?php

namespace App\Filament\Resources\Shop\Products\Schemas;

use App\Models\Shop\Product;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Group;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class ProductForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Group::make()
                    ->schema([
                        Section::make()
                            ->schema([
                                TextInput::make('name')
                                    ->required()
                                    ->maxLength(255)
                                    ->live(onBlur: true)
                                    ->afterStateUpdated(function (string $operation, $state, Set $set): void {
                                        if ($operation !== 'create') {
                                            return;
                                        }
                                        $set('slug', Str::slug($state));
                                    }),
                                
                                TextInput::make('slug')
                                    ->disabled()
                                    ->dehydrated()
                                    ->required()
                                    ->maxLength(255)
                                    ->unique(Product::class, 'slug', ignoreRecord: true),
                                
                                RichEditor::make('description')
                                    ->columnSpan('full'),
                            ])
                            ->columns(2),
                        
                        Section::make('Pricing')
                            ->schema([
                                TextInput::make('price')
                                    ->numeric()
                                    ->minValue(0)
                                    ->required(),
                                
                                TextInput::make('old_price')
                                    ->label('Compare at price')
                                    ->numeric()
                                    ->minValue(0),
                            ])
                            ->columns(2),
                    ])
                    ->columnSpan(['lg' => 2]),
                
                Group::make()
                    ->schema([
                        Section::make('Associations')
                            ->schema([
                                Select::make('brand_id')
                                    ->relationship('brand', 'name')
                                    ->searchable(),
                            ]),
                    ])
                    ->columnSpan(['lg' => 1]),
            ])
            ->columns(3);
    }
}
```

## 5. Table Configuration

```php
<?php

namespace App\Filament\Resources\Shop\Products\Tables;

use App\Models\Shop\Product;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class ProductsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->searchable()
                    ->sortable(),
                
                TextColumn::make('brand.name')
                    ->searchable()
                    ->sortable()
                    ->toggleable(),
                
                TextColumn::make('price')
                    ->money('USD')
                    ->sortable(),
                
                TextColumn::make('sku')
                    ->searchable()
                    ->toggleable(),
                
                TextColumn::make('qty')
                    ->label('Quantity')
                    ->sortable()
                    ->toggleable(),
            ])
            ->filters([
                // Add filters here
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
```

## 6. Pages

ListProducts.php:

```php
<?php

namespace App\Filament\Resources\Shop\Products\Pages;

use App\Filament\Resources\Shop\Products\ProductResource;
use Filament\Actions\CreateAction;
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
}
```

CreateProduct.php:

```php
<?php

namespace App\Filament\Resources\Shop\Products\Pages;

use App\Filament\Resources\Shop\Products\ProductResource;
use Filament\Resources\Pages\CreateRecord;

class CreateProduct extends CreateRecord
{
    protected static string $resource = ProductResource::class;
    
    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}
```

EditProduct.php:

```php
<?php

namespace App\Filament\Resources\Shop\Products\Pages;

use App\Filament\Resources\Shop\Products\ProductResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditProduct extends EditRecord
{
    protected static string $resource = ProductResource::class;
    
    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
```

## Related

- [quick-start.md](quick-start.md) - Minimal setup
- [master-detail.md](master-detail.md) - With relation managers
- [../packages/panels/resources.md](../packages/panels/resources.md) - Resource documentation