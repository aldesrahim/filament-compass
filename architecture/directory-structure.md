# Directory Structure

> Where files go in Filament packages and applications.

## Filament Package Structure

### Core Packages (`filament/packages/`)

```
packages/
├── support/           # Base utilities
│   └── src/
│       ├── Icons/     # Heroicon enum
│       ├── Colors/    # Color palette
│       ├── Concerns/  # Shared traits
│       ├── Contracts/ # Shared interfaces
│       ├── helpers.php
│       └── View/      # Base view components
│
├── schemas/           # Layout components
│   └── src/
│       ├── Components/
│       │   ├── Grid.php
│       │   ├── Section.php
│       │   ├── Tabs.php
│       │   ├── Wizard.php
│       │   ├── Fieldset.php
│       │   ├── Group.php
│       │   └── Utilities/  # Get, Set
│       └── Schema.php
│
├── forms/             # Form fields
│   └── src/
│       ├── Components/
│       │   ├── TextInput.php
│       │   ├── Select.php
│       │   ├── FileUpload.php
│       │   ├── Repeater/
│       │   ├── RichEditor/
│       │   └── ... (all fields)
│       ├── Concerns/
│       └── docs/      # Package-specific docs
│
├── tables/            # Table columns, filters
│   └── src/
│       ├── Columns/
│       │   ├── TextColumn.php
│       │   ├── IconColumn.php
│       │   └── ...
│       ├── Filters/
│       ├── Actions/
│       ├── Summarizers/
│       ├── Table.php
│       └── docs/
│
├── infolists/         # Read-only display
│   └── src/
│       ├── Components/
│       │   ├── TextEntry.php
│       │   ├── ImageEntry.php
│       │   └── ...
│       └── docs/
│
├── actions/           # Actions (buttons + modals)
│   └── src/
│       ├── Action.php
│       ├── ActionGroup.php
│       ├── CreateAction.php
│       ├── EditAction.php
│       ├── DeleteAction.php
│       ├── ImportAction.php
│       ├── ExportAction.php
│       └── ...
│
├── notifications/     # Notifications
│   └── src/
│       ├── Notification.php
│       └── Livewire/
│
├── widgets/           # Dashboard widgets
│   └── src/
│       ├── ChartWidget.php
│       ├── StatsOverviewWidget/
│       ├── TableWidget.php
│       └── Widget.php
│
├── panels/            # Admin panel framework
│   └── src/
│       ├── Resources/
│       │   ├── Resource.php
│       │   ├── RelationManagers/
│       │   └── Pages/
│       ├── Pages/
│       │   ├── ListRecords.php
│       │   ├── CreateRecord.php
│       │   ├── EditRecord.php
│       │   ├── ViewRecord.php
│       │   └── Dashboard.php
│       ├── Panel.php
│       ├── PanelProvider.php
│       ├── Navigation/
│       ├── Auth/
│       └── Widgets/
│
├── query-builder/     # Query builder for filters
│   └── src/
│       ├── Constraints/
│       └── Forms/
│
├── upgrade/           # Upgrade helpers
│   └── src/
│       ├── Rector/
│       └── Commands/
│
└── [plugins]/         # Spatie plugins
    ├── spatie-laravel-media-library-plugin/
    ├── spatie-laravel-tags-plugin/
    ├── spatie-laravel-settings-plugin/
    ├── spatie-laravel-google-fonts-plugin/
    └── spark-billing-provider/
```

### Package Resources

Each package has:

```
packages/{package}/
├── src/              # PHP classes
├── resources/
│   ├── views/        # Blade templates
│   ├── css/          # Tailwind CSS hooks
│   └── lang/         # Translations
├── docs/             # Package-specific docs
├── stubs/            # File stubs for generators
├── .stubs.php        # Stub configuration
└── composer.json
```

## Application Structure

### Standard Resource (non-separated)

```
app/Filament/Resources/
└── ProductResource.php   # Everything in one file
```

### Separated Concerns Resource

```
app/Filament/Resources/{Domain}/{Entity}/
├── {Entity}Resource.php          # Resource definition
├── Schemas/
│   ├── {Entity}Form.php          # Form schema (create/edit)
│   ├── {Entity}Infolist.php      # Infolist schema (view page)
│   └── {Entity}Filters.php       # Table filters (optional)
├── Tables/
│   └── {Entity}Table.php         # Table columns, actions
├── Pages/
│   ├── List{Entities}.php        # List page
│   ├── Create{Entity}.php        # Create page
│   ├── Edit{Entity}.php          # Edit page
│   └── View{Entity}.php          # View page (optional)
├── RelationManagers/
│   ├── {Relation}RelationManager.php  # e.g., CommentsRelationManager
│   └── ...
└── Widgets/
    └── {Entity}Stats.php         # Resource-specific widgets
```

