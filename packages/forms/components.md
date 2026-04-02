# Forms - Components

> Package: `filament/forms` | All form field types.

## Namespace

```php
use Filament\Forms\Components\{Field};
```

## Available Fields

| Field | Purpose | Namespace |
|-------|---------|-----------|
| `TextInput` | Text input | `Filament\Forms\Components\TextInput` |
| `Select` | Dropdown select | `Filament\Forms\Components\Select` |
| `Checkbox` | Single checkbox | `Filament\Forms\Components\Checkbox` |
| `Toggle` | Toggle switch | `Filament\Forms\Components\Toggle` |
| `CheckboxList` | Multiple checkboxes | `Filament\Forms\Components\CheckboxList` |
| `Radio` | Radio buttons | `Filament\Forms\Components\Radio` |
| `DatePicker` | Date picker | `Filament\Forms\Components\DatePicker` |
| `DateTimePicker` | Date + time picker | `Filament\Forms\Components\DateTimePicker` |
| `TimePicker` | Time picker | `Filament\Forms\Components\TimePicker` |
| `FileUpload` | File upload | `Filament\Forms\Components\FileUpload` |
| `RichEditor` | WYSIWYG editor | `Filament\Forms\Components\RichEditor` |
| `MarkdownEditor` | Markdown editor | `Filament\Forms\Components\MarkdownEditor` |
| `CodeEditor` | Code editor | `Filament\Forms\Components\CodeEditor` |
| `Repeater` | Repeatable fields | `Filament\Forms\Components\Repeater` |
| `Builder` | Dynamic blocks | `Filament\Forms\Components\Builder` |
| `TagsInput` | Tags input | `Filament\Forms\Components\TagsInput` |
| `Textarea` | Multi-line text | `Filament\Forms\Components\Textarea` |
| `KeyValue` | Key-value pairs | `Filament\Forms\Components\KeyValue` |
| `ColorPicker` | Color picker | `Filament\Forms\Components\ColorPicker` |
| `ToggleButtons` | Button toggle group | `Filament\Forms\Components\ToggleButtons` |
| `Slider` | Range slider | `Filament\Forms\Components\Slider` |
| `Hidden` | Hidden field | `Filament\Forms\Components\Hidden` |
| `Placeholder` | Display-only text | `Filament\Forms\Components\Placeholder` |
| `Select` (Modal) | Modal table select | `Filament\Forms\Components\ModalTableSelect` |
| `Select` (Table) | Embedded table select | `Filament\Forms\Components\TableSelect` |

## TextInput

Basic text input field.

```php
use Filament\Forms\Components\TextInput;

TextInput::make('name')
    ->label('Full Name')
    ->required()
    ->maxLength(255)
    ->placeholder('Enter name')
```

### Input Types

```php
TextInput::make('email')->email()         // Email type
TextInput::make('amount')->numeric()       // Numeric
TextInput::make('count')->integer()        // Integer
TextInput::make('password')->password()    // Password
TextInput::make('phone')->tel()            // Phone
TextInput::make('website')->url()          // URL
TextInput::make('hex')->type('color')      // Custom type
```

### Numeric Methods

```php
TextInput::make('price')
    ->numeric()
    ->minValue(0)
    ->maxValue(99999999.99)
    ->step(0.01)
    ->inputMode('decimal')
    ->prefix('$')
    ->suffix('USD')
```

### Validation

```php
TextInput::make('name')
    ->required()
    ->maxLength(255)
    ->minLength(2)
    ->alpha()
    ->alphaDash()
    ->alphaNum()
    ->regex('/^[A-Z]+$/')
    ->unique(Product::class, 'slug', ignoreRecord: true)
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php
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

## Select

Dropdown select field.

```php
use Filament\Forms\Components\Select;

Select::make('status')
    ->options([
        'draft' => 'Draft',
        'published' => 'Published',
        'archived' => 'Archived',
    ])
    ->required()
```

### Relationship Select

```php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->searchable()
    ->preload()
    ->createOptionForm([
        TextInput::make('name')->required(),
    ])
```

### Multiple Select

```php
Select::make('categories')
    ->relationship('categories', 'name')
    ->multiple()
    ->searchable()
```

### Enum Select

```php
Select::make('status')
    ->options(OrderStatus::class)  // Uses enum labels
