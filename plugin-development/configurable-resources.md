# Plugin Development - Configurable Resources and Pages

> Source: `source/filament/docs/11-plugins/05-configurable-resources-and-pages.md`

Register a single resource/page class multiple times with different configurations — each gets its own routes, navigation, and URL slug.

> Works in any `PanelProvider`, not only plugins. Especially useful for plugins that expose flexible options to users.

---

## Resource Configuration Class

Extend `ResourceConfiguration`. Setter methods return `$this` for chaining:

```php
use Filament\Resources\ResourceConfiguration;

class OrderResourceConfiguration extends ResourceConfiguration
{
    protected bool $isArchived = false;
    protected ?string $navigationLabel = null;
    protected ?string $navigationGroup = null;

    public function archived(bool $condition = true): static
    {
        $this->isArchived = $condition;

        return $this;
    }

    public function isArchived(): bool
    {
        return $this->isArchived;
    }

    public function navigationLabel(string $label): static
    {
        $this->navigationLabel = $label;

        return $this;
    }

    public function getNavigationLabel(): ?string
    {
        return $this->navigationLabel;
    }

    public function navigationGroup(string $group): static
    {
        $this->navigationGroup = $group;

        return $this;
    }

    public function getNavigationGroup(): ?string
    {
        return $this->navigationGroup;
    }
}
```

> `ResourceConfiguration` base class already includes a `slug()` method. Only add properties specific to your plugin.

## Link Config Class to Resource

Set `$configurationClass` on the resource. This enables `Resource::make()`:

```php
use Filament\Resources\Resource;

class OrderResource extends Resource
{
    protected static ?string $configurationClass = OrderResourceConfiguration::class;

    // ...
}
```

## Register Configurations on a Panel

Each configuration needs a unique key:

```php
use App\Filament\Resources\OrderResource;

public function panel(Panel $panel): Panel
{
    return $panel
        ->resources([
            OrderResource::make('active')
                ->navigationLabel('Active Orders')
                ->navigationGroup('Orders'),
            OrderResource::make('archived')
                ->navigationLabel('Archived Orders')
                ->navigationGroup('Orders')
                ->archived(),
        ]);
}
```

Optionally register the plain class alongside configurations for a default unconfigured registration:

```php
$panel->resources([
    OrderResource::class,           // default: /orders
    OrderResource::make('active'),  // /orders/active
    OrderResource::make('archived') // /orders/archived
        ->archived(),
]);
```

### URL Slugs

| Registration | Default URL |
|-------------|------------|
| `OrderResource::class` | `/orders` |
| `OrderResource::make('active')` | `/orders/active` |
| `OrderResource::make('archived')` | `/orders/archived` |

Override with `slug()`:

```php
OrderResource::make('archived')
    ->slug('order-archive')  // → /order-archive
    ->archived(),
```

## Using Configuration at Runtime

Call `static::getConfiguration()` inside the resource. Returns `null` for unconfigured registration:

```php
use Filament\Resources\Resource;
use Illuminate\Database\Eloquent\Builder;
use UnitEnum;

class OrderResource extends Resource
{
    protected static ?string $configurationClass = OrderResourceConfiguration::class;

    public static function getEloquentQuery(): Builder
    {
        $query = parent::getEloquentQuery();

        if ($configuration = static::getConfiguration()) {
            if ($configuration->isArchived()) {
                $query->where('archived_at', '!=', null);
            }
        }

        return $query;
    }

    public static function getNavigationLabel(): string
    {
        if ($configuration = static::getConfiguration()) {
            if ($label = $configuration->getNavigationLabel()) {
                return $label;
            }
        }

        return parent::getNavigationLabel();
    }

    public static function getNavigationGroup(): string | UnitEnum | null
    {
        if ($configuration = static::getConfiguration()) {
            if ($group = $configuration->getNavigationGroup()) {
                return $group;
            }
        }

        return parent::getNavigationGroup();
    }
}
```

Shorthand existence check:

```php
if (static::hasConfiguration()) {
    // inside a configured registration
}
```

## Generating URLs for a Specific Configuration

```php
OrderResource::getUrl();                                              // default
OrderResource::getUrl(configuration: 'active');                       // active config
OrderResource::getUrl('edit', ['record' => $order], configuration: 'archived'); // archived config
```

Inside a configured request, `getUrl()` uses current context automatically.

## Temporarily Switching Configuration Context

```php
$archivedUrl = OrderResource::withConfiguration('archived', function () {
    return OrderResource::getUrl('index');
});
```

## Configurable Pages

Same pattern, different base class:

```php
use Filament\Pages\PageConfiguration;

class SettingsPageConfiguration extends PageConfiguration
{
    protected ?string $settingsCategory = null;

    public function settingsCategory(string $category): static
    {
        $this->settingsCategory = $category;

        return $this;
    }

    public function getSettingsCategory(): ?string
    {
        return $this->settingsCategory;
    }
}
```

```php
use Filament\Pages\Page;

class SettingsPage extends Page
{
    protected static ?string $configurationClass = SettingsPageConfiguration::class;

    public function mount(): void
    {
        if ($configuration = static::getConfiguration()) {
            $this->settingsCategory = $configuration->getSettingsCategory();
        }
    }
}
```

Register via `$panel->pages()`:

```php
$panel->pages([
    SettingsPage::make('general')
        ->slug('general-settings')
        ->settingsCategory('general'),
    SettingsPage::make('advanced')
        ->slug('advanced-settings')
        ->settingsCategory('advanced'),
]);
```

## Using in a Plugin Class

```php
use Filament\Contracts\Plugin;
use Filament\Panel;

class TasksPlugin implements Plugin
{
    /** @var array<TaskResourceConfiguration> */
    protected array $taskResourceConfigurations = [];

    public static function make(): static
    {
        return app(static::class);
    }

    public function getId(): string
    {
        return 'tasks';
    }

    /**
     * @param  array<TaskResourceConfiguration>  $configurations
     */
    public function taskResources(array $configurations): static
    {
        $this->taskResourceConfigurations = $configurations;

        return $this;
    }

    public function register(Panel $panel): void
    {
        $panel->resources([
            TaskResource::class,
            ...$this->taskResourceConfigurations,
        ]);
    }

    public function boot(Panel $panel): void
    {
        //
    }
}
```

User registers multiple configurations via plugin:

```php
use Vendor\TasksPlugin\TasksPlugin;
use Vendor\TasksPlugin\TaskResource;

public function panel(Panel $panel): Panel
{
    return $panel
        ->plugin(
            TasksPlugin::make()
                ->taskResources([
                    TaskResource::make('my-tasks')->ownedByCurrentUser(),
                    TaskResource::make('team-tasks')->ownedByCurrentTeam(),
                ])
        );
}
```

## Related

- [panel-plugins.md](panel-plugins.md) - Plugin class, per-panel config
- [overview.md](overview.md) - Plugin types, prerequisites
