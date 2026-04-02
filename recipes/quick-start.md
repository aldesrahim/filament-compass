# Quick Start Recipe

> Minimal setup to get started with Filament.

## 1. Install Filament

```bash
composer require filament/filament:"^3.0"
```

## 2. Create Panel Provider

```bash
php artisan filament:install --panels
```

## 3. Create a Resource

```bash
php artisan make:filament-resource Product --generate --separate
```

## 4. Minimal Resource

```php
<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ProductResource\Pages;
use App\Models\Product;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use Filament\Forms\Components\TextInput;
use Filament\Tables\Columns\TextColumn;
use Filament\Actions\EditAction;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;

class ProductResource extends Resource
{
    protected static ?string $model = Product::class;
    
    protected static ?string $navigationIcon = Heroicon::OutlinedBolt;
    
    public static function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')->required(),
                TextInput::make('price')->numeric()->required(),
            ]);
    }
    
    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')->searchable(),
                TextColumn::make('price')->money('USD'),
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
    
    public static function getPages(): array
    {
        return [
            'index' => Pages\ListProducts::route('/'),
            'create' => Pages\CreateProduct::route('/create'),
            'edit' => Pages\EditProduct::route('/{record}/edit'),
        ];
    }
}
```

## 5. Access Panel

Navigate to `/admin` and sign in.

## Next Steps

- [crud-resource.md](crud-resource.md) - Full CRUD resource
- [master-detail.md](master-detail.md) - With relation managers
- [../packages/panels/resources.md](../packages/panels/resources.md) - Resource documentation