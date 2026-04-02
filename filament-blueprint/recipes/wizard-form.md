# Wizard Form Recipe

> Multi-step wizard form for complex data entry.

## Basic Wizard

```php
use Filament\Schemas\Components\Wizard;
use Filament\Schemas\Schema;

public static function configure(Schema $schema): Schema
{
    return $schema
        ->components([
            Wizard::make([
                Wizard\Step::make('Personal Info')
                    ->description('Your basic information')
                    ->icon('heroicon-o-user')
                    ->schema([
                        TextInput::make('first_name')->required(),
                        TextInput::make('last_name')->required(),
                        TextInput::make('email')->email()->required(),
                    ]),
                
                Wizard\Step::make('Address')
                    ->description('Your delivery address')
                    ->icon('heroicon-o-map-pin')
                    ->schema([
                        TextInput::make('street')->required(),
                        TextInput::make('city')->required(),
                        TextInput::make('zip_code')->required(),
                        Select::make('country')
                            ->options(['US' => 'USA', 'CA' => 'Canada'])
                            ->required(),
                    ]),
                
                Wizard\Step::make('Payment')
                    ->description('Payment method')
                    ->icon('heroicon-o-credit-card')
                    ->schema([
                        Select::make('payment_method')
                            ->options(['credit_card', 'paypal'])
                            ->required(),
                        TextInput::make('card_number')
                            ->visible(fn (Get $get) => $get('payment_method') === 'credit_card'),
                    ]),
            ])
                ->skippable()
                ->persistStepInQueryString(),
        ]);
}
```

## Wizard Methods

| Method | Purpose |
|--------|---------|
| `skippable()` | Allow skipping steps |
| `persistStepInQueryString()` | Remember current step in URL |
| `startOnStep($step)` | Start on specific step |
| `nextAction($action)` | Customize next button |
| `previousAction($action)` | Customize previous button |

## Step Methods

| Method | Purpose |
|--------|---------|
| `make($key)` | Step identifier |
| `label($label)` | Step label |
| `description($description)` | Step description |
| `icon($icon)` | Step icon |
| `schema($schema)` | Step fields |
| `afterValidation($callback)` | Hook after step validation |

## Conditional Steps

```php
Wizard::make([
    Wizard\Step::make('Account Type')
        ->schema([
            Select::make('account_type')
                ->options(['personal', 'business'])
                ->live(),
        ]),
    
    Wizard\Step::make('Business Info')
        ->schema([
            TextInput::make('company_name'),
            TextInput::make('tax_id'),
        ])
        ->visible(fn (Get $get) => $get('account_type') === 'business'),
    
    Wizard\Step::make('Personal Info')
        ->schema([
            TextInput::make('full_name'),
        ])
        ->visible(fn (Get $get) => $get('account_type') === 'personal'),
])
```

## Step Validation Hook

Run logic after step validation:

```php
Wizard\Step::make('Address')
    ->schema([
        TextInput::make('zip_code')->required(),
    ])
    ->afterValidation(function (Get $get, Set $set) {
        // Look up city/state from zip
        $location = Location::findByZip($get('zip_code'));
        $set('city', $location->city);
        $set('state', $location->state);
    })
```

## Complete Checkout Wizard

```php
<?php

namespace App\Filament\Resources\Shop\Orders\Schemas;

use App\Models\Shop\Customer;
use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Components\Wizard;
use Filament\Schemas\Schema;

class OrderForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Wizard::make([
                    Wizard\Step::make('Customer')
                        ->icon('heroicon-o-user')
                        ->schema([
                            Select::make('customer_id')
                                ->relationship('customer', 'name')
                                ->searchable()
                                ->preload()
                                ->createOptionForm([
                                    TextInput::make('name')->required(),
                                    TextInput::make('email')->email()->required(),
                                    TextInput::make('phone'),
                                ])
                                ->required(),
                        ]),
                    
                    Wizard\Step::make('Items')
                        ->icon('heroicon-o-shopping-cart')
                        ->schema([
                            Repeater::make('items')
                                ->relationship('items')
                                ->schema([
                                    Select::make('product_id')
                                        ->relationship('product', 'name')
                                        ->searchable()
                                        ->required(),
                                    TextInput::make('quantity')
                                        ->numeric()
                                        ->default(1)
                                        ->required(),
                                ])
                                ->columns(2)
                                ->required(),
                        ]),
                    
                    Wizard\Step::make('Shipping')
                        ->icon('heroicon-o-truck')
                        ->schema([
                            TextInput::make('shipping_address')->required(),
                            TextInput::make('shipping_city')->required(),
                            TextInput::make('shipping_zip')->required(),
                            DatePicker::make('delivery_date'),
                            Textarea::make('notes')->rows(3),
                        ]),
                    
                    Wizard\Step::make('Review')
                        ->icon('heroicon-o-check-circle')
                        ->schema([
                            Placeholder::make('review')
                                ->content('Please review your order before submitting.'),
                        ]),
                ])
                    ->skippable()
                    ->persistStepInQueryString(),
            ]);
    }
}
```

## Related

- [../packages/schemas/layout.md](../packages/schemas/layout.md) - Wizard component
- [crud-resource.md](crud-resource.md) - Basic CRUD