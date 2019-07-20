## Settings

Options, Commands, and Key Bindings are all settings that are managed in a similar way.
They can each effectively be set, in order of lowest precedence to highest:

- globally
- for all types of tabular Sheets,
- for a specific type of derived Sheet,
- from the command-line
- at runtime via sheet-options for a specific sheet

### .visidatarc

Options and other settings can be set in .visidatarc as simple Python:

   `options.min_memory_mb = 50`

All Python code in .visidatarc is executed and made available to column expressions and other components.

### `open-config` (`g Shift+O`) opens the .visidatarc file for editing

{see commands.md}

### [dev] settings api

- loadConfigFile(fnrc)

These are all valid contexts:

- `options.foo`: get in context of current sheet; set for runtime override ('override')
- `vd.options.foo`: get in context of current sheet; set as global default ('global')
- `sheet.options.foo`: get and set in context of given sheet
- `Sheet.options.foo`: plugins without Sheet subclasses can use change VisiData Sheet defaults
- `TsvSheet.option("tsv_optnam", 'default', 'default string for tsv')
   - define option and give it default and helpstr

