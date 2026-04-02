# Master-Detail Recipe

> Resource with RelationManagers for HasMany relationships.

## Scenario

- **Order** has many **Items**
- **Order** belongs to **Customer**
- Edit Order page shows Items as RelationManager

## 1. Models

```php
// Order.php
class Order extends Model
{
    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }
    
    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }
}

// OrderItem.php
class OrderItem extends Model
{
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }
    
    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
```

## 2. Generate Resource

```bash
php artisan make:filament-resource Order --separate
```

## 3. Create Relation Manager

```bash
php artisan make:filament-relation-manager OrderResource items
```

## 4. Relation Manager

```php
<?php

namespace App\Filament\Resources\Shop\Orders\RelationManagers;

use App\Models\Shop\Product;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables\Actions\CreateAction;
use Filament\Tables\Actions\DeleteAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class ItemsRelationManager extends RelationManager
{
    protected static string $relationship = 'items';
    
    protected static ?string $title = 'Order Items';
    
    public static function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('product_id')
                    ->relationship('product', 'name')
                    ->searchable()
                    ->required()
                    ->reactive()
                    ->afterStateUpdated(function ($state, callable $set) {
                        $product = Product::find($state);
                        $set('unit_price', $product?->price);
                    }),
                
                TextInput::make('quantity')
                    ->numeric()
                    ->default(1)
                    ->minValue(1)
                    ->required()
                    ->reactive()
                    ->afterStateUpdated(function ($state, callable $set, callable $get) {
                        $price = $get('unit_price') ?? 0;
                        $set('total', $state * $price);
                    }),
                
                TextInput::make('unit_price')
                    ->numeric()
                    ->disabled()
                    ->dehydrated(),
                
                TextInput::make('total')
                    ->numeric()
                    ->disabled()
                    ->dehydrated(),
            ]);
    }
    
    public function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('product.name')
                    ->searchable(),
                
                TextColumn::make('quantity'),
                
                TextColumn::make('unit_price')
                    ->money('USD'),
                
                TextColumn::make('total')
                    ->money('USD'),
            ])
            ->recordActions([
                DeleteAction::make(),
            ])
            ->headerActions([
                CreateAction::make()
                    ->mutateFormDataUsing(function (array $data): array {
                        $data['total'] = $data['quantity'] * $data['unit_price'];
                        return $data;
                    }),
            ]);
    }
}
```

## 5. Resource with Relations

```php
<?php

namespace App\Filament\Resources\Shop\Orders;

use App\Filament\Resources\Shop\Orders\Pages;
use App\Filament\Resources\Shop\Orders\RelationManagers\ItemsRelationManager;
use App\Filament\Resources\Shop\Orders\Schemas\OrderForm;
use App\Filament\Resources\Shop\Orders\Tables\OrdersTable;
use App\Models\Shop\Order;
use Filament\Resources\Resource;
use Filament\Support\Icons\Heroicon;

class OrderResource extends Resource
{
    protected static ?string $model = Order::class;
    
    protected static ?string $recordTitleAttribute = 'order_number';
    
    protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedShoppingCart;
    
    protected static ?string $navigationGroup = 'Shop';
    
    public static function form(Schema $schema): Schema
    {
        return OrderForm::configure($schema);
    }
    
    public static function table(Table $table): Table
    {
        return OrdersTable::configure($table);
    }
    
    public static function getRelations(): array
    {
        return [
            ItemsRelationManager::class,
        ];
    }
    
    public static function getPages(): array
    {
        return [
            'index' => Pages\ListOrders::route('/'),
            'create' => Pages\CreateOrder::route('/create'),
            'edit' => Pages\EditOrder::route('/{record}/edit'),
        ];
    }
}
```

## 6. Order Form

```php
<?php

namespace App\Filament\Resources\Shop\Orders\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Schema;

class OrderForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Order Details')
                    ->schema([
                        TextInput::make('order_number')
                            ->default('ORD-' . str()->random(8))
                            ->disabled()
                            ->dehydrated()
                            ->required(),
                        
                        Select::make('customer_id')
                            ->relationship('customer', 'name')
                            ->searchable()
                            ->preload()
                            ->required(),
                        
                        Select::make('status')
                            ->options([
                                'pending' => 'Pending',
                                'processing' => 'Processing',
                                'shipped' => 'Shipped',
                                'delivered' => 'Delivered',
                            ])
                            ->default('pending')
                            ->required(),
                    ])
                    ->columns(3),
            ]);
    }
}
```

## 7. Edit Page with Relation Manager

The Edit page automatically shows RelationManagers in tabs below the form.

```php
<?php

namespace App\Filament\Resources\Shop\Orders\Pages;

use App\Filament\Resources\Shop\Orders\OrderResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditOrder extends EditRecord
{
    protected static string $resource = OrderResource::class;
    
    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
```

## Multiple Relation Managers

Add more relations for additional relationships:

```php
public static function getRelations(): array
{
    return [
        ItemsRelationManager::class,
        PaymentsRelationManager::class,
        AddressesRelationManager::class,
    ];
}
```

Each appears as a tab on the Edit page.

## Related

- [crud-resource.md](crud-resource.md) - Basic CRUD
- [../patterns/relationships.md](../patterns/relationships.md) - Relationship patterns
- [../packages/panels/resources.md](../packages/panels/resources.md) - Resource documentation