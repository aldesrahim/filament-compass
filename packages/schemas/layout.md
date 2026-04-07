# Schemas - Layout

> Package: `filament/schemas` | Layout components for forms and infolists.

## Namespace

```php
use Filament\Schemas\Components\{Component};
```

## Available Layout Components

| Component | Purpose | Namespace |
|-----------|---------|-----------|
| `Grid` | Multi-column grid | `Filament\Schemas\Components\Grid` |
| `Group` | Horizontal group | `Filament\Schemas\Components\Group` |
| `Section` | Sectioned content | `Filament\Schemas\Components\Section` |
| `Fieldset` | Fieldset grouping | `Filament\Schemas\Components\Fieldset` |
| `Tabs` | Tabbed content | `Filament\Schemas\Components\Tabs` |
| `Wizard` | Multi-step wizard | `Filament\Schemas\Components\Wizard` |
| `Actions` | Action buttons | `Filament\Schemas\Components\Actions` |
| `Callout` | Alert/callout box | `Filament\Schemas\Components\Callout` |
| `Flex` | Flex container | `Filament\Schemas\Components\Flex` |
| `FusedGroup` | Fused fields | `Filament\Schemas\Components\FusedGroup` |
| `Html` | Raw HTML | `Filament\Schemas\Components\Html` |
| `Icon` | Icon display | `Filament\Schemas\Components\Icon` |
| `Image` | Image display | `Filament\Schemas\Components\Image` |
| `Livewire` | Livewire component | `Filament\Schemas\Components\Livewire` |
| `Text` | Text display | `Filament\Schemas\Components\Text` |
| `UnorderedList` | Bullet list | `Filament\Schemas\Components\UnorderedList` |
| `EmptyState` | Empty state placeholder | `Filament\Schemas\Components\EmptyState` |
| `RenderHook` | Filament render hook | `Filament\Schemas\Components\RenderHook` |
| `View` | Custom view component | `Filament\Schemas\Components\View` |

## Grid

Multi-column layout.

```php
use Filament\Schemas\Components\Grid;

Grid::make(3)
    ->schema([
        TextInput::make('name'),
        TextInput::make('email'),
        TextInput::make('phone'),
    ])
```

### Responsive Columns

```php
Grid::make()
    ->schema([
        TextInput::make('name'),
        TextInput::make('email'),
    ])
    ->columns([
        'sm' => 1,
        'md' => 2,
        'lg' => 3,
        'xl' => 4,
    ])

// Or shorthand
Grid::make(3)  // lg and above
```

### Column Span

```php
TextInput::make('description')
    ->columnSpan(2)  // Span 2 columns

TextInput::make('content')
    ->columnSpan('full')  // Span all columns

TextInput::make('sidebar')
    ->columnSpan(['lg' => 2])  // Responsive span
```

## Group

Horizontal group (inline fields).

```php
use Filament\Schemas\Components\Group;

Group::make()
    ->schema([
        TextInput::make('first_name'),
        TextInput::make('last_name'),
    ])
    ->columns(2)
```

## Section

Grouped content with optional header.

```php
use Filament\Schemas\Components\Section;

Section::make('Personal Information')
    ->description('Basic user details')
    ->schema([
        TextInput::make('name'),
        TextInput::make('email'),
    ])
    ->columns(2)
    ->collapsible()
    ->collapsed()
    ->icon('heroicon-o-user')
```

### Section Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `make()` | Section title | `Section::make('Title')` |
| `description()` | Description text | `->description('Description')` |
| `schema()` | Child components | `->schema([...])` |
| `columns()` | Grid columns | `->columns(2)` |
| `collapsible()` | Enable collapse | `->collapsible()` |
| `collapsed()` | Start collapsed | `->collapsed()` |
| `icon()` | Header icon | `->icon('heroicon-o-user')` |
| `aside()` | Sidebar layout | `->aside()` |

## Fieldset

Grouped fields with border.

```php
use Filament\Schemas\Components\Fieldset;

Fieldset::make('Pricing')
    ->schema([
        TextInput::make('price'),
        TextInput::make('compare_at_price'),
    ])
    ->columns(2)
```

## Tabs

Tabbed content.

```php
use Filament\Schemas\Components\Tabs;

Tabs::make('tabs')
    ->tabs([
        Tabs\Tab::make('Details')
            ->schema([
                TextInput::make('name'),
                TextInput::make('email'),
            ]),
        Tabs\Tab::make('Settings')
            ->schema([
                Toggle::make('is_active'),
                Select::make('role'),
            ]),
    ])
```

