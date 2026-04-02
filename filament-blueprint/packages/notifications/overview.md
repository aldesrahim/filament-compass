# Notifications

> Package: `filament/notifications` | Notification patterns.

## Namespace

```php
use Filament\Notifications\Notification;
```

## Basic Notification

```php
Notification::make()
    ->title('Success!')
    ->body('Your changes have been saved.')
    ->success()
    ->send();
```

## Notification Types

| Method | Color | Icon |
|--------|-------|------|
| `success()` | Green | Check |
| `warning()` | Yellow | Warning |
| `danger()` | Red | X |
| `info()` | Blue | Info |

```php
Notification::make()
    ->title('Warning')
    ->warning()
    ->send();

Notification::make()
    ->title('Error')
    ->danger()
    ->send();
```

## Notification Configuration

```php
Notification::make()
    ->title('Notification Title')
    ->body('Optional body text')
    ->icon('heroicon-o-check-circle')
    ->iconColor('success')
    ->duration(5000)  // milliseconds, or 'persistent'
    ->send()
```

## Actions in Notifications

```php
Notification::make()
    ->title('File export ready')
    ->body('Your file is ready to download.')
    ->actions([
        Action::make('download')
            ->label('Download')
            ->url(route('exports.download'))
            ->button(),
        Action::make('view')
            ->label('View')
            ->url(route('exports.index')),
    ])
    ->success()
    ->send()
```

## Database Notifications

For persistent notifications stored in database.

### Send Database Notification

```php
use Filament\Notifications\DatabaseNotification;

DatabaseNotification::make()
    ->title('New Order')
    ->body('You have a new order from John Doe.')
    ->actions([
        Action::make('view')
            ->label('View Order')
            ->url(route('orders.view', $order)),
    ])
    ->sendToDatabase($user);  // Send to specific user
```

### Send to Authenticated User

```php
Notification::make()
    ->title('Success')
    ->success()
    ->sendToDatabase(auth()->user());
```

### Send to Multiple Users

```php
Notification::make()
    ->title('System Update')
    ->info()
    ->sendToDatabase(User::admins()->get());
```

## Broadcast Notifications

Real-time notifications via WebSocket.

```php
use Filament\Notifications\BroadcastNotification;

BroadcastNotification::make()
    ->title('New Message')
    ->body('You have a new message.')
    ->send();
```

## Notification in Actions

```php
Action::make('delete')
    ->action(function (Product $record) {
        $record->delete();
        
        Notification::make()
            ->title('Product deleted')
            ->success()
            ->send();
    })

// Or use built-in methods
Action::make('delete')
    ->successNotificationTitle('Product deleted')
    ->failureNotificationTitle('Failed to delete product')
```

## Customizing Success Notification

```php
EditAction::make()
    ->successNotification(
        Notification::make()
            ->title('Product updated')
            ->body('Your changes have been saved.')
            ->success()
    )

// Or disable
EditAction::make()
    ->successNotification(null)
```

## Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Tables/ProductsTable.php`

```php
DeleteAction::make()
    ->action(function (): void {
        Notification::make()
            ->title('Now, now, don\'t be cheeky, leave some records for others to play with!')
            ->warning()
            ->send();
    })
```

## Notification Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `title()` | Title text | `->title('Success')` |
| `body()` | Body text | `->body('Optional details')` |
| `icon()` | Icon | `->icon('heroicon-o-check')` |
| `iconColor()` | Icon color | `->iconColor('success')` |
| `duration()` | Display duration | `->duration(5000)` or `'persistent'` |
| `success()` | Success type | `->success()` |
| `warning()` | Warning type | `->warning()` |
| `danger()` | Danger type | `->danger()` |
| `info()` | Info type | `->info()` |
| `actions()` | Action buttons | `->actions([...])` |
| `send()` | Send immediately | `->send()` |
| `sendToDatabase()` | Send to database | `->sendToDatabase($user)` |

## Related

- [../actions/overview.md](../actions/overview.md) - Actions with notifications