# Separated Concerns Pattern

> Organize resources into Schemas, Tables, Pages, and RelationManagers.

## Directory Structure

```
app/Filament/Resources/{Domain}/{Entity}/
├── {Entity}Resource.php          # Resource definition
├── Schemas/
│   ├── {Entity}Form.php          # Form schema
│   └── {Entity}Infolist.php      # Infolist schema (optional)
├── Tables/
│   └── {Entity}Table.php         # Table configuration
├── Pages/
│   ├── List{Entities}.php        # List page
│   ├── Create{Entity}.php        # Create page
│   ├── Edit{Entity}.php          # Edit page
│   └── View{Entity}.php          # View page (optional)
├── RelationManagers/
│   └── {Relation}RelationManager.php
└── Widgets/
    └── {Entity}Stats.php         # Resource widgets (optional)
```

## Resource Class

Keep the resource class minimal, delegating to separate classes:

```php
<?php

namespace App\Filament\Resources\Shop\Products;

use App\Filament\Resources\Shop\Products\Pages\CreateProduct;
use App\Filament\Resources\Shop\Products\Pages\EditProduct;
use App\Filament\Resources\Shop\Products\Pages\ListProducts;
use App\Filament\Resources\Shop\Products\RelationManagers\CommentsRelationManager;
use App\Filament\Resources\Shop\Products\Schemas\ProductForm;
use App\Filament\Resources\Shop\Products\Tables\ProductsTable;
use App\Models\Shop\Product;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    protected static ?string $recordTitleAttribute = 'name';
    
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;
    
    protected static ?string $navigationGroup = 'Shop';
    
    public static function form(Schema $schema): Schema
    {
        return ProductForm::configure($schema);
    }
    
    public static function table(Table $table): Table
    {
        return ProductsTable::configure($table);
    }
    
    public static function getRelations(): array
    {
        return [
            CommentsRelationManager::class,
        ];
    }
    
    public static function getPages(): array
    {
        return [
            'index' => ListProducts::route('/'),
            'create' => CreateProduct::route('/create'),
            'edit' => EditProduct::route('/{record}/edit'),
        ];
    }
}
```

## Form Schema Class

```php
<?php

namespace App\Filament\Resources\Shop\Products\Schemas;

use App\Models\Shop\Product;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Group;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

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
                                    ->maxLength(255),
                                RichEditor::make('description'),
                            ]),
                        Section::make('Pricing')
                            ->schema([
                                TextInput::make('price')
                                    ->numeric()
                                    ->required(),
                            ]),
                    ])
                    ->columnSpan(['lg' => 2]),
                
                Group::make()
                    ->schema([
                        Section::make('Associations')
                            ->schema([
                                Select::make('brand_id')
                                    ->relationship('brand', 'name'),
                            ]),
                    ])
                    ->columnSpan(['lg' => 1]),
            ])
            ->columns(3);
    }
}
```

## Table Configuration Class

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
                    ->searchable(),
                TextColumn::make('price')
                    ->sortable(),
            ])
            ->filters([
                // ...
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

## Page Classes

Pages remain minimal, mainly for customizing headers and widgets:

```php
<?php

namespace App\Filament\Resources\Shop\Products\Pages;

use App\Filament\Resources\Shop\Products\ProductResource;
use App\Filament\Resources\Shop\Products\Widgets\ProductStats;
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
    
    protected function getFooterWidgets(): array
    {
        return [
            ProductStats::class,
        ];
    }
}
```

## Benefits

1. **Separation of Concerns** - Each class has a single responsibility
2. **Reusability** - Schemas and tables can be reused across resources
3. **Testability** - Each class can be tested independently
4. **Maintainability** - Easier to find and modify specific functionality
5. **Collaboration** - Multiple developers can work on different parts

## Generating Separated Resources

```bash
php artisan make:filament-resource Product --separate
```

Or with all options:

```bash
php artisan make:filament-resource Product --separate --generate --view --soft-deletes
```

## Related

- [../architecture/directory-structure.md](../architecture/directory-structure.md) - Directory structure
- [../packages/panels/resources.md](../packages/panels/resources.md) - Resource structure
- [../recipes/crud-resource.md](../recipes/crud-resource.md) - Full CRUD recipe