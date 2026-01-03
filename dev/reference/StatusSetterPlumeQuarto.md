# StatusSetterPlumeQuarto class

Internal class extending `StatusSetter` for `PlumeQuarto`.

## Super classes

`plume::NameHandler` -\>
[`plume::PlumeHandler`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.md)
-\>
[`plume::StatusSetter`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.md)
-\> `StatusSetterPlumeQuarto`

## Methods

### Public methods

- [`StatusSetterPlumeQuarto$set_cofirst_authors()`](#method-StatusSetterPlumeQuarto-set_cofirst_authors)

- [`StatusSetterPlumeQuarto$set_equal_contributor()`](#method-StatusSetterPlumeQuarto-set_equal_contributor)

- [`StatusSetterPlumeQuarto$set_deceased()`](#method-StatusSetterPlumeQuarto-set_deceased)

- [`StatusSetterPlumeQuarto$clone()`](#method-StatusSetterPlumeQuarto-clone)

Inherited methods

- [`plume::PlumeHandler$data()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-data)
- [`plume::PlumeHandler$get_plume()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_plume)
- [`plume::PlumeHandler$get_roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_roles)
- [`plume::PlumeHandler$print()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-print)
- [`plume::PlumeHandler$roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-roles)
- [`plume::StatusSetter$initialize()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.html#method-initialize)
- [`plume::StatusSetter$set_corresponding_authors()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.html#method-set_corresponding_authors)

------------------------------------------------------------------------

### Method `set_cofirst_authors()`

Set co-first authors.

#### Usage

    StatusSetterPlumeQuarto$set_cofirst_authors(..., .by = NULL)

#### Arguments

- `...`:

  One or more unquoted expressions separated by commas. Expressions
  matching values in the column defined by `by` or `.by` determine
  co-first authors. Matching of values is case-insensitive and
  dot-agnostic.

- `.by`:

  Variable used to specify which authors contributed equally to the
  work. By default, uses authors' id.

#### Returns

The class instance.

------------------------------------------------------------------------

### Method `set_equal_contributor()`

**\[deprecated\]**

This method has been deprecated in favour of `set_cofirst_authors()`.

#### Usage

    StatusSetterPlumeQuarto$set_equal_contributor(
      ...,
      .by = NULL,
      by = deprecated()
    )

#### Arguments

- `...`:

  One or more unquoted expressions separated by commas. Expressions
  matching values in the column defined by `by`/`.by` determine equal
  contributors. Matching of values is case-insensitive.

- `.by`:

  Variable used to specify which authors are equal contributors. By
  default, uses authors' id.

- `by`:

  **\[deprecated\]**

  Please use the `.by` parameter instead.

#### Returns

The class instance.

------------------------------------------------------------------------

### Method `set_deceased()`

Set deceased authors.

#### Usage

    StatusSetterPlumeQuarto$set_deceased(..., .by = NULL, by = deprecated())

#### Arguments

- `...`:

  One or more unquoted expressions separated by commas. Expressions
  matching values in the column defined by `by` or `.by` determine
  deceased authors. Matching of values is case-insensitive and
  dot-agnostic.

- `.by`:

  Variable used to specify whether an author is deceased or not. By
  default, uses authors' id.

- `by`:

  **\[deprecated\]**

  Please use the `.by` parameter instead.

#### Returns

The class instance.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    StatusSetterPlumeQuarto$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
