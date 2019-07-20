## VisiData Pipeline

VisiData opens some sources, executes a set of commands, and then outputs the top sheet.

This is like ETL.

Each of one of these stages, though, incorporates a tremendous amount of diversity, without much additional complexity:

E: open sources
  - read tables from files, http, databases, apis, system libraries: 63+ sources and counting!

T: execute a set of commands

The default mode of VisiData is interactive, but executing the same commands from a script will yield identical results.

Use `-b -p <script.vd>` to play a set of commands from a script in non-interactive (batch) mode.
.vd is the default extension for VisiData scripts.

L: output top sheet if output specified
  - `-o file` to send to a file
  - `-o -` to send to stdout (default if stdout redirected)

The output can be in any of the saving file formats, 14 and counting!
`options.save_filetype` or determined by the file extension.


### File Format Conversion is a Null Pipeline

`-b` can be used without `-p`, to omit the replay commands (Transform) stage.

Since the data can be loaded and saved in a number of formats, this means that VisiData's batch mode degenerates into a straightforward conversion utility.

    vd foo.json -b -o foo.csv
    vd -f fixed olddata -b -o bar.html

### Interactive Pipelines (without `-b`)

#### open sources

filenames or urls passed on the command line, or data piped in (use `-f <filetype>` to indicate format).

additional sources can also be specified in replayed command log.

#### `-p` (replay)

- all commands replayed live, with optional `-w` wait time.
- user takes control and does whatever interactively

#### `-o` <output.ext>
   - `Ctrl+Q` aborts immediately and outputs the top sheet
   - `q` or `gq` pop those sheets off the stack
   - it is important to have the two modes of exit, to distinguish when to emit and when not to.
   - [alt design] if you asked for output, it's reasonable to think you expected it and would want that to be the default, and that `Ctrl+Q` is an extra shift key to abort.
