# Plugins - Spatie Settings

> Package: `filament/spatie-laravel-settings-plugin` | Settings management with Spatie Settings.

## Installation

```bash
composer require filament/spatie-laravel-settings-plugin:"^3.0"
```

## Setup

Add to panel:

```php
use Filament\SpatieLaravelSettingsPlugin\SpatieLaravelSettingsPlugin;

$panel->plugin(SpatieLaravelSettingsPlugin::make())
```

## Custom Settings Page

Create a settings page:

```bash
php artisan make:filament-page Settings
```

### Settings Page with Form

```php
use App\Settings\GeneralSettings;
use Filament\Forms\Components\TextInput;
use Filament\Pages\Page;

class Settings extends Page
{
    protected static string $view = 'filament.pages.settings';
    
    public function schema(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('site_name')
                    ->label('Site Name')
                    ->required(),
                TextInput::make('contact_email')
                    ->email()
                    ->required(),
            ]);
    }
    
    public function save(): void
    {
        $settings = app(GeneralSettings::class);
        $settings->site_name = $this->form->getState()['site_name'];
        $settings->contact_email = $this->form->getState()['contact_email'];
        $settings->save();
        
        Notification::make()
            ->title('Settings saved')
            ->success()
            ->send();
    }
}
```

## Settings Class

Define settings:

```php
use Spatie\LaravelSettings\Settings;

class GeneralSettings extends Settings
{
    public string $site_name;
    public string $contact_email;
    
    public static function group(): string
    {
        return 'general';
    }
}
```

## Using Settings in Resources

```php
use App\Settings\GeneralSettings;

public static function form(Schema $schema): Schema
{
    $settings = app(GeneralSettings::class);
    
    return $schema
        ->components([
            TextInput::make('name')
                ->default($settings->site_name),
        ]);
}
```

## Related

- [../panels/pages.md](../panels/pages.md) - Custom pages