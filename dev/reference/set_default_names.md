# Set new default names to a plume subclass

This function allows you to set new default names to a plume subclass,
for example to set default names to a language other than English.

## Usage

``` r
set_default_names(..., .plume_quarto = FALSE)
```

## Arguments

- ...:

  Key-value pairs where keys are default names and values their
  respective replacements.

- .plume_quarto:

  Are you setting new names for
  [`PlumeQuarto`](https://arnaudgallou.github.io/plume/dev/reference/PlumeQuarto.md)?

## Value

A named list.

## Details

See
[`vignette("plume")`](https://arnaudgallou.github.io/plume/dev/articles/plume.md)
for the list of available names.

## Examples

``` r
# Extending `Plume` with default names in French
PlumeFr <- R6::R6Class(
  classname = "PlumeFr",
  inherit = Plume,
  private = list(
    names = set_default_names(
      initials = "initiales",
      literal_name = "nom_complet",
      corresponding = "correspondant",
      given_name = "prénom",
      family_name = "nom",
      email = "courriel",
      phone = "téléphone"
    )
  )
)

PlumeFr$new(encyclopedists_fr)
#> # A tibble: 4 × 11
#>      id prénom  nom   nom_complet initiales orcid courriel téléphone role  note 
#>   <int> <chr>   <chr> <chr>       <chr>     <chr> <chr>    <chr>     <chr> <chr>
#> 1     1 Denis   Dide… Denis Dide… D.D.      0000… diderot… +1234     Supe… né e…
#> 2     2 Jean-J… Rous… Jean-Jacqu… J.-J.R.   0000… roussea… NA        NA    NA   
#> 3     3 Franço… Arou… François-M… F.-M.A.   NA    arouet@… NA        NA    dit …
#> 4     4 Jean    Le R… Jean Le Ro… J.L.R.d'… 0000… alember… NA        Supe… né e…
#> # ℹ 1 more variable: affiliation <list>
```
