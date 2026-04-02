# Conditional Fields Pattern

> Dynamic visibility and reactive forms using Get/Set utilities.

## Get Utility

Read other field values for conditional logic.

```php
use Filament\Schemas\Components\Utilities\Get;

Select::make('type')
    ->options([
        'personal' => 'Personal',
        'business' => 'Business',
    ])
    ->live()

TextInput::make('company_name')
    ->visible(fn (Get $get): bool => $get('type') === 'business')
    ->required(fn (Get $get): bool => $get('type') === 'business')
```

## Set Utility

Set other field values programmatically.

```php
use Filament\Schemas\Components\Utilities\Set;

TextInput::make('name')
    ->live(onBlur: true)
    ->afterStateUpdated(function (string $operation, $state, Set $set): void {
        if ($operation !== 'create') {
            return;
        }
        $set('slug', Str::slug($state));
    })
```

## Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php`

```php
TextInput::make('name')
    ->required()
    ->maxLength(255)
    ->live(onBlur: true)
    ->afterStateUpdated(function (string $operation, $state, Set $set): void {
        if ($operation !== 'create') {
            return;
        }
        $set('slug', Str::slug($state));
    })
```

## Live Updates

Make fields reactive:

```php
// Update on every change
Select::make('country')
    ->live()

// Update on blur (better performance)
TextInput::make('name')
    ->live(onBlur: true)

// Update after debounce (in milliseconds)
TextInput::make('search')
    ->live(debounce: 500)
```

## Visibility Patterns

### Based on Other Field

```php
Select::make('status')
    ->options(['draft', 'published', 'archived'])
    ->live()

DateTimePicker::make('published_at')
    ->visible(fn (Get $get): bool => $get('status') === 'published')
```

### Based on Multiple Fields

```php
TextInput::make('discount')
    ->visible(fn (Get $get): bool => 
        $get('status') === 'published' && $get('price') > 100
    )
```

### Based on Operation

```php
TextInput::make('password')
    ->password()
    ->requiredOn('create')
    ->visibleOn('create')
```

### Based on Record

```php
TextInput::make('admin_notes')
    ->visible(fn ($record) => $record?->status === 'reviewing')
```

### Based on User

```php
TextInput::make('internal_notes')
    ->visible(fn () => auth()->user()->isAdmin())
```

## Conditional Validation

```php
TextInput::make('company_name')
    ->requiredIf('type', 'business')
    ->visible(fn (Get $get): bool => $get('type') === 'business')
```

## Computed Values

### Auto-calculate Fields

```php
TextInput::make('quantity')
    ->numeric()
    ->live()
    ->afterStateUpdated(function ($state, Set $set, Get $get): void {
        $price = $get('unit_price') ?? 0;
        $set('total', $state * $price);
    })

TextInput::make('unit_price')
    ->numeric()
    ->live()
    ->afterStateUpdated(function ($state, Set $set, Get $get): void {
        $quantity = $get('quantity') ?? 0;
        $set('total', $state * $quantity);
    })

TextInput::make('total')
    ->numeric()
    ->disabled()
    ->dehydrated()
```

### Generate from Related Fields

```php
TextInput::make('first_name')
    ->live(onBlur: true)

TextInput::make('last_name')
    ->live(onBlur: true)
    ->afterStateUpdated(function (Set $set, Get $get): void {
        $first = $get('first_name') ?? '';
        $last = $get('last_name') ?? '';
        $set('full_name', trim("$first $last"));
    })
```

## JavaScript Visibility

For client-side only visibility (no server request):

```php
Select::make('type')
    ->options(['personal', 'business'])

TextInput::make('company_name')
    ->hiddenJs('filament.forms.components.container.form.data.type !== "business"')
```

## Conditional in Repeater

```php
Repeater::make('items')
    ->schema([
        Select::make('type')
            ->options(['product', 'service'])
            ->live(),
        
        TextInput::make('product_name')
            ->visible(fn (Get $get): bool => $get('type') === 'product'),
        
        TextInput::make('service_name')
            ->visible(fn (Get $get): bool => $get('type') === 'service'),
    ])
```

## Related

- [../packages/forms/components.md](../packages/forms/components.md) - Form fields
- [../packages/forms/validation.md](../packages/forms/validation.md) - Conditional validation