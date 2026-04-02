# Forms - Validation

> Package: `filament/forms` | Validation rules and patterns.

## Validation Methods

### Required

```php
TextInput::make('name')->required()
TextInput::make('name')->requiredIf('status', 'published')
TextInput::make('name')->requiredUnless('status', 'draft')
TextInput::make('name')->requiredWith('email')
TextInput::make('name')->requiredWithout('email')
TextInput::make('name')->requiredWithAll(['email', 'phone'])
TextInput::make('name')->requiredWithoutAll(['email', 'phone'])
TextInput::make('name')->requiredOn('create')
TextInput::make('name')->requiredOn(['create', 'edit'])
```

### String Length

```php
TextInput::make('name')
    ->maxLength(255)
    ->minLength(2)
    ->maxWords(100)
    ->minWords(10)
```

### Numeric

```php
TextInput::make('price')
    ->numeric()
    ->minValue(0)
    ->maxValue(999999.99)
    ->integer()
    ->multipleOf(5)
```

### Email & URL

```php
TextInput::make('email')
    ->email()
    ->emailStrict()  // RFC validation

TextInput::make('website')
    ->url()
    ->activeUrl()
```

### Date & Time

```php
DatePicker::make('start_date')
    ->before('end_date')
    ->after('today')
    ->beforeOrEqual('end_date')
    ->afterOrEqual('today')

DateTimePicker::make('meeting_at')
    ->beforeToday()
    ->afterToday()
```

### File Validation

```php
FileUpload::make('avatar')
    ->image()
    ->maxSize(1024 * 1024)  // 1MB
    ->minSize(100)
    ->maxWidth(2000)
    ->minWidth(100)
    ->maxHeight(2000)
    ->minHeight(100)
    ->acceptedFileTypes(['image/jpeg', 'image/png'])
    ->dimensions(Rule::dimensions()->maxWidth(1000)->maxHeight(500))
```

### Comparison

```php
TextInput::make('password')
    ->same('password_confirmation')
    ->different('old_password')
    ->confirmed()  // requires password_confirmation field
```

### String Patterns

```php
TextInput::make('code')
    ->alpha()           // Only letters
    ->alphaDash()       // Letters, numbers, dashes, underscores
    ->alphaNum()        // Letters and numbers
    ->regex('/^[A-Z]{3}$/')
    ->doesntStartWith(['http', 'https'])
    ->startsWith(['+1', '+44'])
    ->endsWith(['.com', '.org'])
    ->uuid()
    ->ip()
    ->ipv4()
    ->ipv6()
    ->macAddress()
```

### Database

```php
TextInput::make('slug')
    ->unique(Product::class, 'slug', ignoreRecord: true)
    ->unique(ignorable: fn ($record) => $record)
    ->exists(Product::class, 'slug')
```

### Custom Rules

```php
use Illuminate\Validation\Rule;

TextInput::make('status')
    ->rule(Rule::in(['draft', 'published']))
    ->rule('custom_rule')
    ->rules(['required', 'max:255'])
    ->rules([
        Rule::unique('products', 'slug')->ignore($record),
    ])
```

### Regex Validation

```php
TextInput::make('price')
    ->numeric()
    ->rules(['regex:/^\d{1,6}(\.\d{0,2})?$/'])
```

## Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php`

```php
TextInput::make('price')
    ->numeric()
    ->minValue(0)
    ->maxValue(99999999.99)
    ->rules(['regex:/^\d{1,6}(\.\d{0,2})?$/'])
    ->required()

TextInput::make('sku')
    ->label('SKU (Stock Keeping Unit)')
    ->unique(Product::class, 'sku', ignoreRecord: true)
    ->maxLength(255)
    ->required()

TextInput::make('qty')
    ->label('Quantity')
    ->numeric()
    ->minValue(0)
    ->maxValue(18446744073709551615)
    ->integer()
    ->required()
```

## Conditional Validation

### Based on Operation

```php
TextInput::make('password')
    ->password()
    ->requiredOn('create')
    ->dehydrated(fn ($state) => filled($state))
```

### Based on Other Field

```php
Select::make('type')
    ->options(['personal', 'business'])
    ->live()

TextInput::make('company_name')
    ->requiredIf('type', 'business')
    ->visible(fn (Get $get) => $get('type') === 'business')
```

### Custom Conditional

```php
TextInput::make('field')
    ->required(fn (Get $get) => $get('other_field') === 'value')
```

## Validation Messages

### Custom Messages

```php
TextInput::make('email')
    ->email()
    ->validationMessages([
        'email.email' => 'Please enter a valid email address.',
        'email.required' => 'Your email is required.',
    ])
```

## Validation Hooks

### Before Validation

```php
TextInput::make('slug')
    ->afterStateUpdated(function ($state, Set $set) {
        $set('slug', Str::slug($state));
    })
```

### Custom Validation Logic

```php
TextInput::make('custom_field')
    ->validateUsing(function ($state, $component, $context) {
        if ($state === 'invalid') {
            $component->addError('custom_field', 'This value is not allowed.');
        }
    })
```

## Available Validation Rules

| Rule | Method |
|------|--------|
| Required | `required()` |
| Required if | `requiredIf($field, $value)` |
| Required unless | `requiredUnless($field, $value)` |
| Required with | `requiredWith($field)` |
| Required without | `requiredWithout($field)` |
| Max length | `maxLength($length)` |
| Min length | `minLength($length)` |
| Max words | `maxWords($count)` |
| Min words | `minWords($count)` |
| Email | `email()` |
| URL | `url()` |
| Numeric | `numeric()` |
| Integer | `integer()` |
| Min value | `minValue($value)` |
| Max value | `maxValue($value)` |
| Before date | `before($date)` |
| After date | `after($date)` |
| Same | `same($field)` |
| Different | `different($field)` |
| Confirmed | `confirmed()` |
| Unique | `unique($model, $column, ignoreRecord)` |
| Exists | `exists($model, $column)` |
| In | `rule(Rule::in([...]))` |
| Regex | `regex($pattern)` |
| Alpha | `alpha()` |
| Alpha dash | `alphaDash()` |
| Alpha numeric | `alphaNum()` |
| UUID | `uuid()` |
| IP | `ip()` |
| Active URL | `activeUrl()` |
| Multiple of | `multipleOf($value)` |

## Related

- [components.md](components.md) - Form fields
- [../../patterns/conditional-fields.md](../../patterns/conditional-fields.md) - Conditional visibility