# Panels - Panel Configuration

> Package: `filament/panels` | Admin panel setup and configuration.

## Panel Provider

All panels are configured in a PanelProvider class.

```php
use Filament\Panel;
use Filament\PanelProvider;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->id('admin')
            ->path('admin')
            ->discoverResources()
            ->discoverPages()
            ->discoverWidgets();
    }
}
```

## Panel Configuration Methods

### Basic Setup

| Method | Purpose | Example |
|--------|---------|---------|
| `id()` | Panel identifier | `'admin'` |
| `path()` | URL path | `'admin'` |
| `default()` | Default panel | `true` |
| `domain()` | Custom domain | `'admin.example.com'` |
| `middleware()` | Custom middleware | `['auth', 'verified']` |

### Authentication

| Method | Purpose | Example |
|--------|---------|---------|
| `authGuard()` | Custom auth guard | `'admin'` |
| `login()` | Login page | `Login::class` |
| `tenant()` | Multi-tenancy | See multi-tenancy docs |
| `avatarProvider()` | User avatars | `UiAvatarsProvider::class` |

### Navigation

| Method | Purpose | Example |
|--------|---------|---------|
| `sidebarCollapsible()` | Collapsible sidebar | `true` |
| `topNavigation()` | Top nav instead of sidebar | `true` |
| `navigationGroups()` | Custom group order | `['Shop', 'HR']` |
| `maxNavigationWidth()` | Sidebar width | `'250px'` |

### Discovery

| Method | Purpose | Example |
|--------|---------|---------|
| `discoverResources()` | Auto-discover resources | `true` |
| `discoverPages()` | Auto-discover pages | `true` |
| `discoverWidgets()` | Auto-discover widgets | `true` |
| `discoverClusters()` | Auto-discover clusters | `true` |

### Resources/Pages/Widgets

| Method | Purpose | Example |
|--------|---------|---------|
| `resources()` | Manual resource list | `[ProductResource::class]` |
| `pages()` | Manual page list | `[Settings::class]` |
| `widgets()` | Manual widget list | `[ProductStats::class]` |

### Branding

| Method | Purpose | Example |
|--------|---------|---------|
| `brandName()` | Panel name | `'Admin Panel'` |
| `brandLogo()` | Logo image | `asset('logo.svg')` |
| `brandLogoHeight()` | Logo height | `'40px'` |
| `favicon()` | Favicon | `asset('favicon.ico')` |
| `darkModeBrandLogo()` | Dark mode logo | `asset('logo-dark.svg')` |

### Theme & Colors

| Method | Purpose | Example |
|--------|---------|---------|
| `viteTheme()` | Vite-powered theme | `'resources/css/filament.css'` |
| `theme()` | Custom theme | `theme()` callback |
| `colors()` | Custom colors | `['primary' => Color::Amber]` |
| `darkMode()` | Enable dark mode | `true` or `false` |
| `font()` | Custom font | `'Inter'` |
| `fontProvider()` | Font provider | `GoogleFontProvider::class` |

### Global Search

| Method | Purpose | Example |
|--------|---------|---------|
| `globalSearch()` | Enable global search | `true` |
| `globalSearchDebounce()` | Search debounce | `500` (ms) |
| `globalSearchFields()` | Fields to search | `['title', 'content']` |

### Database Transactions

| Method | Purpose | Example |
|--------|---------|---------|
| `databaseTransactions()` | Wrap ops in transaction | `true` |
| `databaseTransactionsFor()` | Specific operations | `['creating', 'updating']` |

### Plugins

| Method | Purpose | Example |
|--------|---------|---------|
| `plugin()` | Add plugin | `SpatieMediaLibraryPlugin::make()` |
| `plugins()` | Add multiple plugins | `[...]` |

### SPA Mode

| Method | Purpose | Example |
|--------|---------|---------|
| `spa()` | SPA mode | `true` |
| `spaUrlExceptions()` | SPA exceptions | `['/admin/logout']` |

### Render Hooks

| Method | Purpose | Example |
|--------|---------|---------|
| `renderHook()` | Add render hooks | `RenderHook::HEADER_START, fn() => ...` |

## Colors

Use Filament's color palette or custom colors:

```php
use Filament\Support\Colors\Color;

$panel->colors([
    'primary' => Color::Amber,
    'secondary' => Color::Gray,
    'warning' => Color::Orange,
    'danger' => Color::Red,
    'success' => Color::Green,
    'info' => Color::Blue,
])
```

### Custom Color

```php
use Filament\Support\Colors\Color;

$panel->colors([
    'primary' => Color::hex('#ff0000'),
    'brand' => Color::Rgb(255, 0, 0),
])
```

## Fonts

```php
use Filament\Panel;
use Filament\Support\Facades\FilamentFont;

$panel->font('Inter');

// Or with provider
$panel
    ->font('Inter')
    ->fontProvider(GoogleFontProvider::class);
```

## Complete Example

```php
<?php

namespace App\Providers\Filament;

use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Filament\Support\Icons\Heroicon;
use Filament\Widgets\AccountWidget;
use Filament\Widgets\FilamentInfoWidget;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->id('admin')
            ->path('admin')
            ->default()
            ->login()
            ->colors([
                'primary' => Color::Amber,
            ])
            ->brandName('Shop Admin')
            ->brandLogo(asset('logo.svg'))
            ->brandLogoHeight('40px')
            ->discoverResources()
            ->discoverPages()
            ->discoverWidgets()
            ->sidebarCollapsible()
            ->darkMode()
            ->globalSearch()
            ->viteTheme('resources/css/filament/admin/theme.css')
            ->databaseTransactions()
            ->plugins([
                SpatieMediaLibraryPlugin::make(),
            ])
            ->widgets([
                AccountWidget::class,
                FilamentInfoWidget::class,
            ]);
    }
}
```

## Related

- [resources.md](resources.md) - Resource structure
- [pages.md](pages.md) - Page types
- [widgets.md](widgets.md) - Dashboard widgets