# Naming Conventions

> Variable names, method names, namespace patterns, and coding style.

## Variable Names

**Use full descriptive names. Never abbreviate.**

```php
// GOOD
$exception, $component, $response, $configuration, $record, $livewire

// BAD
$e, $comp, $res, $cfg, $rec, $lw
```

Exception: universally understood abbreviations like `$id`, `$url`.

## Method Names

### Property-Based Methods

| Type | Property Prefix | Setter | Getter |
|------|-----------------|--------|--------|
| Boolean | `is`, `should`, `can`, `has` | Verb form | Cast to `bool` |
| Value | None | Same name | `get` prefix |

#### Boolean Pattern

```php
// Property - `is`/`should`/`can`/`has` prefix, defaults `false`
protected bool | Closure $isDisabled = false;

// Setter - verb form, defaults `true`, pass `false` to undo
public function disabled(bool | Closure $condition = true): static
{
    $this->isDisabled = $condition;
    return $this;
}

// Getter - cast to `bool`
public function isDisabled(): bool
{
    return (bool) $this->evaluate($this->isDisabled);
}
```

#### Value Pattern

```php
// Property - nullable
protected string | Closure | null $icon = null;

// Setter - nullable to allow unsetting
public function icon(string | Closure | null $icon): static
{
    $this->icon = $icon;
    return $this;
}

// Getter - `get` prefix, uses `evaluate()` for Closure support
public function getIcon(): ?string
{
    return $this->evaluate($this->icon);
}
```

### Common Method Names

| Method | Purpose | Example |
|--------|---------|---------|
| `make()` | Static factory | `TextInput::make('name')` |
| `configure()` | Configure object | `ProductForm::configure($schema)` |
| `get*()` | Get property | `getLabel()`, `getIcon()` |
| `is*()` | Boolean check | `isDisabled()`, `isVisible()` |
| `should*()` | Boolean check | `shouldGrow()` |
| `can*()` | Permission check | `canDelete()` |
| `has*()` | Presence check | `hasIcon()`, `hasLabel()` |

## Namespace Conventions

### Package Namespaces

| Category | Namespace |
|----------|-----------|
| Form fields | `Filament\Forms\Components\` |
| Table columns | `Filament\Tables\Columns\` |
| Table filters | `Filament\Tables\Filters\` |
| Infolist entries | `Filament\Infolists\Components\` |
| Layout components | `Filament\Schemas\Components\` |
| Schema utilities | `Filament\Schemas\Components\Utilities\` |
| Actions | `Filament\Actions\` |
| Icons | `Filament\Support\Icons\` |
| Colors | `Filament\Support\Colors\` |

### Application Namespaces

| Component | Location |
|-----------|----------|
| Resources | `App\Filament\Resources\{Domain}\{Entity}\{Entity}Resource` |
| Form schemas | `App\Filament\Resources\{Domain}\{Entity}\Schemas\{Entity}Form` |
| Tables | `App\Filament\Resources\{Domain}\{Entity}\Tables\{Entity}Table` |
| Pages | `App\Filament\Resources\{Domain}\{Entity}\Pages\{PageName}` |
| Relation managers | `App\Filament\Resources\{Domain}\{Entity}\RelationManagers\{Relation}RelationManager` |
| Widgets | `App\Filament\Widgets\{WidgetName}` or `App\Filament\Resources\{Domain}\{Entity}\Widgets\{Entity}Stats` |
| Custom pages | `App\Filament\App\Pages\{PageName}` |
| Imports | `App\Filament\Imports\{Domain}\{Entity}Importer` |
| Exports | `App\Filament\Exports\{Domain}\{Entity}Exporter` |

## Trait Naming

Traits in `Concerns/` directories:

| Prefix | Purpose | Example |
|--------|---------|---------|
| `Can*` | Capabilities | `CanBeDisabled`, `CanBeHidden` |
| `Has*` | Properties | `HasLabel`, `HasIcon`, `HasName` |

```php
// Location: Filament\Forms\Components\Concerns\CanBeDisabled.php
trait CanBeDisabled { ... }

// Location: Filament\Forms\Components\Concerns\HasLabel.php  
trait HasLabel { ... }
```

## Interface Naming

Interfaces in `Contracts/` directories:

```php
// Location: Filament\Forms\Components\Contracts\HasLabel.php
interface HasLabel { ... }
```

## Test Naming

Pest tests use backticks for code references:

```php
// GOOD
it('can use `aspectRatio()` to force image cropping')
it('returns `null` for `getImageCropAspectRatio()` by default')
it('validates `$record` is an instance of `Model`')

// BAD - missing backticks
it('can use aspectRatio to force image cropping')
```

## Comment Style

Use backticks when referencing code in comments:

```php
// GOOD
// Uses `evaluate()` to resolve the `Closure`
// Returns `null` if the `$record` is not set

// BAD
// Uses evaluate() to resolve the Closure
```

## PHPDoc Conventions

Only add PHPDoc when providing type info beyond native PHP types:

```php
// GOOD - array shape
/** @var array<string, array{label: string, icon: string}> */

// BAD - redundant
/** @param string $name The name */
```

## Static Closures

Use `static fn` when closure doesn't use `$this`:

```php
// GOOD - no $this usage
->placeholder(static fn (Select $component): ?string => 
    $component->isDisabled() ? null : 'Select...'
)

// GOOD - uses $this, cannot be static
->visible(fn (): bool => $this->canView())

// BAD - unnecessary static when using $this
->visible(static fn (): bool => $this->canView()) // ERROR
```

## Deprecation Naming

Keep old methods, mark deprecated:

```php
/** @deprecated Use `newMethod()` instead. */
public function oldMethod(): void
{
    return $this->newMethod();
}
```

## CSS Hook Classes

Hook classes use abbreviations:

| Prefix | Package |
|--------|---------|
| `fi-fo-` | Forms |
| `fi-ta-` | Tables |
| `fi-ac-` | Actions |
| `fi-in-` | Infolists |
| `fi-sc-` | Schemas |
| `fi-pa-` | Panels |

Abbreviations: `btn` (button), `col` (column), `ctn` (container), `wrp` (wrapper).

```css
.fi-fo-field { @apply grid gap-y-2; }
.fi-ta-col-text { @apply text-sm; }
```

## Related

- [overview.md](overview.md) - Package hierarchy
- [directory-structure.md](directory-structure.md) - File locations
- [../reference/namespaces.md](../reference/namespaces.md) - Namespace quick reference