# StatusSetterPlume class

Internal class extending `StatusSetter` for `Plume`.

## Super classes

`NameHandler` -\>
[`PlumeHandler`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.md)
-\>
[`StatusSetter`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.md)
-\> `StatusSetterPlume`

## Methods

### Public methods

- [`StatusSetterPlume$set_main_contributors()`](#method-StatusSetterPlume-set_main_contributors)

- [`StatusSetterPlume$clone()`](#method-StatusSetterPlume-clone)

Inherited methods

- [`PlumeHandler$data()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-data)
- [`PlumeHandler$get_plume()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_plume)
- [`PlumeHandler$get_roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_roles)
- [`PlumeHandler$print()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-print)
- [`PlumeHandler$roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-roles)
- [`StatusSetter$initialize()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.html#method-initialize)
- [`StatusSetter$set_corresponding_authors()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.html#method-set_corresponding_authors)

------------------------------------------------------------------------

### `StatusSetterPlume$set_main_contributors()`

Force one or more contributors' names to appear first in the
contribution list.

#### Usage

    StatusSetterPlume$set_main_contributors(..., .roles = NULL, .by = NULL)

#### Arguments

- `...`:

  One or more unquoted expressions separated by commas. Expressions
  matching values in the column defined by `by` or `.by` determine main
  contributors. Expressions can be named after any role to set different
  main contributors to different roles at once, in which case the
  `.roles` parameter only applies roles that are not already set to
  unnamed expressions. Matching of values is case-insensitive and dot-
  agnostic.

- `.roles`:

  Roles to assign main contributors to. If `.roles` is a named vector,
  only the names will be used.

- `.by`:

  Variable used to specify which authors are main contributors. By
  default, uses authors' id.

#### Returns

The class instance.

------------------------------------------------------------------------

### `StatusSetterPlume$clone()`

The objects of this class are cloneable with this method.

#### Usage

    StatusSetterPlume$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
