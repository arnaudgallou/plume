# Set symbols for `Plume`

Set the symbols used in a
[`Plume`](https://arnaudgallou.github.io/plume/dev/reference/Plume.md)
object.

## Usage

``` r
plm_symbols(
  affiliation = NULL,
  corresponding = "*",
  note = c("†", "‡", "§", "¶", "#", "**")
)
```

## Arguments

- affiliation, corresponding, note:

  Character vectors of symbols to use, or `NULL` to use numerals.

## Value

A named list.

## Examples

``` r
aut <- Plume$new(
  encyclopedists,
  symbols = plm_symbols(affiliation = letters)
)
aut$get_author_list("^a^")
#> Denis Diderot^a^
#> Jean-Jacques Rousseau^b^
#> François-Marie Arouet^b^
#> Jean Le Rond d'Alembert^a,c^
```
