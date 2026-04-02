# Namespace Reference

> Quick reference for Filament namespaces.

## Core Namespaces

| Category | Namespace |
|----------|-----------|
| **Form fields** | `Filament\Forms\Components\` |
| **Table columns** | `Filament\Tables\Columns\` |
| **Table filters** | `Filament\Tables\Filters\` |
| **Infolist entries** | `Filament\Infolists\Components\` |
| **Layout components** | `Filament\Schemas\Components\` |
| **Schema utilities** | `Filament\Schemas\Components\Utilities\` |
| **Actions** | `Filament\Actions\` |
| **Notifications** | `Filament\Notifications\` |
| **Icons** | `Filament\Support\Icons\` |
| **Colors** | `Filament\Support\Colors\` |
| **Facades** | `Filament\Support\Facades\` |

## Common Imports

### Form Components

```php
use Filament\Forms\Components\Checkbox;
use Filament\Forms\Components\CheckboxList;
use Filament\Forms\Components\ColorPicker;
use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\KeyValue;
use Filament\Forms\Components\MarkdownEditor;
use Filament\Forms\Components\Placeholder;
use Filament\Forms\Components\Radio;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TagsInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Components\ToggleButtons;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\Builder;
use Filament\Forms\Components\Slider;
use Filament\Forms\Components\CodeEditor;
```

### Layout Components

```php
use Filament\Schemas\Components\Grid;
use Filament\Schemas\Components\Group;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Fieldset;
use Filament\Schemas\Components\Tabs;
use Filament\Schemas\Components\Wizard;
use Filament\Schemas\Components\Actions;
use Filament\Schemas\Components\Callout;
use Filament\Schemas\Components\Flex;
use Filament\Schemas\Components\Html;
use Filament\Schemas\Components\Icon;
use Filament\Schemas\Components\Image;
use Filament\Schemas\Components\Text;
use Filament\Schemas\Schema;
```

### Schema Utilities

```php
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Components\Utilities\Set;
```

### Table Columns

```php
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\ColorColumn;
use Filament\Tables\Columns\BooleanColumn;
use Filament\Tables\Columns\BadgeColumn;
use Filament\Tables\Columns\CheckboxColumn;
use Filament\Tables\Columns\SelectColumn;
use Filament\Tables\Columns\TextInputColumn;
use Filament\Tables\Columns\ToggleColumn;
use Filament\Tables\Columns\TagsColumn;
use Filament\Tables\Table;
```

### Table Filters

```php
use Filament\Tables\Filters\Filter;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Filters\TrashedFilter;
use Filament\Tables\Filters\QueryBuilder;
use Filament\Tables\Filters\QueryBuilder\Constraints\TextConstraint;
use Filament\Tables\Filters\QueryBuilder\Constraints\NumberConstraint;
use Filament\Tables\Filters\QueryBuilder\Constraints\BooleanConstraint;
use Filament\Tables\Filters\QueryBuilder\Constraints\DateConstraint;
```

### Infolist Entries

```php
use Filament\Infolists\Components\TextEntry;
use Filament\Infolists\Components\IconEntry;
use Filament\Infolists\Components\ImageEntry;
use Filament\Infolists\Components\ColorEntry;
use Filament\Infolists\Components\KeyValueEntry;
use Filament\Infolists\Components\RepeatableEntry;
use Filament\Infolists\Components\CodeEntry;
use Filament\Infolists\Infolist;
```

### Actions

```php
use Filament\Actions\Action;
use Filament\Actions\ActionGroup;
use Filament\Actions\BulkAction;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\CreateAction;
use Filament\Actions\EditAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\ViewAction;
use Filament\Actions\ReplicateAction;
use Filament\Actions\ForceDeleteAction;
use Filament\Actions\RestoreAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\ForceDeleteBulkAction;
use Filament\Actions\RestoreBulkAction;
use Filament\Actions\ImportAction;
use Filament\Actions\ExportAction;
use Filament\Actions\ExportBulkAction;
use Filament\Actions\AttachAction;
use Filament\Actions\DetachAction;
use Filament\Actions\AssociateAction;
use Filament\Actions\DissociateAction;
```

### Notifications

```php
use Filament\Notifications\Notification;
use Filament\Notifications\DatabaseNotification;
use Filament\Notifications\BroadcastNotification;
```

### Icons

```php
use Filament\Support\Icons\Heroicon;
```

### Colors

```php
use Filament\Support\Colors\Color;
```

### Enums

```php
use Filament\Support\Enums\FontWeight;
use Filament\Support\Enums\Alignment;
use Filament\Support\Enums\MaxWidth;
use Filament\Support\Enums\Width;
use Filament\Support\Enums\Operation;
```

### Resources & Pages

```php
use Filament\Resources\Resource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;
use Filament\Resources\Pages\ViewRecord;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Pages\Page;
use Filament\Pages\Dashboard;
```

### Widgets

```php
use Filament\Widgets\Widget;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Filament\Widgets\ChartWidget;
use Filament\Widgets\TableWidget;
use Filament\Widgets\LineChartWidget;
use Filament\Widgets\BarChartWidget;
use Filament\Widgets\PieChartWidget;
```

### Panels

```php
use Filament\Panel;
use Filament\PanelProvider;
```

### Spatie Plugins

```php
// Media Library
use Filament\Forms\Components\SpatieMediaLibraryFileUpload;
use Filament\Tables\Columns\SpatieMediaLibraryImageColumn;
use Filament\Infolists\Components\SpatieMediaLibraryImageEntry;
use Filament\SpatieLaravelMediaLibraryPlugin\SpatieMediaLibraryPlugin;

// Tags
use Filament\Forms\Components\SpatieTagsInput;
use Filament\Tables\Columns\SpatieTagsColumn;
use Filament\Infolists\Components\SpatieTagsEntry;
use Filament\SpatieLaravelTagsPlugin\SpatieLaravelTagsPlugin;

// Settings
use Filament\SpatieLaravelSettingsPlugin\SpatieLaravelSettingsPlugin;
```

## Common Mistakes

❌ **Wrong**: `Filament\Tables\Actions\EditAction`  
✅ **Right**: `Filament\Actions\EditAction`

❌ **Wrong**: `Filament\Forms\Components\Grid`  
✅ **Right**: `Filament\Schemas\Components\Grid`

❌ **Wrong**: `Filament\Forms\Components\Get`  
✅ **Right**: `Filament\Schemas\Components\Utilities\Get`

## Related

- [common-mistakes.md](common-mistakes.md) - Common pitfalls
- [breaking-changes.md](breaking-changes.md) - Breaking changes