```

### Native Select

```php
Select::make('country')
    ->options(Country::pluck('name', 'code'))
    ->native()  // Use native HTML select
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php
Select::make('brand_id')
    ->relationship('brand', 'name')
    ->searchable()
    ->hiddenOn(ProductsRelationManager::class)

Select::make('productCategories')
    ->relationship('productCategories', 'name')
    ->multiple()
    ->required()
```

## Checkbox

Single checkbox.

```php
use Filament\Forms\Components\Checkbox;

Checkbox::make('accept_terms')
    ->label('I accept the terms and conditions')
    ->required()
```

## Toggle

Toggle switch.

```php
use Filament\Forms\Components\Toggle;

Toggle::make('is_visible')
    ->label('Visibility')
    ->default(true)
    ->onColor('success')
    ->offColor('danger')
```

## CheckboxList

Multiple checkboxes.

```php
use Filament\Forms\Components\CheckboxList;

CheckboxList::make('permissions')
    ->options([
        'view' => 'View',
        'edit' => 'Edit',
        'delete' => 'Delete',
    ])
    ->bulkToggleable()
    ->columns(2)
    ->searchable()
```

## Radio

Radio button group.

```php
use Filament\Forms\Components\Radio;

Radio::make('gender')
    ->options([
        'male' => 'Male',
        'female' => 'Female',
        'other' => 'Other',
    ])
    ->inline()
```

## DatePicker

Date picker.

```php
use Filament\Forms\Components\DatePicker;

DatePicker::make('published_at')
    ->label('Publishing Date')
    ->default(now())
    ->required()
    ->minDate(now())
    ->maxDate(now()->addYear())
    ->displayFormat('M j, Y')
    ->format('Y-m-d')
```

## DateTimePicker

Date and time picker.

```php
use Filament\Forms\Components\DateTimePicker;

DateTimePicker::make('meeting_at')
    ->required()
    ->seconds(false)
    ->timezone('America/New_York')
```

## FileUpload

File upload with preview.

```php
use Filament\Forms\Components\FileUpload;

FileUpload::make('avatar')
    ->image()
    ->avatar()
    ->maxSize(1024 * 1024)  // 1MB
    ->acceptedFileTypes(['image/jpeg', 'image/png'])
    ->directory('avatars')
    ->visibility('public')  // IMPORTANT: default is 'private'
    ->imageResizeMode('force')
    ->imageResizeTargetWidth(200)
    ->imageResizeTargetHeight(200)
```

### Multiple Files

```php
FileUpload::make('documents')
    ->multiple()
    ->maxFiles(5)
    ->reorderable()
```

### Real Example

```php
// From: demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php
SpatieMediaLibraryFileUpload::make('media')
    ->collection('product-images')
    ->multiple()
    ->maxFiles(5)
    ->reorderable()
    ->acceptedFileTypes(['image/jpeg'])
    ->hiddenLabel()
```

## RichEditor

WYSIWYG rich text editor.

```php
use Filament\Forms\Components\RichEditor;

RichEditor::make('content')
    ->toolbarButtons([
        'bold', 'italic', 'underline',
        'bulletList', 'orderedList',
        'link', 'blockquote',
    ])
    ->fileAttachmentsDirectory('content-images')
    ->fileAttachmentsVisibility('public')
```

## MarkdownEditor

Markdown editor.

```php
use Filament\Forms\Components\MarkdownEditor;

MarkdownEditor::make('content')
    ->disableToolbarButtons(['codeBlock'])
```

## Repeater

Repeatable field groups.

```php
use Filament\Forms\Components\Repeater;
use Filament\Schemas\Components\Grid;

Repeater::make('items')
    ->schema([
        TextInput::make('name')->required(),
        TextInput::make('quantity')->numeric()->default(1),
        TextInput::make('price')->numeric(),
    ])
    ->columns(2)
    ->minItems(1)
    ->maxItems(10)
    ->reorderable()
    ->collapsible()
    ->itemLabel(fn (array $state): ?string => $state['name'] ?? null)
```

### Relationship Repeater

```php
Repeater::make('items')
    ->relationship('items')
    ->schema([
        Select::make('product_id')->relationship('product', 'name'),
        TextInput::make('quantity')->numeric(),
    ])
    ->orderColumn('sort_order')
