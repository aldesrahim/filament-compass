# Plugin Development - Panel Plugins

> Source: `source/filament/docs/11-plugins/02-panel-plugins.md`

## Plugin Class

Implement `Filament\Contracts\Plugin`:

```php
<?php

namespace DanHarrin\FilamentBlog;

use DanHarrin\FilamentBlog\Pages\Settings;
use DanHarrin\FilamentBlog\Resources\CategoryResource;
use DanHarrin\FilamentBlog\Resources\PostResource;
use Filament\Contracts\Plugin;
use Filament\Panel;

class BlogPlugin implements Plugin
{
    public function getId(): string
    {
        return 'blog';
    }

    public function register(Panel $panel): void
    {
        $panel
            ->resources([
                PostResource::class,
                CategoryResource::class,
            ])
            ->pages([
                Settings::class,
            ]);
    }

    public function boot(Panel $panel): void
    {
        //
    }
}
```

User registers via `plugin()` on the panel:

```php
use DanHarrin\FilamentBlog\BlogPlugin;

public function panel(Panel $panel): Panel
{
    return $panel
        // ...
        ->plugin(new BlogPlugin());
}
```

## Fluent Instantiation

Add a `make()` method so users can chain configuration. Use `app()` so the class can be swapped at runtime:

```php
use Filament\Contracts\Plugin;

class BlogPlugin implements Plugin
{
    public static function make(): static
    {
        return app(static::class);
    }

    // ...
}
```

Usage:

```php
->plugin(BlogPlugin::make())
```

## Per-Panel Configuration

Add setter + getter pairs. Setter stores value and returns `$this` for chaining:

```php
use DanHarrin\FilamentBlog\Resources\AuthorResource;
use Filament\Contracts\Plugin;
use Filament\Panel;

class BlogPlugin implements Plugin
{
    protected bool $hasAuthorResource = false;

    public function authorResource(bool $condition = true): static
    {
        $this->hasAuthorResource = $condition;

        return $this;
    }

    public function hasAuthorResource(): bool
    {
        return $this->hasAuthorResource;
    }

    public function register(Panel $panel): void
    {
        if ($this->hasAuthorResource()) {
            $panel->resources([
                AuthorResource::class,
            ]);
        }
    }

    // ...
}
```

User usage:

```php
BlogPlugin::make()->authorResource()
```

### Accessing Config Outside the Plugin

```php
// By plugin ID
filament('blog')->hasAuthorResource()
```

### Static `get()` for Type Safety

```php
class BlogPlugin implements Plugin
{
    public static function get(): static
    {
        return filament(app(static::class)->getId());
    }

    // ...
}
```

```php
BlogPlugin::get()->hasAuthorResource()
```

## Distributing an Entire Panel

Extend `PanelProvider` directly in your package:

```php
<?php

namespace DanHarrin\FilamentBlog;

use Filament\Panel;
use Filament\PanelProvider;

class BlogPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->id('blog')
            ->path('blog')
            ->resources([/* ... */])
            ->pages([/* ... */])
            ->widgets([/* ... */])
            ->middleware([/* ... */])
            ->authMiddleware([/* ... */]);
    }
}
```

Register in `composer.json`:

```json
"extra": {
    "laravel": {
        "providers": [
            "DanHarrin\\FilamentBlog\\BlogPanelProvider"
        ]
    }
}
```

## Related

- [overview.md](overview.md) - Plugin types, skeleton, prerequisites
- [configurable-resources.md](configurable-resources.md) - Multi-registration resources/pages
