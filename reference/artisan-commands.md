# Artisan Commands

> Filament Artisan commands reference.

## Installation & Setup Commands

```bash
# Install Filament with panels
php artisan filament:install --panels

# Install Filament for use outside panels (Blade/Livewire)
php artisan filament:install --scaffold

# With notifications in scaffold
php artisan filament:install --scaffold --notifications

# Force overwrite existing files
php artisan filament:install --panels --force
```

## Panel Commands

```bash
# Create panel
php artisan make:filament-panel admin

# Force overwrite
php artisan make:filament-panel admin --force
```

## Resource Commands

```bash
# Create resource
php artisan make:filament-resource Product

# With auto-generation from model
php artisan make:filament-resource Product --generate

# Simple (modal) resource with embedded schemas/table
php artisan make:filament-resource Product --simple

# With soft deletes
php artisan make:filament-resource Product --soft-deletes

# With View page/modal
php artisan make:filament-resource Product --view

# Generate model, migration, factory
php artisan make:filament-resource Product --model --migration --factory

# Custom model namespace
php artisan make:filament-resource Product --model-namespace="Custom\\Models"

# Embed schemas and table in resource class
php artisan make:filament-resource Product --embed-schemas --embed-table

# Create separate files even for simple resources
php artisan make:filament-resource Product --simple --not-embedded

# Nested resource
php artisan make:filament-resource Comment --nested=PostResource

# Custom record title attribute
php artisan make:filament-resource Product --record-title-attribute=name

# In a specific cluster
php artisan make:filament-resource Product --cluster=Settings

# In a specific panel
php artisan make:filament-resource Product --panel=admin

# All options combined
php artisan make:filament-resource Product --generate --view --soft-deletes --model --migration --factory
```

## Relation Manager Commands

```bash
# Create relation manager
php artisan make:filament-relation-manager ProductResource items

# With record title attribute
php artisan make:filament-relation-manager ProductResource items name

# Auto-generate from database
php artisan make:filament-relation-manager ProductResource items --generate

# Include associate actions (HasMany/MorphMany)
php artisan make:filament-relation-manager PostResource comments --associate

# Include attach actions (BelongsToMany/MorphToMany)
php artisan make:filament-relation-manager ProductResource tags --attach

# With soft deletes
php artisan make:filament-relation-manager ProductResource items --soft-deletes

# With view modal
php artisan make:filament-relation-manager ProductResource items --view

# Use specific schema/table classes
php artisan make:filament-relation-manager ProductResource items --form-schema=App\\Forms\\ProductForm --table=App\\Tables\\ProductTable

# Specify related model/resource
php artisan make:filament-relation-manager ProductResource items --related-model=App\\Models\\Item --related-resource=App\\Filament\\Resources\\ItemResource
```

## Page Commands

```bash
# Create custom page
php artisan make:filament-page Settings

# Create page in cluster
php artisan make:filament-page Settings --cluster=Settings

# Create resource page
php artisan make:filament-page ViewProduct --resource=ProductResource --type=ViewRecord

# Create custom page in a specific panel
php artisan make:filament-page Dashboard --panel=admin
```

## Settings Page Commands

```bash
# Create settings page
php artisan make:filament-settings-page GeneralSettings

# With settings class
php artisan make:filament-settings-page GeneralSettings GeneralSettings

# Auto-generate form from settings properties
php artisan make:filament-settings-page GeneralSettings GeneralSettings --generate

# In a cluster
php artisan make:filament-settings-page GeneralSettings --cluster=Settings
```

## Widget Commands

```bash
# Create widget
php artisan make:filament-widget SalesChart

# Chart widget
php artisan make:filament-widget SalesChart --chart

# Stats overview widget
php artisan make:filament-widget ProductStats --stats-overview

# Table widget
php artisan make:filament-widget RecentOrders --table

# Widget for a resource
php artisan make:filament-widget ProductStats --resource=ProductResource

# Widget in a cluster
php artisan make:filament-widget ProductStats --cluster=Dashboard
```

