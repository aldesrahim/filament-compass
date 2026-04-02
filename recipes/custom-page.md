# Custom Page Recipe

> Custom pages for non-resource functionality.

## Create Custom Page

```bash
php artisan make:filament-page Settings
```

## Basic Custom Page

```php
<?php

namespace App\Filament\App\Pages;

use Filament\Pages\Page;

class Settings extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-cog';
    
    protected static string $view = 'filament.pages.settings';
    
    protected static ?string $navigationLabel = 'Settings';
    
    protected static ?string $title = 'Application Settings';
    
    protected static ?string $navigationGroup = 'System';
    
    protected static ?int $navigationSort = 100;
}
```

## Custom Page with Form

```php
<?php

namespace App\Filament\App\Pages;

use App\Settings\GeneralSettings;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Notifications\Notification;
use Filament\Pages\Page;
use Filament\Schemas\Schema;

class Settings extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-cog';
    
    protected static string $view = 'filament.pages.settings';
    
    protected static ?string $navigationGroup = 'System';
    
    public array $data = [];
    
    public function mount(): void
    {
        $settings = app(GeneralSettings::class);
        
        $this->form->fill([
            'site_name' => $settings->site_name,
            'contact_email' => $settings->contact_email,
            'notifications_enabled' => $settings->notifications_enabled,
        ]);
    }
    
    public function schema(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('site_name')
                    ->label('Site Name')
                    ->required(),
                
                TextInput::make('contact_email')
                    ->label('Contact Email')
                    ->email()
                    ->required(),
                
                Toggle::make('notifications_enabled')
                    ->label('Enable Notifications'),
            ]);
    }
    
    public function save(): void
    {
        $data = $this->form->getState();
        
        $settings = app(GeneralSettings::class);
        $settings->site_name = $data['site_name'];
        $settings->contact_email = $data['contact_email'];
        $settings->notifications_enabled = $data['notifications_enabled'];
        $settings->save();
        
        Notification::make()
            ->title('Settings saved')
            ->success()
            ->send();
    }
}
```

## View File

```blade
{{-- resources/views/filament/pages/settings.blade.php --}}
<x-filament-panels::page>
    <form wire:submit="save">
        {{ $this->form }}
        
        <div class="mt-6">
            <x-filament::button type="submit">
                Save Settings
            </x-filament::button>
        </div>
    </form>
</x-filament-panels::page>
```

## Custom Page with Actions

```php
<?php

namespace App\Filament\App\Pages;

use App\Models\Export;
use Filament\Actions\Action;
use Filament\Notifications\Notification;
use Filament\Pages\Page;

class Reports extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-chart-bar';
    
    protected static string $view = 'filament.pages.reports';
    
    protected static ?string $navigationGroup = 'Reports';
    
    protected function getHeaderActions(): array
    {
        return [
            Action::make('export_sales')
                ->label('Export Sales Report')
                ->icon('heroicon-o-arrow-down-tray')
                ->action(function () {
                    $export = Export::createSalesReport();
                    
                    Notification::make()
                        ->title('Export started')
                        ->body('You will be notified when the export is ready.')
                        ->info()
                        ->send();
                }),
            
            Action::make('export_customers')
                ->label('Export Customer List')
                ->icon('heroicon-o-arrow-down-tray')
                ->action(fn () => Export::createCustomerList()),
        ];
    }
}
```

## Custom Page with Table

```php
<?php

namespace App\Filament\App\Pages;

use App\Models\ActivityLog;
use Filament\Pages\Page;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Table;

class ActivityLogs extends Page implements HasTable
{
    use InteractsWithTable;
    
    protected static ?string $navigationIcon = 'heroicon-o-clipboard-document-list';
    
    protected static string $view = 'filament.pages.activity-logs';
    
    protected static ?string $navigationGroup = 'System';
    
    public function table(Table $table): Table
    {
        return $table
            ->query(ActivityLog::query()->latest())
            ->columns([
                TextColumn::make('user.name'),
                TextColumn::make('action'),
                TextColumn::make('subject_type'),
                TextColumn::make('created_at')->dateTime(),
            ])
            ->filters([
                // ...
            ])
            ->paginated([10, 25, 50]);
    }
}
```

## View with Table

```blade
{{-- resources/views/filament/pages/activity-logs.blade.php --}}
<x-filament-panels::page>
    {{ $this->table }}
</x-filament-panels::page>
```

## Registration Page (Example from Demo)

```php
<?php

namespace App\Filament\App\Pages;

use Filament\Pages\Page;

class RegisterTeam extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-user-group';
    
    protected static string $view = 'filament.pages.register-team';
    
    protected static ?string $title = 'Register Your Team';
    
    protected static bool $shouldRegisterNavigation = false;
}
```

## Page Visibility

```php
protected static bool $shouldRegisterNavigation = false;  // Hide from nav

public static function canAccess(): bool
{
    return auth()->user()->isAdmin();
}
```

## Related

- [../packages/panels/pages.md](../packages/panels/pages.md) - Page documentation
- [dashboard.md](dashboard.md) - Dashboard recipe