# Plugin Development - Standalone Plugins

> Source: `source/filament/docs/11-plugins/03-building-a-panel-plugin.md`, `04-building-a-standalone-plugin.md`

Standalone plugins add components (form fields, table columns, etc.) usable outside a panel. No Plugin class needed — all setup in the service provider.

---

## Walkthrough: Panel Widget Plugin

Reference implementation: [awcodes/clock-widget](https://github.com/awcodes/clock-widget)

### Step 1: Clean up skeleton

Remove unneeded boilerplate:

```
config/
database/
src/Commands/
src/Facades/
stubs/
ClockWidgetPlugin.php   ← no config needed for simple widget
resources/css/          ← use theme instead
postcss.config.js
```

Minimal `package.json`:

```json
{
    "private": true,
    "type": "module",
    "scripts": {
        "dev": "node bin/build.js --dev",
        "build": "node bin/build.js"
    },
    "devDependencies": {
        "esbuild": "^0.17.19"
    }
}
```

```bash
npm install
```

### Step 2: Service provider

Register Livewire component and Alpine asset in `packageBooted()`:

```php
use Filament\Support\Assets\AlpineComponent;
use Filament\Support\Facades\FilamentAsset;
use Livewire\Livewire;
use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

class ClockWidgetServiceProvider extends PackageServiceProvider
{
    public static string $name = 'clock-widget';

    public function configurePackage(Package $package): void
    {
        $package->name(static::$name)
            ->hasViews()
            ->hasTranslations();
    }

    public function packageBooted(): void
    {
        Livewire::component('clock-widget', ClockWidget::class);

        FilamentAsset::register(
            assets: [
                AlpineComponent::make('clock-widget', __DIR__ . '/../resources/dist/clock-widget.js'),
            ],
            package: 'awcodes/clock-widget'
        );
    }
}
```

> Async Alpine components are loaded on demand — safe to register in `packageBooted()`. Static CSS/JS that load on every page must use `$panel->assets()` inside the Plugin class `register()` method instead.

### Step 3: Widget class

```php
use Filament\Widgets\Widget;

class ClockWidget extends Widget
{
    protected static string $view = 'clock-widget::widget';
}
```

### Step 4: Blade view

```blade
<x-filament-widgets::widget>
    <x-filament::section>
        <x-slot name="heading">
            {{ __('clock-widget::clock-widget.title') }}
        </x-slot>

        <div
            x-load
            x-load-src="{{ \Filament\Support\Facades\FilamentAsset::getAlpineComponentSrc('clock-widget', 'awcodes/clock-widget') }}"
            x-data="clockWidget()"
            class="text-center"
        >
            <p>{{ __('clock-widget::clock-widget.description') }}</p>
            <p class="text-xl" x-text="time"></p>
        </div>
    </x-filament::section>
</x-filament-widgets::widget>
```

### Step 5: Alpine component (`src/js/index.js`)

```js
export default function clockWidget() {
    return {
        time: new Date().toLocaleTimeString(),
        init() {
            setInterval(() => {
                this.time = new Date().toLocaleTimeString();
            }, 1000);
        }
    }
}
```

Build:

```bash
npm run build
```

### Step 6: Translations (`resources/lang/en/widget.php`)

```php
return [
    'title' => 'Clock Widget',
    'description' => 'Your current time is:',
];
```

User installs the widget:

```php
use Awcodes\ClockWidget\ClockWidget;

public function panel(Panel $panel): Panel
{
    return $panel->widgets([ClockWidget::class]);
}
```

---

## Walkthrough: Standalone Form Component

Reference implementation: [awcodes/headings](https://github.com/awcodes/headings)

### Step 1: Clean up skeleton

Remove:

```
bin/
config/
database/
src/Commands/
src/Facades/
stubs/
```

`package.json` with PostCSS for on-demand CSS:

```json
{
    "private": true,
    "scripts": {
        "build": "postcss resources/css/index.css -o resources/dist/headings.css"
    },
    "devDependencies": {
        "cssnano": "^6.0.1",
        "postcss": "^8.4.27",
        "postcss-cli": "^10.1.0",
        "postcss-nesting": "^13.0.0"
    }
}
```

`postcss.config.js`:

```js
module.exports = {
    plugins: [
        require('postcss-nesting')(),
        require('cssnano')({ preset: 'default' }),
    ],
};
```

### Step 2: Service provider

Register CSS with `loadedOnRequest()` so it only loads when the component is used:

```php
use Filament\Support\Assets\Css;
use Filament\Support\Facades\FilamentAsset;
use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

class HeadingsServiceProvider extends PackageServiceProvider
{
    public static string $name = 'headings';

    public function configurePackage(Package $package): void
    {
        $package->name(static::$name)->hasViews();
    }

    public function packageBooted(): void
    {
        FilamentAsset::register([
            Css::make('headings', __DIR__ . '/../resources/dist/headings.css')->loadedOnRequest(),
        ], 'awcodes/headings');
    }
}
```

### Step 3: Component class (`src/Heading.php`)

Extend `Filament\Schemas\Components\Component`. Use `app()` in `make()` for container resolution:

```php
use Closure;
use Filament\Schemas\Components\Component;
use Filament\Support\Colors\Color;
use Filament\Support\Concerns\HasColor;

class Heading extends Component
{
    use HasColor;

    protected string | int $level = 2;
    protected string | Closure $content = '';
    protected string $view = 'headings::heading';

    final public function __construct(string | int $level)
    {
        $this->level($level);
    }

    public static function make(string | int $level): static
    {
        return app(static::class, ['level' => $level]);
    }

    public function content(string | Closure $content): static
    {
        $this->content = $content;

        return $this;
    }

    public function level(string | int $level): static
    {
        $this->level = $level;

        return $this;
    }

    public function getColor(): array
    {
        return $this->evaluate($this->color) ?? Color::Amber;
    }

    public function getContent(): string
    {
        return $this->evaluate($this->content);
    }

    public function getLevel(): string
    {
        return is_int($this->level) ? 'h' . $this->level : $this->level;
    }
}
```

### Step 4: Blade view (`resources/views/heading.blade.php`)

Use `x-load-css` to asynchronously pull in the stylesheet:

```blade
@php
    $level = $getLevel();
    $color = $getColor();
@endphp

<{{ $level }}
    x-data
    x-load-css="[@js(\Filament\Support\Facades\FilamentAsset::getStyleHref('headings', package: 'awcodes/headings'))]"
    {{
        $attributes
            ->class([
                'headings-component',
                match ($color) {
                    'gray' => 'text-gray-600 dark:text-gray-400',
                    default => 'text-custom-500',
                },
            ])
            ->style([
                \Filament\Support\get_color_css_variables($color, [500]) => $color !== 'gray',
            ])
    }}
>
    {{ $getContent() }}
</{{ $level }}>
```

### Step 5: CSS (`resources/css/index.css`)

```css
.headings-component {
    &:is(h1, h2, h3, h4, h5, h6) {
        font-weight: 700;
        letter-spacing: -.025em;
        line-height: 1.1;
    }
    &h1 { font-size: 2rem; }
    &h2 { font-size: 1.75rem; }
    &h3 { font-size: 1.5rem; }
    &h4 { font-size: 1.25rem; }
    &h5, &h6 { font-size: 1rem; }
}
```

```bash
npm run build
```

User usage:

```php
use Awcodes\Headings\Heading;

Heading::make(2)
    ->content('Product Information')
    ->color(Color::Lime)
```

## Related

- [overview.md](overview.md) - Plugin types, prerequisites
- [panel-plugins.md](panel-plugins.md) - Plugin class, per-panel config
