## Extensibility

One of VisiData's core design goals is *extensibility*.
The core data paradigm and command set are very useful, and moreso in combination.
Many of the features can exist in isolation, and can be enabled or disabled independently, without affecting other features.

So VisiData provides many features in a modular form.
These features can be enabled by importing the module, or disabled by not importing it.
Modules should degrade or fail gracefully if they depend on another module which has not been imported.

### class Extensible

Python classes normally declare and implement all methods and members in the class definition, which exists in a single source file.

Using import as the enable mechanism, means that features should be self contained within a source file.
Python allows monkey-patching <a href='#b1' name='a'><sup>1</sup></a>, which is useful for exactly this purpose of modular extensions.

VisiData achieves this with the `Extensible` class, which a few core classes inherit from.  Extensible provides some helper functions to allow these core classes to be monkey-patched easily and consistently.

#### Scope

The core classes that are Extensible are VisiData, BaseSheet, and Column.
All of their subclasses are then also naturally Extensible.

`Sheet` (a subclass of BaseSheet) is used in the following examples, but any other Extensible class would work similarly.

#### `Extensible.init(membername, constructor, copy=False)`

If a module wants to store some data on an Extensible class, it can add a member with a call to that class' `init()`:

    Sheet.init('foo', dict)

This monkey-patches `Sheet.__init__` to add the instance member `foo` to every Sheet on construction, and to initialize it with an empty dict.
To provide an initial non-object value:

    Sheet.init('bar', lambda: 42)

This member can then be used like any other member of the class.

By default, when an instance of the class is copied, a member specified with this `init()` is reset to a newly constructed value (by calling the constructor again).
If `copy` is True, then a copy is made of the member for the new instance.

#### `@Extensible.api`

This decorator defines a member function on the specific class:

    @Sheet.api
    def foobar(sheet, ...):
        ...

Because this is a member function, the first parameter is the instance itself.
If this function were defined in the class, the first parameter would be named `self` by Python convention.
When members are defined in other files, a well-known name for the instance type is used instead of `self`:

    @VisiData.api
    def member1(vd, ...):

    @Column.api
    def member3(col, ...):

`Extensible.api` can be used either to add new member functions, or to override existing members.
To call the original function, use `func.__wrapped__`:

    @Sheet.api
    def addRow(sheet, row):
        # do something first
        addRow.__wrapped__(sheet, row)

#### `@Extensible.class_api`

`@class_api` works much like `@api`, but for class methods:

    @Sheet.class_api
    @classmethod
    def addCommand(cls, ...):

This is used internally but may not be all that useful for plugin and module authors.
Note that `@classmethod` must still be provided.

#### `@Extensible.property`

This acts just like an `@property` decorator, if it were defined inline to the class.

#### `@Extensible.cached_property`

## Footnotes
<a name='b1' href='#a1'>1.</a> Monkey patching is adding new functionality to a module or class definition after the program started running.
