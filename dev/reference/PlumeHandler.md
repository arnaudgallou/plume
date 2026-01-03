# PlumeHandler class

Internal class processing and shaping tabular data into a plume object.

## Super class

`plume::NameHandler` -\> `PlumeHandler`

## Methods

### Public methods

- [`PlumeHandler$new()`](#method-PlumeHandler-new)

- [`PlumeHandler$print()`](#method-PlumeHandler-print)

- [`PlumeHandler$data()`](#method-PlumeHandler-data)

- [`PlumeHandler$get_plume()`](#method-PlumeHandler-get_plume)

- [`PlumeHandler$roles()`](#method-PlumeHandler-roles)

- [`PlumeHandler$get_roles()`](#method-PlumeHandler-get_roles)

- [`PlumeHandler$clone()`](#method-PlumeHandler-clone)

------------------------------------------------------------------------

### Method `new()`

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

### Method [`print()`](https://rdrr.io/r/base/print.html)

#### Usage

    PlumeHandler$print()

------------------------------------------------------------------------

### Method [`data()`](https://rdrr.io/r/utils/data.html)

Get the data of a plume object.

#### Usage

    PlumeHandler$data()

#### Returns

A tibble.

------------------------------------------------------------------------

### Method `get_plume()`

**\[deprecated\]**

Please use `$data()` instead.

#### Usage

    PlumeHandler$get_plume()

#### Returns

A tibble.

------------------------------------------------------------------------

### Method `roles()`

Get the roles used in a plume object.

#### Usage

    PlumeHandler$roles()

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `get_roles()`

**\[deprecated\]**

Please use `$roles()` instead.

#### Usage

    PlumeHandler$get_roles()

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    PlumeHandler$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
