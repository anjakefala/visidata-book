## Selection Commands (`select-`, `unselect-` and `stoggle-`)

Each Sheet has a set of "selected rows", which is a strict subset of the rows on the sheet. 

Here, the word 'select' means any of the three basic selection commands: select, unselect, and toggle select (called 'stoggle').

Selection commands can be undone; the previous set of selectedRows is restored.

`dup-sheet` (`g"`) also copies the set of selected rows.


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

### `selectedRows or rows`

Through v1.5.x, there was a `selectedRows or rows` idiom, which meant that the command operated on selected rows unless no rows were selected, in which case it operated on all rows.  @cwarden pointed out in #265 that this is undesirable in batch mode, when you want to depend on proper results even if they are the null set.

I. Given the same input dataset and the same commands, the default behavior of VisiData should result in the same output.

These strategies were discussed:

1. changing these into just `selectedRows` and being more consistent, at the cost of more keystrokes in somewhat common scenarios.

2. changing these into `someSelectedRows` and having it have a standard behavior, initially modified by an option.
   - thought about making it the default for batch mode, but didn't want different behavior in batch mode and interactive mode for the same dataset and commands.

3. separating the commands into -selected and -all versions, with the base command (or maybe -some) doing my preferred `selectedRows or rows` behavior.

1 makes it conceptually simple but more friction for interactive users.
2 leads to a "proliferation of options" monolith.
3 leads to a "proliferation of commands" bazaar.

Option 3 seems appealing and leaves the responsibility to the users to do the correct configuration.
But then the default behavior still has the above-stated bug.

We started out with approach 2, thinking it would be the least amount of code and the simplest; we would fail() out of the command if there were no selectedRows.
but it turns out that a) failing out does not add the command to the cmdlog, which breaks some other design choices[1][2].

I. The setcol- commands modify the "selected cells" (cells of selected rows for the current column).
  - undoEditCells, rename to undoSelectedCells

  - setcol-fill: should fill all null cells in the selected rows, with the nearest non-null entry above it.  **The non-null entry does not have to be part of the selected rowset.**  If you need this behavior, you can dup-sheet and then fill.
  - setcol-clipboard: fill selected cells


[1] the commandlog after replay should be equivalent to the commandlog being replayed up to that point (so you can save-cmdlog, replay, repeat with no loss of fidelity.

[2] if the dataset used to create a cmdlog didn't match the expressions, they would be (surprisingly) not logged and the cmdlog would be incomplete.

## Behaviour different people want

1. selectedRows or fail (replay stops if none selected)
    - commands which push new sheets
2. [cwarden] selectedRows or no-op (replay continues; no operation if none selected)
    - commands which modify selected rows
3. [spw] selectedRows or rows (operation occurs on all rows if none selected)
    - show-
    - plot-
    - reload-
4. [need to keep] selectedRows or [cursorRow] (operation occurs on cursorRow if none selected)
    - commands whose non-prefixed command does something categorically different (i.e. there is not a cursorRow version of the command)

## Command flavours
- commands which modify selected rows
    - setcol- should always/only use selectedRows
- commands which push new sheets
    - plot-  (maps)
    - dive-selected / open-rows (pushes N sheets)
    - describe-selected (from metasheet)
    - columns-selected (from metasheet)
    - dup-
    - join- (comes from metasheet)
- commands whose non-prefixed command does something categorically different
    - ColumnsSheet
        - aggregate-cols
        - type-
        - key-
    - rename-xxx-selected
    - save-macro
- clipboard
    - gd/gy erase what was previously in the clipboard
    - if it aborts, previous data is lost
    - if it no-ops that might cause problems when batch pasting afterwards

#### Mnemonics

's'elect, 't'oggle', and 'u'nselect seem straightforward, and form an alphabetic trio (s/t/u).

To me, | on the keyboard looks like a filter, with a small break in the middle, and it is used on the command-line to pipe and filter text with other programs. So | by itself selects (i.e. filters/matches) by regex in the current column.

There are only two prefixes in VisiData: g (bigger) and z (more precise). So, to select by regex in all columns, that is `g|`. Then @jsvine suggested to include select by Python expression, which to me feels like a "more precise" selection than regex, so we put it on `z|`.

On my keyboard, the `\` is on the same key as the `|` used for select, and since unselect and select are quite related, it made sense to have the reverse on the same key.
Also `|` and `\` have similar shape, and in English `\` is "backslash" or "whack", both of which imply a reversal.

And of course `g\` and `z\` work in the same way as g| and z|. So while z| and z\ may seem like random keys at first, they are actually carefully chosen.

`,` (`select-equal-cell` or 'scoop` per @whimsicalraps) "picks up" rows like the current one {inspired by Nethack).  `g,` is the natural extension to all visible cells (`equal-row`).

`zs` (`select-before`) and `gzs` (`select-after`) are not sensible and should have better bindings.


### [dev] Sheet api

## `Sheet.rowid(row)` (overrideable)

   - rows are not hashable and can't be looked up easily by content without linear (and expensive) search.
   - But id(obj) is a hashable integer which is guaranteed to be unique and constant for this object during its lifetime.
   - We store id(row) as the keys in a dict pointing to the row itself (is this convenience used?)
   - this makes selection/unselection and checking for selection, have the same cost as set add/remove/check
   - select/unselect/stoggle all are now O(n log n), whereas they could have been O(n) if selection were in e.g. a parallel array, or an attribute on the row.

- `Sheet.isSelected(row)` (O(log nSelected))
- `Sheet.gatherBy(func(row))` (O(nRows))
- `Sheet.selectedRows` (O(nRows))
    - must be computed bc `_selectedRows.values()`are not sorted in sheet order.
    - a list in the same order as .rows
- `Sheet.nSelected` (O(k))



- `Sheet.selectRow(row)` (overrideable)
- `Sheet.unselectRow(row)` (overrideable)
   - returns True if it was selected and is now unselected

- `Sheet.selectByIdx(rowIndexes)`
- `Sheet.unselectByIdx(rowIndexes)`

- `Sheet.select(rows)` (async, status=True, progress=True)
- `Sheet.toggle(rows)` (async)
- `Sheet.unselect(rows)` (async)

- `Sheet.unselectAll(row)` (O(k))

- `Sheet.deleteSelected`  (async)

#### [dev api] undo actions for selection commands

- `undoSheetSelection`
- `undoSelection(sheetstr)`

