# Plugins - Spatie Media Library

> Package: `filament/spatie-laravel-media-library-plugin` | File uploads with Spatie Media Library.

## Installation

```bash
composer require filament/spatie-laravel-media-library-plugin:"^3.0"
```

## Setup

Add to panel:

```php
use Filament\SpatieLaravelMediaLibraryPlugin\SpatieMediaLibraryPlugin;

$panel->plugin(SpatieMediaLibraryPlugin::make())
```

## Form Component

### Basic Upload

```php
use Filament\Forms\Components\SpatieMediaLibraryFileUpload;

SpatieMediaLibraryFileUpload::make('avatar')
    ->collection('avatars')
    ->image()
    ->avatar()
```

### Multiple Files

```php
SpatieMediaLibraryFileUpload::make('images')
    ->collection('product-images')
    ->multiple()
    ->maxFiles(5)
    ->reorderable()
```

### With Conversions

```php
SpatieMediaLibraryFileUpload::make('featured_image')
    ->collection('featured')
    ->conversion('thumb')  // Preview using conversion
    ->conversionOnHover('large')  // Show larger on hover
```

### Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Schemas/ProductForm.php`

```php
SpatieMediaLibraryFileUpload::make('media')
    ->collection('product-images')
    ->multiple()
    ->maxFiles(5)
    ->reorderable()
    ->acceptedFileTypes(['image/jpeg'])
    ->hiddenLabel()
```

## Table Column

### Basic Display

```php
use Filament\Tables\Columns\SpatieMediaLibraryImageColumn;

SpatieMediaLibraryImageColumn::make('avatar')
    ->collection('avatars')
    ->circular()
```

### With Conversion

```php
SpatieMediaLibraryImageColumn::make('image')
    ->collection('product-images')
    ->conversion('thumb')
```

### Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php`

```php
SpatieMediaLibraryImageColumn::make('image')
    ->collection('product-images')
    ->conversion('thumb')
```

## Infolist Entry

```php
use Filament\Infolists\Components\SpatieMediaLibraryImageEntry;

SpatieMediaLibraryImageEntry::make('images')
    ->collection('gallery')
    ->conversion('thumb')
    ->height(100)
    ->circular()
```

## Component Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `collection()` | Media collection name | `->collection('avatars')` |
| `conversion()` | Image conversion | `->conversion('thumb')` |
| `conversionOnHover()` | Hover conversion | `->conversionOnHover('large')` |
| `multiple()` | Multiple files | `->multiple()` |
| `maxFiles()` | Maximum files | `->maxFiles(5)` |
| `reorderable()` | Allow reordering | `->reorderable()` |
| `downloadable()` | Allow download | `->downloadable()` |
| `openable()` | Open in modal | `->openable()` |
| `svgSanitization()` | Sanitize SVGs | `->svgSanitization()` |

## Related

- [../forms/components.md](../forms/components.md) - FileUpload component
- [../tables/columns.md](../tables/columns.md) - ImageColumn
- [../infolists/entries.md](../infolists/entries.md) - ImageEntry