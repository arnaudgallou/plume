# PlumeHandler class

Internal class processing and shaping tabular data into a plume object.

## Super class

`NameHandler` -\> `PlumeHandler`

## Methods

### Public methods

- [`PlumeHandler$new()`](#method-PlumeHandler-initialize)

- [`PlumeHandler$print()`](#method-PlumeHandler-print)

- [`PlumeHandler$data()`](#method-PlumeHandler-data)

- [`PlumeHandler$get_plume()`](#method-PlumeHandler-get_plume)

- [`PlumeHandler$roles()`](#method-PlumeHandler-roles)

- [`PlumeHandler$get_roles()`](#method-PlumeHandler-get_roles)

- [`PlumeHandler$clone()`](#method-PlumeHandler-clone)

------------------------------------------------------------------------

### `PlumeHandler$new()`

#### Usage

    PlumeHandler$new(
      data,
      names,
      roles,
      credit_roles,
      initials_given_name,
      dotted_initials,
      family_name_first = FALSE,
      distinct_initials = FALSE,
      interword_spacing = TRUE
    )

------------------------------------------------------------------------

### `PlumeHandler$print()`

#### Usage

    PlumeHandler$print()

------------------------------------------------------------------------

### `PlumeHandler$data()`

Get the data of a plume object.

#### Usage

    PlumeHandler$data()

#### Returns

A tibble.

------------------------------------------------------------------------

### `PlumeHandler$get_plume()`

**\[deprecated\]**

Please use `$data()` instead.

#### Usage

    PlumeHandler$get_plume()

#### Returns

A tibble.

------------------------------------------------------------------------

### `PlumeHandler$roles()`

Get the roles used in a plume object.

#### Usage

    PlumeHandler$roles()

#### Returns

A character vector.

------------------------------------------------------------------------

### `PlumeHandler$get_roles()`

**\[deprecated\]**

Please use `$roles()` instead.

#### Usage

    PlumeHandler$get_roles()

#### Returns

A character vector.

------------------------------------------------------------------------

### `PlumeHandler$clone()`

The objects of this class are cloneable with this method.

#### Usage

    PlumeHandler$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
