# Support - Utilities

> Package: `filament/support` | Icons, colors, and helper utilities.

## Icons

### Heroicon Enum

Use the `Heroicon` enum for all icons:

```php
use Filament\Support\Icons\Heroicon;

// Outlined icons (default)
Heroicon::OutlinedBolt
Heroicon::OutlinedCog
Heroicon::OutlinedUser

// Solid icons
Heroicon::SolidBolt
Heroicon::SolidCog
Heroicon::SolidUser
```

### Icon Usage

```php
// In resource
protected static string | BackedEnum | null $navigationIcon = Heroicon::OutlinedBolt;

// In action
Action::make('edit')
    ->icon(Heroicon::PencilSquare)

// In column
IconColumn::make('is_active')
    ->trueIcon(Heroicon::CheckCircle)
```

### Common Icons

| Icon | Enum |
|------|------|
| User | `Heroicon::OutlinedUser` |
| Cog/Settings | `Heroicon::OutlinedCog` |
| Home | `Heroicon::OutlinedHome` |
| Document | `Heroicon::OutlinedDocument` |
| Folder | `Heroicon::OutlinedFolder` |
| Plus | `Heroicon::OutlinedPlus` |
| Pencil | `Heroicon::OutlinedPencil` |
| Trash | `Heroicon::OutlinedTrash` |
| Eye | `Heroicon::OutlinedEye` |
| Check | `Heroicon::OutlinedCheck` |
| X | `Heroicon::OutlinedX` |
| Search | `Heroicon::OutlinedMagnifyingGlass` |
| Filter | `Heroicon::OutlinedFunnel` |
| Download | `Heroicon::OutlinedArrowDownTray` |
| Upload | `Heroicon::OutlinedArrowUpTray` |
| Star | `Heroicon::OutlinedStar` |
| Heart | `Heroicon::OutlinedHeart` |
| Bell | `Heroicon::OutlinedBell` |
| Mail | `Heroicon::OutlinedEnvelope` |
| Link | `Heroicon::OutlinedLink` |

## Colors

### Built-in Colors

```php
use Filament\Support\Colors\Color;

Color::Amber
Color::Blue
Color::Cyan
Color::Emerald
Color::Fuchsia
Color::Gray
Color::Green
Color::Indigo
Color::Lime
Color::Orange
Color::Pink
Color::Purple
Color::Red
Color::Rose
Color::Sky
Color::Slate
Color::Teal
Color::Violet
Color::Yellow
Color::Zinc
```

### Custom Colors

```php
use Filament\Support\Colors\Color;

// From hex
Color::hex('#ff0000')

// From RGB
Color::rgb(255, 0, 0)
```

### Using Colors

```php
// In panel configuration
$panel->colors([
    'primary' => Color::Amber,
    'secondary' => Color::Gray,
])

// In component
Action::make('approve')
    ->color('success')

TextColumn::make('status')
    ->badge()
    ->color(fn ($state) => match ($state) {
        'draft' => 'gray',
        'published' => 'success',
        'archived' => 'danger',
    })
```

### Semantic Colors

| Color | Usage |
|-------|-------|
| `primary` | Primary actions |
| `secondary` | Secondary actions |
| `success` | Success states |
| `warning` | Warning states |
| `danger` | Error/destructive states |
| `info` | Information |
| `gray` | Neutral states |

## RawJs

Execute JavaScript code.

```php
use Filament\Support\RawJs;

TextInput::make('price')
    ->formatStateUsing(RawJs::make('$money($state)'))
```

## Markdown

Render markdown content.

```php
use Filament\Support\Markdown;

TextEntry::make('content')
    ->markdown()
```

## Facades

### FilamentColor

```php
use Filament\Support\Facades\FilamentColor;

FilamentColor::register([
    'primary' => Color::Amber,
]);
```

### FilamentIcon

```php
use Filament\Support\Facades\FilamentIcon;

FilamentIcon::register([
    'panels::topbar.global-search.button' => Heroicon::OutlinedMagnifyingGlass,
]);
```

### FilamentView

```php
use Filament\Support\Facades\FilamentView;

FilamentView::registerRenderHook(
    'panels::body.end',
    fn () => view('analytics')
);
```

## Helpers

Global helper functions.

### filament()

Get the Filament manager.

```php
filament()->getCurrentPanel();
filament()->getTenant();
filament()->getUser();
```

### filament_asset()

Get asset URLs.

```php
filament_asset('js/app.js');
```

## Enums

### Font Weight

```php
use Filament\Support\Enums\FontWeight;

TextColumn::make('name')
    ->weight(FontWeight::Medium)

// Available: Thin, ExtraLight, Light, Normal, Medium, SemiBold, Bold, ExtraBold, Black
```

### Alignment

```php
use Filament\Support\Enums\Alignment;

TextColumn::make('price')
    ->alignment(Alignment::Center)

// Available: Start, Center, End, Justify, Left, Right
```

### MaxWidth

```php
use Filament\Support\Enums\MaxWidth;

Action::make('edit')
    ->modalWidth(MaxWidth::Medium)

// Available: ExtraSmall, Small, Medium, Large, ExtraLarge, TwoExtraLarge, ThreeExtraLarge, FourExtraLarge, FiveExtraLarge, SixExtraLarge, SevenExtraLarge, Screen, Full
```

## Related

- [../panels/panels.md](../panels/panels.md) - Panel colors and fonts