# Closure Evaluation Reference

> Filament resolves closure parameters by **name** and **type**. You never call closures manually — Filament injects what you declare.

## How It Works

```php
// These all work — Filament inspects the parameter names and types
->visible(fn (string $operation) => $operation !== 'view')
->visible(fn (Get $get) => filled($get('type')))
->visible(fn ($record, Get $get) => $record && $get('active'))
->visible(fn (User $record) => $record->is_admin)  // type-hinted model
```

Filament uses PHP reflection to match declared parameter names (or types) to available injections. You only declare what you need.

---

## Form Field Closures

Available in: `visible()`, `hidden()`, `disabled()`, `required()`, `label()`, `hint()`, `helperText()`, `placeholder()`, `default()`, `afterStateUpdated()`, `afterStateHydrated()`, `beforeStateDehydrated()`, `formatStateUsing()`, `saveRelationshipsUsing()`, and most other field methods that accept a `Closure`.

| Parameter | Type | Description |
|-----------|------|-------------|
| `$state` | `mixed` | Current field value (after casts) |
| `$rawState` | `mixed` | Current field value (before casts) |
| `$get` | `Get` | Read other field values (see [Get Utility](#get-utility)) |
| `$set` | `Set` | Write other field values (see [Set Utility](#set-utility)) |
| `$record` | `?Model` | Current Eloquent model (`null` on create) |
| `$operation` | `string` | `'create'`, `'edit'`, or `'view'` |
| `$context` | `string` | Alias for `$operation` |
| `$livewire` | `Livewire` | The Livewire component instance |
| `$component` | `Field` | The field instance itself |
| Model type-hint | e.g. `User $record` | Same as `$record`, cast to your model type |

### `afterStateUpdated()` — extra parameters

```php
TextInput::make('name')
    ->live(onBlur: true)
    ->afterStateUpdated(function ($state, $old, Get $get, Set $set, string $operation) {
        // $state — new value
        // $old   — previous value (after casts)
        $set('slug', Str::slug($state));
    })
```

| Extra Parameter | Type | Description |
|----------------|------|-------------|
| `$old` | `mixed` | Previous value (after casts) |
| `$oldRaw` | `mixed` | Previous value (before casts) |

### `$operation` values

| Value | When |
|-------|------|
| `'create'` | Create page / CreateAction modal |
| `'edit'` | Edit page / EditAction modal |
| `'view'` | View page (read-only) |

### `visibleOn()` / `hiddenOn()` shorthand

```php
// Instead of fn ($operation) => $operation === 'create'
TextInput::make('password')->visibleOn('create')

// Multiple operations
TextInput::make('id')->hiddenOn(['create', 'edit'])
```

---

## Table Column Closures

Available in: `state()`, `formatStateUsing()`, `color()`, `icon()`, `description()`, `visible()`, `hidden()`, `tooltip()`, `action()`, `url()`, `badge()`, and most column configuration methods.

| Parameter | Type | Description |
|-----------|------|-------------|
| `$state` | `mixed` | Column's resolved value |
| `$record` | `Model` | Row model instance |
| `$rowLoop` | `stdClass` | Loop metadata (see below) |
| `$livewire` | `Livewire` | The Livewire component instance |
| `$table` | `Table` | The Table instance |
| Model type-hint | e.g. `Product $record` | Same as `$record`, typed |

### `$rowLoop` properties

```php
TextColumn::make('rank')
    ->state(fn (stdClass $rowLoop) => $rowLoop->iteration)
```

| Property | Type | Description |
|----------|------|-------------|
| `$rowLoop->index` | `int` | Zero-based position |
| `$rowLoop->iteration` | `int` | One-based position |
| `$rowLoop->first` | `bool` | Is first row |
| `$rowLoop->last` | `bool` | Is last row |
| `$rowLoop->even` | `bool` | Is even row |
| `$rowLoop->odd` | `bool` | Is odd row |
| `$rowLoop->depth` | `int` | Nesting depth |
| `$rowLoop->count` | `int` | Total rows |
| `$rowLoop->remaining` | `int` | Rows remaining |
| `$rowLoop->remainingItems` | `int` | Alias for remaining |

---

## Action Closures

Available in: `action()`, `visible()`, `hidden()`, `disabled()`, `label()`, `authorize()`, `color()`, `icon()`, `before()`, `after()`, `successRedirectUrl()`, `failureRedirectUrl()`, `form fields passed to ->form([])`.

| Parameter | Type | Description |
|-----------|------|-------------|
| `$record` | `?Model` | Single record (null for list-level actions) |
| `$records` / `$selectedRecords` | `Collection` | Bulk selected records |
| `$recordsQuery` / `$selectedRecordsQuery` | `Builder` | Query for selected records |
| `$data` | `array` | Action form data (after submission) |
| `$arguments` | `array` | Arguments passed to `mountAction()` |
| `$get` / `$schemaGet` | `Get` | Read action form fields |
| `$set` / `$schemaSet` | `Set` | Write action form fields |
| `$state` / `$schemaComponentState` | `mixed` | Form component state |
| `$schemaState` | `array` | Full form state |
| `$component` / `$schemaComponent` | `Component` | The triggering component |
| `$operation` / `$context` / `$schemaOperation` | `string` | Current operation |
| `$livewire` | `Livewire` | Livewire component |
| `$table` | `?Table` | Table instance (if in table) |
| `$schema` | `Schema` | Form/infolist schema |
| `$mountedActions` | `array` | Stack of mounted actions |
| Model type-hint | e.g. `Product $record` | Same as `$record`, typed |
| `Collection` type-hint | `Collection $records` | Same as `$records` |
| `Builder` type-hint | `Builder $query` | Same as `$recordsQuery` |

### Typical action patterns

```php
// Single record action
Action::make('approve')
    ->action(fn (Order $record, array $data) => $record->approve($data['note']))

// Bulk action
BulkAction::make('export')
    ->action(fn (Collection $records) => Export::for($records)->download())

// With form data
Action::make('set_status')
    ->form([Select::make('status')->options(OrderStatus::class)])
    ->action(fn (array $data, Order $record) => $record->update($data))

// Reading/writing other fields
Action::make('generate')
    ->action(fn (Get $get, Set $set) => $set('slug', Str::slug($get('name'))))
```

---

## Get Utility

`Filament\Schemas\Components\Utilities\Get`

Callable class for reading field states within closures.

```php
// Basic usage
$get('field_name')                        // Returns the field's current value
$get('parent.child')                      // Nested path (in Repeater/Builder items)
$get('../sibling')                        // Relative parent path
$get('field', isAbsolute: true)           // Ignore current container path
```

### Relative vs Absolute paths

```php
// Inside a Repeater item, paths are relative to the item by default
Repeater::make('items')->schema([
    TextInput::make('name'),
    TextInput::make('slug')
        ->afterStateUpdated(function (Get $get, Set $set) {
            // $get('name') → reads 'name' in SAME item
            $set('slug', Str::slug($get('name')));

            // $get('../discount') → reads 'discount' from PARENT form
            // $get('discount', isAbsolute: true) → reads top-level 'discount'
        }),
])
```

---

## Set Utility

`Filament\Schemas\Components\Utilities\Set`

Callable class for updating field states within closures.

```php
$set('field_name', $value)                               // Set a field's value
$set('field', $value, shouldCallUpdatedHooks: true)      // Also fire afterStateUpdated
$set('field', $value, isAbsolute: true)                  // Absolute path
```

### Setting multiple fields

```php
->afterStateUpdated(function (Set $set, $state) {
    $set('slug', Str::slug($state));
    $set('meta_title', $state);
    $set('updated', now()->toDateTimeString());
})
```

---

## `live()` — When Closures Re-Evaluate

Closures only re-evaluate when Livewire re-renders. Use `->live()` to trigger re-renders:

```php
Select::make('type')
    ->options(['personal' => 'Personal', 'business' => 'Business'])
    ->live()                    // Re-render on every change

TextInput::make('name')
    ->live(onBlur: true)        // Re-render only when focus leaves

Select::make('country')
    ->live(debounce: 500)       // Re-render 500ms after last change
```

Without `->live()`, sibling fields that depend on `$get('type')` will NOT update reactively.

---

## `$component` / Component Self-Reference

When you need to inspect or modify the field itself:

```php
Select::make('status')
    ->placeholder(fn (Select $component): ?string =>
        $component->isDisabled() ? null : 'Select a status...'
    )

TextInput::make('email')
    ->afterStateUpdated(fn (TextInput $component, $state) =>
        $component->state(strtolower($state))
    )
```

---

## Repeater / Builder Item Context

Inside nested schema items, `$get`/`$set` paths are relative. Use `$parentRepeaterItemIndex` for the item position:

```php
Repeater::make('lines')->schema([
    TextInput::make('qty')
        ->afterStateUpdated(function (
            Get $get,
            Set $set,
            int $parentRepeaterItemIndex,
        ) {
            $unitPrice = $get('unit_price');
            $set('total', $get('qty') * $unitPrice);
        }),
])
```

---

## Related

- [../packages/schemas/layout.md](../packages/schemas/layout.md) — Get/Set utilities
- [../packages/forms/components.md](../packages/forms/components.md) — Form fields
- [../packages/actions/overview.md](../packages/actions/overview.md) — Action patterns
- [../patterns/conditional-fields.md](../patterns/conditional-fields.md) — Conditional visibility patterns
