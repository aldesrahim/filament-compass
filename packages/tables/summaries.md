# Tables - Summaries

> Package: `filament/tables` | Column summaries (totals, averages, counts).

## Summary Types

| Summarizer | Purpose |
|-------------|---------|
| `CountSummarizer` | Count of records |
| `SumSummarizer` | Sum of values |
| `AverageSummarizer` | Average of values |
| `RangeSummarizer` | Min/Max range |
| `MaxSummarizer` | Maximum value |
| `MinSummarizer` | Minimum value |

## Basic Summaries

```php
use Filament\Tables\Columns\Summarizers\CountSummarizer;
use Filament\Tables\Columns\Summarizers\SumSummarizer;
use Filament\Tables\Columns\Summarizers\AverageSummarizer;

TextColumn::make('price')
    ->summarize([
        SumSummarizer::make()
            ->money('USD'),
        AverageSummarizer::make()
            ->money('USD')
            ->label('Avg'),
    ])

TextColumn::make('status')
    ->summarize([
        CountSummarizer::make()
            ->label('Total'),
    ])
```

## Count Summarizer

```php
CountSummarizer::make()
    ->label('Total Products')

// With conditions
CountSummarizer::make()
    ->label('Featured')
    ->query(fn ($query) => $query->where('is_featured', true))
```

## Sum Summarizer

```php
SumSummarizer::make()
    ->label('Total Revenue')
    ->money('USD')

// Custom format
SumSummarizer::make()
    ->label('Total Quantity')
    ->numeric(decimalPlaces: 0)
```

## Average Summarizer

```php
AverageSummarizer::make()
    ->label('Average Price')
    ->money('USD')
    ->numeric(decimalPlaces: 2)
```

## Range Summarizer

```php
use Filament\Tables\Columns\Summarizers\RangeSummarizer;

RangeSummarizer::make()
    ->label('Price Range')
    ->money('USD')
    ->separator('-')
```

## Min/Max Summarizers

```php
use Filament\Tables\Columns\Summarizers\MaxSummarizer;
use Filament\Tables\Columns\Summarizers\MinSummarizer;

TextColumn::make('price')
    ->summarize([
        MinSummarizer::make()
            ->label('Min')
            ->money('USD'),
        MaxSummarizer::make()
            ->label('Max')
            ->money('USD'),
    ])
```

## Custom Summarizers

```php
use Filament\Tables\Columns\Summarizers\Summarizer;

class CustomSummarizer extends Summarizer
{
    protected function runQuery($query, $column)
    {
        return $query->avg($column->getName());
    }
    
    protected function formatState($state)
    {
        return number_format($state, 2);
    }
}
```

## Summary Formatting

### Money

```php
SumSummarizer::make()
    ->money('USD')
    ->divideBy(100)  // If stored in cents
```

### Numeric

```php
AverageSummarizer::make()
    ->numeric(decimalPlaces: 2)
```

### Date

```php
MaxSummarizer::make()
    ->date()
```

## Real Example

```php
// Order totals
TextColumn::make('total')
    ->money('USD')
    ->summarize([
        SumSummarizer::make()
            ->money('USD')
            ->label('Total Revenue'),
        AverageSummarizer::make()
            ->money('USD')
            ->label('Avg Order'),
    ])

// Product counts
TextColumn::make('id')
    ->label('Products')
    ->summarize([
        CountSummarizer::make()
            ->label('Total'),
        CountSummarizer::make()
            ->label('Active')
            ->query(fn ($query) => $query->where('is_visible', true)),
        CountSummarizer::make()
            ->label('Low Stock')
            ->query(fn ($query) => $query->whereColumn('qty', '<', 'security_stock')),
    ])
```

## Summary Position

Summaries appear at the bottom of the table by default. Control visibility:

```php
->summarize([
    SumSummarizer::make()
        ->visible(fn ($query) => $query->count() > 0),
])
```

## Related

- [columns.md](columns.md) - Table columns
- [actions.md](actions.md) - Table actions