```

## Builder

Dynamic block-based content.

```php
use Filament\Forms\Components\Builder;

Builder::make('content')
    ->blocks([
        Builder\Block::make('heading')
            ->schema([
                TextInput::make('content')->required(),
                Select::make('level')->options(['h1', 'h2', 'h3']),
            ]),
        Builder\Block::make('paragraph')
            ->schema([
                RichEditor::make('content')->required(),
            ]),
        Builder\Block::make('image')
            ->schema([
                FileUpload::make('url')->image()->required(),
            ]),
    ])
    ->addActionLabel('Add block')
    ->collapsible()
    ->blockLabels(['heading' => 'Heading', 'paragraph' => 'Paragraph'])
```

## TagsInput

Tags input field.

```php
use Filament\Forms\Components\TagsInput;

TagsInput::make('keywords')
    ->splitKeys([',', 'Tab', 'Enter'])
    ->placeholder('Add keywords')
    ->reorderable()
```

## Textarea

Multi-line text input.

```php
use Filament\Forms\Components\Textarea;

Textarea::make('notes')
    ->rows(3)
    ->cols(50)
    ->maxLength(1000)
    ->autosize()
```

## KeyValue

Key-value pair editor.

```php
use Filament\Forms\Components\KeyValue;

KeyValue::make('meta_data')
    ->keyLabel('Property')
    ->valueLabel('Value')
    ->addActionLabel('Add property')
    ->reorderable()
```

## ColorPicker

Color picker.

```php
use Filament\Forms\Components\ColorPicker;

ColorPicker::make('background_color')
    ->format('hex')  // or 'rgb', 'hsl'
```

## ToggleButtons

Button toggle group.

```php
use Filament\Forms\Components\ToggleButtons;

ToggleButtons::make('status')
    ->options([
        'draft' => 'Draft',
        'reviewing' => 'Reviewing',
        'published' => 'Published',
    ])
    ->inline()
    ->colors([
        'draft' => 'gray',
        'reviewing' => 'warning',
        'published' => 'success',
    ])
```

## Slider

Range slider.

```php
use Filament\Forms\Components\Slider;

Slider::make('rating')
    ->min(1)
    ->max(5)
    ->step(0.5)
    ->marks()
    ->range(['min' => [1, '1'], 'max' => [5, '5']])
```

## Hidden

Hidden field (not visible but submitted).

```php
use Filament\Forms\Components\Hidden;

Hidden::make('user_id')
    ->default(fn () => auth()->id())
```

## Placeholder

Display-only field (not submitted).

```php
use Filament\Forms\Components\Placeholder;

Placeholder::make('created_at')
    ->label('Created')
    ->content(fn ($record) => $record->created_at->diffForHumans())
```

## Common Field Methods

All fields support these methods:

| Method | Purpose | Example |
|--------|---------|---------|
| `label()` | Custom label | `->label('Full Name')` |
| `hiddenLabel()` | Hide label | `->hiddenLabel()` |
| `required()` | Required field | `->required()` |
| `default()` | Default value | `->default('John')` |
| `disabled()` | Disable field | `->disabled()` |
| `hidden()` | Hide field | `->hidden()` |
| `visible()` | Show conditionally | `->visible(fn () => true)` |
| `helperText()` | Help text | `->helperText('Enter your name')` |
| `hint()` | Hint text | `->hint('Optional')` |
| `placeholder()` | Placeholder | `->placeholder('Enter value')` |
| `prefix()` | Prefix text | `->prefix('$')` |
| `suffix()` | Suffix text | `->suffix('USD')` |
| `live()` | Reactive updates | `->live()` or `->live(onBlur: true)` |
| `afterStateUpdated()` | State change hook | `->afterStateUpdated(fn ($state) => ...)` |
| `dehydrated()` | Include in form data | `->dehydrated(true)` |
| `formatStateUsing()` | Transform state | `->formatStateUsing(fn ($state) => ...)` |
| `saveRelationshipsUsing()` | Custom save logic | `->saveRelationshipsUsing(fn () => ...)` |

## Related

- [validation.md](validation.md) - Validation rules
- [relationships.md](relationships.md) - Relationship fields
- [../schemas/layout.md](../schemas/layout.md) - Layout components
- [../../patterns/conditional-fields.md](../../patterns/conditional-fields.md) - Conditional visibility