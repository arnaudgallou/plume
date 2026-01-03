# Select all authors or exclude some from a selection

Selection helpers to use in conjonction with status setter methods (i.e.
methods that assign a status to authors with either `TRUE` or `FALSE`):

- `everyone()` select all authors.

- `everyone_but()` **\[deprecated\]** this function was deprecated as I
  believe it is not necessary since not more than a couple of authors
  should normally be given a particular status.

## Usage

``` r
everyone()

everyone_but(...)
```

## Arguments

- ...:

  One or more unquoted expressions separated by commas. Expressions
  matching values in the column defined by the `by` or `.by` parameter
  are used to set a given status to authors. Matching of values is case-
  insensitive and dot-agnostic.

## Examples

``` r
aut <- Plume$new(encyclopedists)

aut$set_corresponding_authors(everyone())
dplyr::select(aut$data(), 1:3, corresponding)
#> # A tibble: 4 × 4
#>      id given_name     family_name        corresponding
#>   <int> <chr>          <chr>              <lgl>        
#> 1     1 Denis          Diderot            TRUE         
#> 2     2 Jean-Jacques   Rousseau           TRUE         
#> 3     3 François-Marie Arouet             TRUE         
#> 4     4 Jean           Le Rond d'Alembert TRUE         
```