### Tab Configuration

```php
Tabs\Tab::make('Details')
    ->schema([...])
    ->icon('heroicon-o-document')
    ->badge(5)
    ->active()
```

### Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php`

```php
Group::make()
    ->schema([
        Section::make()
            ->schema([
                TextInput::make('name')->required(),
                TextInput::make('slug')->disabled()->dehydrated(),
                RichEditor::make('description'),
            ])
            ->columns(2),
        
        Section::make('Pricing')
            ->schema([
                TextInput::make('price')->numeric(),
                TextInput::make('old_price')->numeric(),
                TextInput::make('cost')->numeric(),
            ])
            ->columns(2),
    ])
    ->columnSpan(['lg' => 2]),

Group::make()
    ->schema([
        Section::make('Status')
            ->schema([
                Toggle::make('is_visible'),
                DatePicker::make('published_at'),
            ]),
    ])
    ->columnSpan(['lg' => 1]),
```

## Wizard

Multi-step form wizard.

```php
use Filament\Schemas\Components\Wizard;

Wizard::make([
    Wizard\Step::make('Personal Info')
        ->schema([
            TextInput::make('name'),
            TextInput::make('email'),
        ]),
    Wizard\Step::make('Address')
        ->schema([
            TextInput::make('street'),
            TextInput::make('city'),
        ]),
    Wizard\Step::make('Review')
        ->schema([
            Placeholder::make('review'),
        ]),
])
    ->skippable()
    ->persistStepInQueryString()
```

### Wizard Step Configuration

```php
Wizard\Step::make('Details')
    ->label('Personal Details')
    ->description('Enter your information')
    ->icon('heroicon-o-user')
    ->schema([...])
    ->afterValidation(fn () => ...)
```

## Actions

Action buttons in form.

```php
use Filament\Schemas\Components\Actions;

Actions::make([
    Action::make('generate_slug')
        ->label('Generate Slug')
        ->action(fn (Set $set, Get $get) => $set('slug', Str::slug($get('name')))),
    Action::make('reset')
        ->label('Reset Form')
        ->action(fn ($component) => $component->getContainer()->fill()),
])
```

## Callout

Alert/callout box.

```php
use Filament\Schemas\Components\Callout;

Callout::make('Important')
    ->content('This action cannot be undone.')
    ->icon('heroicon-o-exclamation-triangle')
    ->color('warning')
```

## Flex

Flexbox container.

```php
use Filament\Schemas\Components\Flex;

Flex::make()
    ->schema([
        TextInput::make('amount'),
        Select::make('currency'),
    ])
    ->gap('md')
    ->align('center')
```

## FusedGroup

Fused input fields (e.g., domain input).

```php
use Filament\Schemas\Components\FusedGroup;

FusedGroup::make()
    ->schema([
        TextInput::make('subdomain'),
        TextInput::make('domain'),
    ])
    ->separator('.')
```

## Utilities

### Get

Read other field values.

```php
use Filament\Schemas\Components\Utilities\Get;

TextInput::make('company_name')
    ->visible(fn (Get $get): bool => $get('type') === 'business')
```

### Set

Set other field values.

```php
use Filament\Schemas\Components\Utilities\Set;

TextInput::make('name')
    ->live(onBlur: true)
    ->afterStateUpdated(fn (Set $set, $state) => $set('slug', Str::slug($state)))
```

## EmptyState

Empty state placeholder (no records found, placeholder content).

```php
use Filament\Schemas\Components\EmptyState;

EmptyState::make('No results found')
    ->description('Try adjusting your search or filters.')
    ->icon('heroicon-o-magnifying-glass')
    ->actions([
        Action::make('reset')->label('Reset filters')->action(fn () => ...),
    ])
```

## RenderHook

Render a Filament render hook inside a schema:

```php
use Filament\Schemas\Components\RenderHook;

RenderHook::make('panels::body.start')
RenderHook::make('panels::body.start', scopes: SomeResource::class)
```

## View

Custom view-based component:

```php
use Filament\Schemas\Components\View;

View::make('components.custom-block')
```

## Related

- [../forms/components.md](../forms/components.md) - Form fields
- [../infolists/entries.md](../infolists/entries.md) - Infolist entries
- [../../patterns/conditional-fields.md](../../patterns/conditional-fields.md) - Conditional visibility