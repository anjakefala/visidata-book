## Options

### `options-global` (`Shift+O`) for global options
  - changes affect all sheets unless overridden for a specific sheet

### `options-sheet` (`z Shift+O`) for this specific sheet


###
To set the value of an option, use Python syntax:

    options.clipboard_copy_cmd = 'xclip -selection primary'
    options.min_memory_mb = 100
    options.quitguard = True

Option names should use the underscore for word breaks.  On the command-line, underscores are converted to dashes:

    $ vd --min-memory-mb=100

The maximum option name length should be 20.


### [dev] api

To get the value of an option:

    - `foo = options.num_burgers`
    - `options['num_burgers']`
    - `options.get('num_burgers', obj)`
        - in the context of obj (sheet, SheetClass, Sheet, 'global', 'override'; extensions should use sheet or SheetClass)

    - `options.num_burgers = 40`
    - `options['num_burgers'] = 40`
        - useful for option pass-throughs

    - `options.get('num_burgers', obj)`
        - in the context of obj (sheet, SheetClass, Sheet, 'global', 'override'; extensions should use sheet or SheetClass)

Getting the current value of an option is an expensive operation.  Do not use in inner loops.

To declare an option:

    option('num_burgers', 42, 'number of burgers to use', replay=True)

To get a dict of all options starting with `foo\_` (useful for loader options):

    options('foo_')


### ref

- OptionsObject.get(k, obj)
- OptionsObject.set(k, v, obj)
- OptionsObject.getdefault(k)
   - use for options metasheets
- OptionsObject.setdefault(k)
   - options.__call__()

- option(optname, default, helpstr, replay=True)
   - optname
        - Use '\_' for a word separator.
        - all option names are in a global namespace
   - default
        - The type of the default is respected, with strings and other types being converted, and an `Exception` raised if conversion fails.  A default value of None allows any type.
   - helpstr
        - in ^H (manpage) and g^H (command list)
   - `replay` (kwarg, bool, default False) indicates if changes to the option should be stored in the command log.
        - If the option affects loading, transforming, or saving, then it replay should be True.

`theme()` should be used instead of `option()` if the option has no effect on the operation of the program, and can be overrided without affecting existing scripts.  The interfaces are identical.
Theme options should start with `disp_` and `color_` and cannot be passed on the command-line

#### lesser used

   - BaseSheet.optionsSheet
   - vd.globalOptionsShet

