
### Passthrough options

Loaders which use a Python library (internal or external) are encouraged to pass all options to it through the `options("foo_")`.  For modules like csv which expose them as kwargs to some function or constructor, this is very easy:

    rdr = csv.reader(fp, **csvoptions())

## specific loaders

### csv

The `csv_` options themselves are from https://docs.python.org/3/library/csv.html#csv-fmt-params
