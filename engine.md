### Values

This is the heart of the VisiData calculation engine.
Each column can **calculate** a value from a row object; and it might also be able to **put** a different value into the row object (for a later calculate to derive).

    FooColumn.calcValue(row): returns raw value
    FooColumn.putValue(row, val): undefined return

Column subclasses can override these methods to define their fundamental interaction with the row object.
This is often the only thing a Column subclass has to do.

These functions should not generally be called by application code.  Instead, apps and plugins should call:

    Column.getValue(row)
    Column.setValue(row, val)

These provide a caching layer above calcValue and putValue.

- set Column.cache in init, or setCache
  - `options.col_cache_size`
    - if cache=False, getValue never caches
    - if cache=True, getValue caches the result
    - if cache='async', getValue will spawn a thread for every to cache the result, and return the Thread/None until then.


- `calcValue` may be arbitrarily expensive or even asynchronous, so once it is calculated, the value is stored (in `_cachedValues`)until `Column.recalc()` is called.
- `putValue` may modify the source data directly (for instance, if the row object represents a row in a database table).  VisiData will *never* modify source data without an explicit `save` command.  So applications (and all other code) must call `setValue` to change the value of any cell.

Other notes:

- to "delete" a cell, call setValue with None
- Column.recalc() to reset its cache

### Typed Values

The core value behind any given cell could be:
   - a string
   - numerically typed
   - a list or dict
   - None
   - a null value (according to `options.null_value`)
   - Exception (error getting)
   - Thread (async pending)
   - any python object

This core value may need to be converted to a consistent type, necessary for sorting, numeric binning, and more.

The default column type is anytype, which lets the underlying value pass through unaltered; this is the only type for which a column can have heterogenous value types.

The user can set the type of a column, which is a function which takes the underlying value and returns a specific type.  This function should accept a string and do a reasonable conversion, like `int` and `float` do.
And like those builtin types, this function should produce a reasonable baseline arithmetic identity when passed no parameters (or None).

Applications should generally call getTypedValue to get this typed valued:

    Column.getTypedValue(row)

If the underlying value is None, the result will be a TypedWrapper, which provides the baseline value
for purposes of comparison, but a stringified version of the underlying value for display.
For a `calcValue` which raises or returns an Exception, getTypedValue will return a TypedExceptionWrapper with similar behavior.

### Display Values

    Column.getDisplayValue

    Column.format(typedval)
      - type.formatter(fmtstr, typedval)

### Cells

Returns the DisplayWrapper, the whole kit'n'caboodle used directly by Sheet.draw()

    Column.getCell(row): DisplayWrapper

DisplayWrapper
- value: underlying value, before typing
- display: formatted to be displayed directly in the cell (including space
- note: one-character visual tag for the cell
- notecolor: `color_foo` applied to the note
- error: list of strings (a stack trace)

### Saver Values

Savers which can handle typed values should use getTypedValue, and displayable savers (html, markdown, csv) should use getDisplayValue() (which takes into account the fmtstr).
    `fmtstr`
