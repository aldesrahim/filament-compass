# Plugin Development - Overview

> Source: `source/filament/docs/11-plugins/`

## Two Plugin Types

| Type | Context | Examples |
|------|---------|---------|
| **Panel Plugin** | Inside a Panel Builder | Dashboard widgets, Blog/User resources |
| **Standalone Plugin** | Outside Panel Builder | Custom form fields, table columns/filters |

Both types can coexist in a single package.

## Prerequisites

- [Laravel Package Development](https://laravel.com/docs/packages)
- [Spatie Package Tools](https://github.com/spatie/laravel-package-tools)
- Filament Asset Management (`source/filament/docs/09-advanced/`)

## The Plugin Object

Panel plugins use a class implementing `Filament\Contracts\Plugin`. Three required methods:

| Method | Purpose |
|--------|---------|
| `getId()` | Unique plugin identifier — must not clash with other plugins |
| `register(Panel $panel)` | Register resources, pages, themes, render hooks |
| `boot(Panel $panel)` | Runs only when the panel is actually in use (via middleware) |

> Plugin object is **only for Panel plugins**. Standalone plugins configure everything in the service provider.

## Asset Registration

Register all assets (CSS, JS, Alpine components) in `packageBooted()` of the service provider via `FilamentAsset::register()`.

Exception: assets loaded on every page regardless of use should be registered via `$panel->assets()` inside the plugin's `register()` method — otherwise they load in every panel even if the plugin isn't registered there.

## Creating a Plugin (Skeleton)

Use the [Filament Plugin Skeleton](https://github.com/filamentphp/plugin-skeleton):

1. Click "Use this template" on GitHub
2. Clone the repo
3. Run the configure script:

```bash
php ./configure.php
```

## Upgrading Existing Plugins

Service provider must extend `PackageServiceProvider` (not deprecated `PluginServiceProvider`) and declare a `$name` property:

```php
use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

class MyPluginServiceProvider extends PackageServiceProvider
{
    public static string $name = 'my-plugin';

    public function configurePackage(Package $package): void
    {
        $package->name(static::$name);
    }
}
```

## Related

- [panel-plugins.md](panel-plugins.md) - Plugin class API, per-panel config, distributing panels
- [standalone-plugins.md](standalone-plugins.md) - Building a standalone form component
- [configurable-resources.md](configurable-resources.md) - Registering resources/pages multiple times
