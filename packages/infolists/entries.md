# Infolists - Entries

> Package: `filament/infolists` | Read-only display entries.

## Namespace

```php
use Filament\Infolists\Components\{Entry};
```

## Available Entries

| Entry | Purpose | Namespace |
|-------|---------|-----------|
| `TextEntry` | Text display | `Filament\Infolists\Components\TextEntry` |
| `IconEntry` | Icon display | `Filament\Infolists\Components\IconEntry` |
| `ImageEntry` | Image display | `Filament\Infolists\Components\ImageEntry` |
| `ColorEntry` | Color swatch | `Filament\Infolists\Components\ColorEntry` |
| `KeyValueEntry` | Key-value pairs | `Filament\Infolists\Components\KeyValueEntry` |
| `RepeatableEntry` | Repeating entries | `Filament\Infolists\Components\RepeatableEntry` |
| `CodeEntry` | Code display | `Filament\Infolists\Components\CodeEntry` |

## TextEntry

Display text content.

```php
use Filament\Infolists\Components\TextEntry;

TextEntry::make('name')
    ->label('Product Name')

TextEntry::make('email')
    ->copyable()
    ->icon('heroicon-o-envelope')
```

### Formatting

```php
TextEntry::make('price')
    ->money('USD')

TextEntry::make('created_at')
    ->dateTime()
    ->since()

TextEntry::make('description')
    ->limit(100)
    ->markdown()
    ->html()
```

### Badge Style

```php
TextEntry::make('status')
    ->badge()
    ->color(fn ($state) => match ($state) {
        'draft' => 'gray',
        'published' => 'success',
        'archived' => 'danger',
    })
```

### List Style

```php
TextEntry::make('tags')
    ->listWithLineBreaks()
    ->bulleted()
```

### Relationships

```php
TextEntry::make('brand.name')
TextEntry::make('author.email')
```

### Copyable

```php
TextEntry::make('api_key')
    ->copyable()
    ->copyMessage('Copied!')
    ->copyMessageDuration(1500)
```

## IconEntry

Display icon.

```php
use Filament\Infolists\Components\IconEntry;

IconEntry::make('is_active')
    ->boolean()
    ->trueIcon('heroicon-o-check-circle')
    ->falseIcon('heroicon-o-x-circle')
    ->trueColor('success')
    ->falseColor('danger')
```

### Custom Icons

```php
IconEntry::make('status')
    ->icon(fn ($state) => match ($state) {
        'draft' => 'heroicon-o-pencil',
        'published' => 'heroicon-o-check',
    })
    ->color(fn ($state) => match ($state) {
        'draft' => 'gray',
        'published' => 'success',
    })
```

## ImageEntry

Display image.

```php
use Filament\Infolists\Components\ImageEntry;

ImageEntry::make('avatar')
    ->circular()
    ->width(100)
    ->height(100)
    ->defaultImageUrl(fn () => asset('default-avatar.png'))
```

### Spatie Media Library

```php
use Filament\Infolists\Components\SpatieMediaLibraryImageEntry;

SpatieMediaLibraryImageEntry::make('image')
    ->collection('product-images')
    ->conversion('thumb')
```

## ColorEntry

Display color swatch.

```php
use Filament\Infolists\Components\ColorEntry;

ColorEntry::make('background_color')
    ->copyable()
```

## KeyValueEntry

Display key-value pairs.

```php
use Filament\Infolists\Components\KeyValueEntry;

KeyValueEntry::make('metadata')
    ->keyLabel('Property')
    ->valueLabel('Value')
```

## RepeatableEntry

Display repeating entries.

```php
use Filament\Infolists\Components\RepeatableEntry;

RepeatableEntry::make('items')
    ->schema([
        TextEntry::make('product.name'),
        TextEntry::make('quantity'),
        TextEntry::make('price')->money('USD'),
    ])
    ->columns(3)
```

## CodeEntry

Display code with syntax highlighting.

```php
use Filament\Infolists\Components\CodeEntry;

CodeEntry::make('snippet')
    ->language('php')
    ->copyable()
```

## Real Example

From demo: `demo/app/Filament/Resources/HR/Projects/Schemas/ProjectInfolist.php`

```php
<?php

namespace App\Filament\Resources\HR\Projects\Schemas;

use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Schema;

class ProjectInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextEntry::make('name'),
                TextEntry::make('description')->markdown(),
                TextEntry::make('status')->badge(),
                TextEntry::make('client.name'),
                TextEntry::make('budget')->money('USD'),
            ]);
    }
}
```

## Common Entry Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `label()` | Custom label | `->label('Name')` |
| `hiddenLabel()` | Hide label | `->hiddenLabel()` |
| `copyable()` | Copy to clipboard | `->copyable()` |
| `icon()` | Icon | `->icon('heroicon-o-check')` |
| `visible()` | Visible condition | `->visible(fn () => true)` |
| `hidden()` | Hidden condition | `->hidden()` |
| `placeholder()` | Empty placeholder | `->placeholder('N/A')` |
| `tooltip()` | Tooltip text | `->tooltip('Help text')` |
| `hint()` | Hint text near label | `->hint('Optional note')` |
| `hintColor()` | Hint text color | `->hintColor('warning')` |
| `hintIcon()` | Icon next to hint | `->hintIcon('heroicon-o-information-circle')` |
| `hintIconTooltip()` | Tooltip on hint icon | `->hintIconTooltip('More info')` |
| `hintAction()` | Action button next to label | `->hintAction(Action::make('help'))` |
| `hintActions()` | Multiple action buttons | `->hintActions([...])` |

## Related

- [../schemas/layout.md](../schemas/layout.md) - Layout components for infolists
- [../panels/pages.md](../panels/pages.md) - View page usage