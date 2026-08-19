# StatusSetter class

Internal class that manages authors' status.

## Super classes

`NameHandler` -\>
[`PlumeHandler`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.md)
-\> `StatusSetter`

## Methods

### Public methods

- [`StatusSetter$new()`](#method-StatusSetter-initialize)

- [`StatusSetter$set_corresponding_authors()`](#method-StatusSetter-set_corresponding_authors)

- [`StatusSetter$clone()`](#method-StatusSetter-clone)

Inherited methods

- [`PlumeHandler$data()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-data)
- [`PlumeHandler$get_plume()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_plume)
- [`PlumeHandler$get_roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_roles)
- [`PlumeHandler$print()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-print)
- [`PlumeHandler$roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-roles)

------------------------------------------------------------------------

### `StatusSetter$new()`

#### Usage

    StatusSetter$new(..., by)

------------------------------------------------------------------------

### `StatusSetter$set_corresponding_authors()`

Set corresponding authors.

#### Usage

    StatusSetter$set_corresponding_authors(..., .by = NULL, by = deprecated())

#### Arguments

- `...`:

  One or more unquoted expressions separated by commas. Expressions
  matching values in the column defined by `by` or `.by` determine
  corresponding authors. Matching of values is case-insensitive and
  dot-agnostic.

- `.by`:

  Variable used to set corresponding authors. By default, uses authors'
  id.

- `by`:

  **\[deprecated\]**

  Please use the `.by` parameter instead.

#### Returns

The class instance.

------------------------------------------------------------------------

### `StatusSetter$clone()`

The objects of this class are cloneable with this method.

#### Usage

    StatusSetter$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