## Cluster Commands

```bash
# Create cluster
php artisan make:filament-cluster Settings

# Create cluster in specific panel
php artisan make:filament-cluster Settings --panel=admin
```

## Form & Schema Commands

```bash
# Create form schema class
php artisan make:filament-form ProductForm

# With model auto-generation
php artisan make:filament-form ProductForm Product --generate

# Custom model namespace
php artisan make:filament-form ProductForm Product --model-namespace="App\\Models\\Shop"

# Create custom form field
php artisan make:filament-form-field ColorPicker

# Create schema class (infolist)
php artisan make:filament-schema ProductSchema

# Create custom schema component/layout
php artisan make:filament-schema-component SidebarLayout
```

## Table Commands

```bash
# Create table class
php artisan make:filament-table ProductTable

# With model auto-generation
php artisan make:filament-table ProductTable Product --generate

# Custom model namespace
php artisan make:filament-table ProductTable Product --model-namespace="App\\Models\\Shop"

# Create custom table column
php artisan make:filament-table-column StatusColumn

# With embedded view (no separate Blade file)
php artisan make:filament-table-column StatusColumn --embedded-view
```

## Infolist Commands

```bash
# Create infolist entry
php artisan make:filament-infolist-entry IconEntry
```

## Livewire Component Commands

```bash
# Create Livewire component with form
php artisan make:filament-livewire-form ContactForm

# With model auto-generation
php artisan make:filament-livewire-form ContactForm Contact --generate

# For editing instead of creating
php artisan make:filament-livewire-form EditProfile User --edit --generate

# Create Livewire component with schema (infolist)
php artisan make:filament-livewire-schema ProductDetails

# Create Livewire component with table
php artisan make:filament-livewire-table ProductsTable

# With model auto-generation
php artisan make:filament-livewire-table ProductsTable Product --generate
```

## Rich Content Editor Commands

```bash
# Create rich editor custom block
php artisan make:filament-rich-content-custom-block CallToAction

# Alternative aliases
php artisan make:filament-custom-block CallToAction
php artisan forms:make-custom-block CallToAction
```

## Import/Export Commands

```bash
# Create importer
php artisan make:filament-importer Product

# With auto-generation from model
php artisan make:filament-importer Product --generate

# Create exporter
php artisan make:filament-exporter Product

# With auto-generation from model
php artisan make:filament-exporter Product --generate
```

## User Management Commands

```bash
# Create Filament user (interactive)
php artisan make:filament-user

# Create user with all details
php artisan make:filament-user --name="John Doe" --email="john@example.com" --password="secret123"

# Create user for specific panel
php artisan make:filament-user --panel=admin
```

## Theme Commands

```bash
# Create panel theme
php artisan make:filament-theme admin

# Specify package manager
php artisan make:filament-theme admin --pm=yarn

# Force overwrite
php artisan make:filament-theme admin --force
```

## Utility Commands

```bash
# Display information about installed Filament packages
php artisan filament:about

# Set up/publish Filament assets
php artisan filament:assets

# Cache all components for performance
php artisan filament:cache-components

# Clear cached components
php artisan filament:clear-cached-components

# Cache components and Blade icons (optimization)
php artisan filament:optimize

# Clear cached components and Blade icons
php artisan filament:optimize-clear

# Check for missing translations
php artisan filament:check-translations

# Check specific locales
php artisan filament:check-translations en es fr

# Check app translations instead of vendor
php artisan filament:check-translations --source=app

# Generate issue link with pre-filled versions
php artisan make:filament-issue

# Upgrade Filament to latest version
php artisan filament:upgrade
```

## Related

- [namespaces.md](namespaces.md) - Namespace reference
- [../packages/panels/resources.md](../packages/panels/resources.md) - Resources