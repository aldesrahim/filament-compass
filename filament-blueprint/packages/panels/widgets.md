# Panels - Widgets

> Package: `filament/widgets` | Dashboard statistics and charts.

## Widget Types

| Widget | Purpose |
|--------|---------|
| `StatsOverviewWidget` | Statistics cards |
| `ChartWidget` | Charts (line, bar, pie, etc.) |
| `TableWidget` | Table as widget |

## StatsOverviewWidget

Displays multiple stat cards with values, descriptions, icons.

### Basic Stats Widget

```php
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class ProductStats extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Products', Product::count())
                ->description('All products in catalog')
                ->descriptionIcon('heroicon-o-shopping-bag')
                ->color('success'),
            
            Stat::make('Low Stock', Product::where('qty', '<', 10)->count())
                ->description('Products needing reorder')
                ->descriptionIcon('heroicon-o-exclamation-triangle')
                ->color('warning'),
            
            Stat::make('Revenue', '$' . Product::sum('price'))
                ->description('Total product value')
                ->chart([1, 3, 5, 2, 4])
                ->color('primary'),
        ];
    }
}
```

### Stat Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `make()` | Create stat | `Stat::make('Label', $value)` |
| `description()` | Description text | `'32% increase'` |
| `descriptionIcon()` | Icon | `'heroicon-o-arrow-up'` |
| `color()` | Color | `'success'`, `'warning'`, `'danger'`, `'primary'` |
| `chart()` | Mini chart data | `[1, 3, 5, 2, 4]` |
| `chartColor()` | Chart color | `'success'` |
| `icon()` | Main icon | `'heroicon-o-shopping-bag'` |
| `extraAttributes()` | HTML attributes | `['class' => 'cursor-pointer']` |

### Real Example

From demo: `demo/app/Filament/Resources/Shop/Products/Widgets/ProductStats.php`

```php
<?php

namespace App\Filament\Resources\Shop\Products\Widgets;

use App\Models\Shop\Product;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class ProductStats extends StatsOverviewWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Products', Product::count())
                ->description('Active products')
                ->color('success'),
            
            Stat::make('Low Stock', Product::whereColumn('qty', '<', 'security_stock')->count())
                ->description('Needs attention')
                ->color('danger'),
        ];
    }
}
```

## ChartWidget

Display charts using Chart.js.

### Basic Chart Widget

```php
use Filament\Widgets\ChartWidget;

class SalesChart extends ChartWidget
{
    protected static ?string $heading = 'Sales';
    
    protected function getData(): array
    {
        return [
            'datasets' => [
                [
                    'label' => 'Sales',
                    'data' => [1, 3, 5, 2, 4],
                    'backgroundColor' => 'rgba(255, 99, 132, 0.2)',
                    'borderColor' => 'rgba(255, 99, 132, 1)',
                ],
            ],
            'labels' => ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
        ];
    }
    
    protected function getType(): string
    {
        return 'line';
    }
}
```

### Chart Types

| Method | Chart Type |
|--------|-----------|
| `'line'` | Line chart |
| `'bar'` | Bar chart |
| `'pie'` | Pie chart |
| `'doughnut'` | Doughnut chart |
| `'radar'` | Radar chart |
| `'polarArea'` | Polar area chart |
| `'scatter'` | Scatter chart |
| `'bubble'` | Bubble chart |

### Pre-built Chart Widgets

```php
use Filament\Widgets\LineChartWidget;    // Line chart
use Filament\Widgets\BarChartWidget;     // Bar chart
use Filament\Widgets\PieChartWidget;     // Pie chart
use Filament\Widgets\DoughnutChartWidget; // Doughnut chart
use Filament\Widgets\RadarChartWidget;   // Radar chart
use Filament\Widgets\PolarAreaChartWidget; // Polar area
use Filament\Widgets\ScatterChartWidget; // Scatter chart
use Filament\Widgets\BubbleChartWidget;  // Bubble chart
```

### Real Example

From demo: `demo/app/Filament/Widgets/CustomerSegmentsChart.php`

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Shop\Customer;
use Filament\Widgets\ChartWidget;

class CustomerSegmentsChart extends ChartWidget
{
    protected static ?string $heading = 'Customer Segments';
    
    protected function getData(): array
    {
        $segments = Customer::selectRaw('segment, count(*) as count')
            ->groupBy('segment')
            ->pluck('count', 'segment');
        
        return [
            'datasets' => [
                [
                    'label' => 'Customers',
                    'data' => $segments->values(),
                    'backgroundColor' => ['#FF6384', '#36A2EB', '#FFCE56'],
                ],
            ],
            'labels' => $segments->keys(),
        ];
    }
    
    protected function getType(): string
    {
        return 'pie';
    }
}
```

### Chart Filters

```php
use Filament\Widgets\ChartWidget;

class SalesChart extends ChartWidget
{
    protected static ?string $heading = 'Sales';
    
    protected function getFilters(): array
    {
        return [
            'today' => 'Today',
            'week' => 'This Week',
            'month' => 'This Month',
            'year' => 'This Year',
        ];
    }
    
    protected function getData(): array
    {
        $filter = $this->filter;
        
        // Get data based on filter
        $data = match ($filter) {
            'today' => Sales::today()->pluck('amount'),
            'week' => Sales::thisWeek()->pluck('amount'),
            'month' => Sales::thisMonth()->pluck('amount'),
            'year' => Sales::thisYear()->pluck('amount'),
            default => Sales::pluck('amount'),
        };
        
        return [
            'datasets' => [
                ['label' => 'Sales', 'data' => $data],
            ],
            'labels' => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        ];
    }
    
    protected function getType(): string
    {
        return 'bar';
    }
}
```

## TableWidget

Display a table as a widget.

```php
use Filament\Widgets\TableWidget;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class RecentOrders extends TableWidget
{
    protected int | string | array $columnSpan = 'full';
    
    protected function getTableQuery(): Builder
    {
        return Order::query()->latest()->limit(10);
    }
    
    protected function getTableColumns(): array
    {
        return [
            TextColumn::make('id'),
            TextColumn::make('customer.name'),
            TextColumn::make('total'),
            TextColumn::make('status'),
        ];
    }
}
```

## Widget Configuration

### Position in Dashboard

```php
// In resource
public static function getWidgets(): array
{
    return [ProductStats::class];
}

public static function getWidgetsPosition(): string
{
    return 'before'; // 'before' table or 'after' table
}
```

### Column Span

```php
class ProductStats extends StatsOverviewWidget
{
    protected int | string | array $columnSpan = 'full';  // Full width
    
    protected int | string | array $columnSpan = 2;       // 2 columns
    
    protected int | string | array $columnSpan = [
        'md' => 2,  // 2 columns on medium screens
        'lg' => 3,  // 3 columns on large screens
    ];
}
```

### Sort

```php
class ProductStats extends StatsOverviewWidget
{
    protected static ?int $sort = 1;  // Display order
}
```

### Polling

Auto-refresh widget data:

```php
class SalesChart extends ChartWidget
{
    protected static ?string $pollingInterval = '5s'; // Poll every 5 seconds
    
    protected static bool $shouldPoll = true; // Enable/disable polling
}
```

## Related

- [resources.md](resources.md) - Resource structure
- [panels.md](panels.md) - Panel configuration
- [../../recipes/dashboard.md](../../recipes/dashboard.md) - Dashboard recipe