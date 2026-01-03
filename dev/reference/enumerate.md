# Enumerate vector elements

Wrapper around
[`glue_collapse()`](https://glue.tidyverse.org/reference/glue_collapse.html)
using `sep = ", "` and `last = " and "` as default arguments.

## Usage

``` r
enumerate(x, sep = ", ", last = " and ")
```

## Arguments

- x:

  A character vector.

- sep:

  Separator used to separate the terms.

- last:

  Separator used to separate the last two items if `x` has at least 2
  items.

## Value

A character string with the same class as `x`.

## Examples

``` r
aut <- Plume$new(encyclopedists)
enumerate(aut$get_author_list())
#> Denis Diderot, Jean-Jacques Rousseau, François-Marie Arouet and Jean Le Rond d'Alembert
```
