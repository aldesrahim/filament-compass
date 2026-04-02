# Dashboard Recipe

> Custom dashboard with widgets and charts.

## Custom Dashboard Class

```php
<?php

namespace App\Filament\Pages;

use App\Filament\Widgets\CustomerSegmentsChart;
use App\Filament\Widgets\FlaggedOrders;
use App\Filament\Widgets\WorkforceInsightsStats;
use Filament\Pages\Dashboard as BaseDashboard;

class Dashboard extends BaseDashboard
{
    protected static ?string $navigationLabel = 'Dashboard';
    
    protected static string $view = 'filament.pages.dashboard';
    
    protected function getHeaderWidgets(): array
    {
        return [
            WorkforceInsightsStats::class,
        ];
    }
    
    protected function getFooterWidgets(): array
    {
        return [
            CustomerSegmentsChart::class,
            FlaggedOrders::class,
        ];
    }
    
    protected function getColumns(): int
    {
        return 3;
    }
}
```

## Stats Widget

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Shop\Order;
use App\Models\Shop\Product;
use App\Models\Shop\Customer;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class WorkforceInsightsStats extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Orders', Order::count())
                ->description('All time orders')
                ->descriptionIcon('heroicon-o-shopping-cart')
                ->color('success')
                ->chart([1, 3, 5, 2, 4, 6, 8]),
            
            Stat::make('Products', Product::count())
                ->description('Active products')
                ->descriptionIcon('heroicon-o-cube')
                ->color('primary'),
            
            Stat::make('Customers', Customer::count())
                ->description('Registered customers')
                ->descriptionIcon('heroicon-o-users')
                ->color('info'),
            
            Stat::make('Revenue', '$' . number_format(Order::sum('total'), 2))
                ->description('Total revenue')
                ->descriptionIcon('heroicon-o-currency-dollar')
                ->color('warning')
                ->chart([2, 4, 6, 8, 10, 12, 14]),
        ];
    }
    
    protected function getColumns(): int
    {
        return 4;
    }
}
```

## Chart Widget

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Shop\Order;
use Filament\Widgets\ChartWidget;

class CustomerSegmentsChart extends ChartWidget
{
    protected static ?string $heading = 'Customer Segments';
    
    protected static ?int $sort = 2;
    
    protected function getData(): array
    {
        $segments = Order::selectRaw('status, count(*) as count')
            ->groupBy('status')
            ->pluck('count', 'status');
        
        return [
            'datasets' => [
                [
                    'label' => 'Orders',
                    'data' => $segments->values(),
                    'backgroundColor' => [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                    ],
                ],
            ],
            'labels' => $segments->keys(),
        ];
    }
    
    protected function getType(): string
    {
        return 'pie';
    }
    
    protected function getOptions(): array
    {
        return [
            'plugins' => [
                'legend' => [
                    'position' => 'bottom',
                ],
            ],
        ];
    }
}
```

## Table Widget

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Shop\Order;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Database\Eloquent\Builder;

class FlaggedOrders extends TableWidget
{
    protected static ?string $heading = 'Flagged Orders';
    
    protected static ?int $sort = 3;
    
    protected int | string | array $columnSpan = 'full';
    
    protected function getTableQuery(): Builder
    {
        return Order::query()
            ->where('is_flagged', true)
            ->latest();
    }
    
    protected function getTableColumns(): array
    {
        return [
            TextColumn::make('order_number'),
            TextColumn::make('customer.name'),
            TextColumn::make('total')->money('USD'),
            TextColumn::make('status')->badge(),
            TextColumn::make('created_at')->dateTime(),
        ];
    }
}
```

## Register Dashboard

In panel configuration:

```php
use App\Filament\Pages\Dashboard;

$panel
    ->discoverPages()
    ->pages([
        Dashboard::class,
    ])
```

## Widget Configuration

### Column Span

```php
protected int | string | array $columnSpan = 'full';  // Full width
protected int | string | array $columnSpan = 2;       // 2 columns
protected int | string | array $columnSpan = ['md' => 2, 'lg' => 3];
```

### Sort Order

```php
protected static ?int $sort = 1;  // Lower numbers appear first
```

### Polling

```php
protected static ?string $pollingInterval = '10s';
```

### Lazy Loading

```php
protected static bool $isLazy = true;
```

## Related

- [../packages/panels/widgets.md](../packages/panels/widgets.md) - Widget documentation
- [../packages/panels/panels.md](../packages/panels/panels.md) - Panel configuration