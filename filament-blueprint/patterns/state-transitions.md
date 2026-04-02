# State Transitions Pattern

> Implementing status workflows and state transitions with Actions.

## Status Enum

Define statuses as enum:

```php
enum OrderStatus: string
{
    case Pending = 'pending';
    case Confirmed = 'confirmed';
    case Processing = 'processing';
    case Shipped = 'shipped';
    case Delivered = 'delivered';
    case Cancelled = 'cancelled';
    
    public function getLabel(): string
    {
        return match ($this) {
            self::Pending => 'Pending',
            self::Confirmed => 'Confirmed',
            self::Processing => 'Processing',
            self::Shipped => 'Shipped',
            self::Delivered => 'Delivered',
            self::Cancelled => 'Cancelled',
        };
    }
    
    public function getColor(): string
    {
        return match ($this) {
            self::Pending => 'warning',
            self::Confirmed => 'info',
            self::Processing => 'primary',
            self::Shipped => 'success',
            self::Delivered => 'success',
            self::Cancelled => 'danger',
        };
    }
    
    public function canTransitionTo(self $status): bool
    {
        return match ($this) {
            self::Pending => in_array($status, [self::Confirmed, self::Cancelled]),
            self::Confirmed => in_array($status, [self::Processing, self::Cancelled]),
            self::Processing => in_array($status, [self::Shipped, self::Cancelled]),
            self::Shipped => $status === self::Delivered,
            self::Delivered => false,
            self::Cancelled => false,
        };
    }
}
```

## Status Column with Badge

```php
use Filament\Tables\Columns\TextColumn;

TextColumn::make('status')
    ->badge()
    ->formatStateUsing(fn (OrderStatus $state) => $state->getLabel())
    ->color(fn (OrderStatus $state) => $state->getColor())
```

## Transition Actions

### Basic Transition Action

```php
use Filament\Actions\Action;

Action::make('confirm')
    ->label('Confirm Order')
    ->icon(Heroicon::Check)
    ->color('success')
    ->visible(fn (Order $record) => $record->status->canTransitionTo(OrderStatus::Confirmed))
    ->requiresConfirmation()
    ->action(function (Order $record) {
        $record->update(['status' => OrderStatus::Confirmed]);
        
        Notification::make()
            ->title('Order confirmed')
            ->success()
            ->send();
    })
```

### Dynamic Transition Actions

```php
// Generate actions for all valid transitions
public static function getTransitionActions(): array
{
    return collect(OrderStatus::cases())
        ->map(fn (OrderStatus $status) => 
            Action::make("transition_to_{$status->value}")
                ->label($status->getLabel())
                ->icon(match($status) {
                    OrderStatus::Confirmed => Heroicon::Check,
                    OrderStatus::Shipped => Heroicon::Truck,
                    OrderStatus::Cancelled => Heroicon::X,
                    default => Heroicon::ArrowRight,
                })
                ->color($status->getColor())
                ->visible(fn (Order $record) => $record->status->canTransitionTo($status))
                ->requiresConfirmation()
                ->modalHeading("Mark as {$status->getLabel()}")
                ->action(fn (Order $record) => $record->update(['status' => $status]))
        )
        ->toArray();
}
```

### Action Group for Transitions

```php
use Filament\Actions\ActionGroup;

ActionGroup::make([
    Action::make('confirm')
        ->label('Confirm')
        ->icon(Heroicon::Check)
        ->visible(fn (Order $record) => $record->status->canTransitionTo(OrderStatus::Confirmed))
        ->action(fn (Order $record) => $record->update(['status' => OrderStatus::Confirmed])),
    
    Action::make('ship')
        ->label('Mark as Shipped')
        ->icon(Heroicon::Truck)
        ->visible(fn (Order $record) => $record->status->canTransitionTo(OrderStatus::Shipped))
        ->action(fn (Order $record) => $record->update(['status' => OrderStatus::Shipped])),
    
    Action::make('cancel')
        ->label('Cancel Order')
        ->icon(Heroicon::X)
        ->color('danger')
        ->visible(fn (Order $record) => $record->status->canTransitionTo(OrderStatus::Cancelled))
        ->requiresConfirmation()
        ->action(fn (Order $record) => $record->update(['status' => OrderStatus::Cancelled])),
])
```

## Transition with Form

Collect additional data during transition:

```php
Action::make('ship')
    ->label('Mark as Shipped')
    ->icon(Heroicon::Truck)
    ->visible(fn (Order $record) => $record->status->canTransitionTo(OrderStatus::Shipped))
    ->form([
        TextInput::make('tracking_number')
            ->label('Tracking Number')
            ->required(),
        DatePicker::make('estimated_delivery')
            ->label('Estimated Delivery')
            ->required(),
    ])
    ->action(function (Order $record, array $data) {
        $record->update([
            'status' => OrderStatus::Shipped,
            'tracking_number' => $data['tracking_number'],
            'estimated_delivery' => $data['estimated_delivery'],
        ]);
    })
```

## State Transition Events

Hook into transitions:

```php
// In model
protected static function booted()
{
    static::updating(function (Order $order) {
        if ($order->isDirty('status')) {
            $oldStatus = $order->getOriginal('status');
            $newStatus = $order->status;
            
            // Log the transition
            OrderStatusLog::create([
                'order_id' => $order->id,
                'from_status' => $oldStatus,
                'to_status' => $newStatus,
                'user_id' => auth()->id(),
            ]);
            
            // Send notification
            if ($newStatus === OrderStatus::Shipped) {
                $order->customer->notify(new OrderShippedNotification($order));
            }
        }
    });
}
```

## Authorization

Only allow authorized transitions:

```php
Action::make('cancel')
    ->label('Cancel Order')
    ->visible(fn (Order $record) => 
        $record->status->canTransitionTo(OrderStatus::Cancelled) &&
        auth()->user()->can('cancel', $record)
    )
```

## Complete Table Example

```php
->recordActions([
    EditAction::make(),
    ActionGroup::make([
        Action::make('confirm')
            ->icon(Heroicon::Check)
            ->color('success')
            ->visible(fn (Order $record) => 
                $record->status->canTransitionTo(OrderStatus::Confirmed)
            )
            ->action(fn (Order $record) => $record->update(['status' => OrderStatus::Confirmed])),
        
        Action::make('ship')
            ->icon(Heroicon::Truck)
            ->color('info')
            ->visible(fn (Order $record) => 
                $record->status->canTransitionTo(OrderStatus::Shipped)
            )
            ->action(fn (Order $record) => $record->update(['status' => OrderStatus::Shipped])),
        
        Action::make('cancel')
            ->icon(Heroicon::X)
            ->color('danger')
            ->visible(fn (Order $record) => 
                $record->status->canTransitionTo(OrderStatus::Cancelled)
            )
            ->requiresConfirmation()
            ->action(fn (Order $record) => $record->update(['status' => OrderStatus::Cancelled])),
    ]),
])
```

## Related

- [../packages/actions/overview.md](../packages/actions/overview.md) - Actions
- [../packages/tables/columns.md](../packages/tables/columns.md) - Badge columns
- [authorization.md](authorization.md) - Authorization patterns