### Example: Product Resource with Separated Concerns

```
app/Filament/Resources/Shop/Products/
├── ProductResource.php
├── Schemas/
│   └── ProductForm.php
├── Tables/
│   └── ProductsTable.php
├── Pages/
│   ├── ListProducts.php
│   ├── CreateProduct.php
│   └── EditProduct.php
├── RelationManagers/
│   └── CommentsRelationManager.php
└── Widgets/
    └── ProductStats.php
```

### Widgets

```
app/Filament/Widgets/
├── WorkforceInsightsStats.php    # Stats overview
├── CustomerSegmentsChart.php     # Chart widget
├── BudgetBurnRateChart.php       # Chart widget
└── FlaggedOrders.php             # Table widget
```

Or resource-specific:

```
app/Filament/Resources/{Domain}/{Entity}/Widgets/
└── {Entity}Stats.php
```

### Custom Pages

```
app/Filament/App/Pages/
├── Settings.php                  # Settings page
├── RegisterTeam.php              # Custom registration
└── Dashboard.php                 # Custom dashboard
```

### Imports/Exports

```
app/Filament/Imports/
├── Shop/
│   └── CategoryImporter.php
└── Blog/
    └── CategoryImporter.php

app/Filament/Exports/
├── Shop/
│   └── BrandExporter.php
└── Blog/
    └── AuthorExporter.php
```

### Panel Provider

```
app/Providers/Filament/
└── AdminPanelProvider.php        # Panel configuration
```

## Views Location

### Package Views

```
packages/{package}/resources/views/
├── components/
│   └── {component-name}.blade.php
└── ...
```

### Application Override Views

```
resources/views/filament/{package}/
├── components/
│   └── {component-name}.blade.php
└── ...
```

## CSS Location

```
packages/{package}/resources/css/
└── {package}.css              # Tailwind @apply hooks
```

Never use Tailwind classes directly in Blade. Always use `@apply` in CSS.

## Translations Location

```
packages/{package}/resources/lang/{locale}/
└── {package}.php

# Application override
resources/lang/{locale}/filament/{package}.php
```

## Tests Location

```
filament/tests/src/
├── Forms/
│   └── Components/
│       ├── TextInputTest.php
│       └── SelectTest.php
├── Tables/
│   ├── Columns/
│   └── Filters/
├── Actions/
├── Panels/
│   └── Resources/
└── ...
```

## Documentation Location

### Main Docs

```
filament/docs/
├── 01-introduction/
│   ├── overview.md
│   ├── installation.md
│   └── ai.md
├── 03-resources/
│   ├── overview.md
│   ├── listing-records.md
│   ├── creating-records.md
│   └── ...
├── 06-navigation/
├── 07-users/
├── 08-styling/
├── 09-advanced/
├── 10-testing/
├── 11-plugins/
├── 12-components/
├── 05-panel-configuration.md
├── 13-deployment.md
└── 14-upgrade-guide.md
```

### Package Docs

```
packages/{package}/docs/
├── 01-overview.md
├── 02-{component}.md
├── ...
```

## Demo Structure Reference

Demo uses separated concerns pattern:

```
demo/app/Filament/
├── Resources/
│   ├── Shop/
│   │   ├── Products/
│   │   │   ├── ProductResource.php
│   │   │   ├── Schemas/ProductForm.php
│   │   │   ├── Tables/ProductsTable.php
│   │   │   ├── Pages/ListProducts.php, CreateProduct.php, EditProduct.php
│   │   │   ├── RelationManagers/CommentsRelationManager.php
│   │   │   └── Widgets/ProductStats.php
│   │   ├── Orders/
│   │   ├── Customers/
│   │   ├── Categories/
│   │   └── Brands/
│   ├── HR/
│   │   ├── Employees/
│   │   ├── Departments/
│   │   ├── Projects/
│   │   ├── Tasks/
│   │   ├── Expenses/
│   │   ├── Timesheets/
│   │   └── LeaveRequests/
│   └── Blog/
│       └── Posts/
│       └── Categories/
├── Widgets/
│   ├── WorkforceInsightsStats.php
│   ├── CustomerSegmentsChart.php
│   └── ...
├── Imports/
│   └── Shop/CategoryImporter.php
│   └── Blog/CategoryImporter.php
├── Exports/
│   └── Shop/BrandExporter.php
│   └── Blog/AuthorExporter.php
└── App/
    └── Pages/
        ├── Settings.php
        └── RegisterTeam.php
```

## Related

- [overview.md](overview.md) - Package hierarchy
- [naming-conventions.md](naming-conventions.md) - Naming patterns
- [../patterns/separated-concerns.md](../patterns/separated-concerns.md) - Separation pattern details