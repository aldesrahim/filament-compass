# Artisan Commands

> Filament Artisan commands reference.

## Resource Commands

```bash
# Create resource
php artisan make:filament-resource Product

# With auto-generation from model
php artisan make:filament-resource Product --generate

# With separated concerns (Schemas/Tables/Pages)
php artisan make:filament-resource Product --separate

# Simple (modal) resource
php artisan make:filament-resource Product --simple

# With soft deletes
php artisan make:filament-resource Product --soft-deletes

# With View page
php artisan make:filament-resource Product --view

# Generate model, migration, factory
php artisan make:filament-resource Product --model --migration --factory

# Custom model namespace
php artisan make:filament-resource Product --model-namespace="Custom\\Models"

# All options combined
php artisan make:filament-resource Product --generate --separate --view --soft-deletes --model --migration --factory
```

## Relation Manager Commands

```bash
# Create relation manager
php artisan make:filament-relation-manager ProductResource items

# With record title attribute
php artisan make:filament-relation-manager ProductResource items name
```

## Page Commands

```bash
# Create custom page
php artisan make:filament-page Settings

# Create page in cluster
php artisan make:filament-page Settings --cluster=Settings
```

## Widget Commands

```bash
# Create widget
php artisan make:filament-widget SalesChart

# Chart widget
php artisan make:filament-widget SalesChart --chart

# Stats overview widget
php artisan make:filament-widget ProductStats --stats-overview
```

## Import/Export Commands

```bash
# Create importer
php artisan make:filament-importer Product

# Create exporter
php artisan make:filament-exporter Product
```

## Plugin Commands

```bash
# Install Filament
php artisan filament:install --panels

# Install Shield (permissions)
php artisan shield:install --fresh

# Generate permissions
php artisan shield:generate --all
```

## Other Commands

```bash
# Clear cached components
php artisan filament:clear-cached-components

# List resources
php artisan filament:list-resources

# List pages
php artisan filament:list-pages

# List widgets
php artisan filament:list-widgets

# Upgrade
php artisan filament:upgrade
```

## Panel Commands

```bash
# Create panel
php artisan make:filament-panel admin

# List panels
php artisan filament:list-panels
```

## Cluster Commands

```bash
# Create cluster
php artisan make:filament-cluster Settings
```

## Related

- [namespaces.md](namespaces.md) - Namespace reference
- [../packages/panels/resources.md](../packages/panels/resources.md) - Resources