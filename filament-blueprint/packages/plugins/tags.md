# Plugins - Spatie Tags

> Package: `filament/spatie-laravel-tags-plugin` | Tags management with Spatie Tags.

## Installation

```bash
composer require filament/spatie-laravel-tags-plugin:"^3.0"
```

## Setup

Add to panel:

```php
use Filament\SpatieLaravelTagsPlugin\SpatieLaravelTagsPlugin;

$panel->plugin(SpatieLaravelTagsPlugin::make())
```

## Form Component

### Tags Input

```php
use Filament\Forms\Components\SpatieTagsInput;

SpatieTagsInput::make('tags')
```

### With Type

```php
SpatieTagsInput::make('tags')
    ->type('categories')  // Tag type
```

### With Suggestions

```php
SpatieTagsInput::make('tags')
    ->suggestions([
        'featured',
        'trending',
        'popular',
    ])
```

### Split Keys

```php
SpatieTagsInput::make('tags')
    ->splitKeys([',', 'Tab', 'Enter'])
```

## Table Column

```php
use Filament\Tables\Columns\SpatieTagsColumn;

SpatieTagsColumn::make('tags')
    ->separator(',')  // If using single string
```

### With Type

```php
SpatieTagsColumn::make('tags')
    ->type('categories')
```

## Infolist Entry

```php
use Filament\Infolists\Components\SpatieTagsEntry;

SpatieTagsEntry::make('tags')
    ->separator(', ')
```

## Component Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `type()` | Tag type | `->type('categories')` |
| `suggestions()` | Predefined tags | `->suggestions([...])` |
| `splitKeys()` | Split keys | `->splitKeys([',', 'Tab'])` |
| `separator()` | Display separator | `->separator(', ')` |
| `limit()` | Limit displayed | `->limit(5)` |

## Model Setup

Ensure model uses `HasTags` trait:

```php
use Spatie\Tags\HasTags;

class Post extends Model
{
    use HasTags;
}
```

## Related

- [../forms/components.md](../forms/components.md) - TagsInput component
- [../tables/columns.md](../tables/columns.md) - TagsColumn