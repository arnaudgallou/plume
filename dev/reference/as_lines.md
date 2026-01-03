# Print vector elements on distinct lines

Thin wrapper around [`cat()`](https://rdrr.io/r/base/cat.html) to
display vector elements on distinct lines when rendering an R Markdown
or Quarto document.

## Usage

``` r
as_lines(...)
```

## Arguments

- ...:

  Objects to print.

## Value

`NULL`, invisibly.

## Examples

``` r
aut <- Plume$new(encyclopedists)
as_lines(aut$get_affiliations())
#> ^1^Université de Paris
#> 
#> ^2^Lycée Louis-le-Grand
#> 
#> ^3^Collège des Quatre-Nations
```
