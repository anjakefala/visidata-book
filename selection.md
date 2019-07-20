## Selection Commands (`select-`, `unselect-` and `stoggle-`)

Each Sheet has a set of "selected rows", which is a strict subset of the rows on the sheet. 

Here, the word 'select' means any of the three basic selection commands: select, unselect, and toggle select (called 'stoggle').

Selection commands can be undone; the previous set of selectedRows is restored.

`dup-sheet` (g") also copies the set of selected rows.


Aside from the base s/t/u commands, which select only the current row, most selections are 'bulk selections'.   Bulk selections can change the selection status of an arbitrary number of rows, possibly being 1 or even 0 rows.

By default, row selections are additive; selection/unselection/stoggling are applied in order of the commands issued, and so multiple selections create a union of all selections.  The status message includes 'more' as to tell you if there were previously selected messages.

### `options.bulk_select_clear` (False; replayable)
{suggested by @cwarden}

To clear the set of selected rows before any bulk selection, set this option to True.  The status message includes 'instead' as a remind that the option is enabled.

### Select by Regex (`select-col-regex` and `select-cols-regex`)

- col- is this coluimn, cols- is all visible columns

- history shared with other `regex` commands

### Select by Python Expr (`select-expr)`

### Select Rows matching the cursor row
#### `select-equal-cell`: match only in the cursor column
#### `select-equal-row`: match in all visible columns

#### Mnemonics

To me, | on the keyboard looks like a filter, with a small break in the middle, and it is used on the command-line to pipe and filter text with other programs. So | by itself selects (i.e. filters/matches) by regex in the current column.

There are only two prefixes in VisiData: g (bigger) and z (more precise). So, to select by regex in all columns, that is `g|`. Then @jsvine suggested to include select by Python expression, which to me feels like a "more precise" selection than regex, so we put it on `z|`.

On my keyboard, the `\` is on the same key as the `|` used for select, and since unselect and select are quite related, it made sense to have the reverse on the same key.
Also `|` and `\` have similar shape, and in English `\` is "backslash" or "whack", both of which imply a reversal.

And of course `g\` and `z\` work in the same way as g| and z|. So while z| and z\ may seem like random keys at first, they are actually carefully chosen.

`,` (`select-equal-cell` or 'scoop` per @whimsicalraps) "picks up" rows like the current one {inspired by Nethack).  `g,` is the natural extension to all visible cells (`equal-row`).

`zs` (`select-before`) and `gzs` (`select-after`) are not sensible and should have better bindings.


### [dev] 

- `Sheet.isSelected(row)` (O(log nSelected))
- `Sheet.gatherBy(func(row))` (O(nRows))
- `Sheet.selectedRows` (O(nRows))
- `Sheet.nSelected` (O(1))



- `Sheet.selectRow(row)` (overrideable)
- `Sheet.unselectRow(row)` (overrideable)
   - returns True if it was selected and is now unselected

- `Sheet.selectByIdx(rowIndexes)`
- `Sheet.unselectByIdx(rowIndexes)`

- `Sheet.select(rows)` (async, status=True, progress=True)
- `Sheet.toggle(rows)` (async)
- `Sheet.unselect(rows)` (async)

- `Sheet.unselectAll(row)`
   - helper to do in O(1)

- `undoSheetSelection`
- `undoSelection(sheetstr)`

- `Sheet.deleteSelected`  (async)

### [dev] undo actions for selection commands

- undoSheetSelection
- undoSelection

- .selectedRows is in the same order as .row
### - select by regex
- select by python expr

- [dev] rowid()
    - rows are not hashable and can't be looked up easily by content without linear (and expensive) search.
    - But id(obj) is a hashable integer which is guaranteed to be unique and constant for this object during its lifetime.
    - We store id(row) as the keys in a dict pointing to the row itself (is this convenience used?)
    - this makes selection/unselection and checking for selection, have the same cost as set add/remove/check
    - Sheet.selectedRows has to be computed bc `_selectedRows.values()`are not sorted in sheet order. This is O(n).
    - select/unselet/toggle all are now O(n log n), whereas they could have been O(n) if selection were in e.g. a parallel array, or an attribute on the row.

