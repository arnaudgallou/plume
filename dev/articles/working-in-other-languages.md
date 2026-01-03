# Working in other languages

If you work in a language other than English, you can extend plume
classes with default names in your desired language. plume provides
[`set_default_names()`](https://arnaudgallou.github.io/plume/dev/reference/set_default_names.md)
to help you set new default names.

For example, to extend `Plume` with default names in French:

``` r
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
```

``` r
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

You can also override the default arguments of some methods to match
your language. Expanding on the example above, we can add a new
`get_contributions()` method to replace the default arguments of the
`divider` and `sep_last` parameters:

``` r
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
  ),
  public = list(
    get_contributions = function(
      roles_first = TRUE,
      by_author = FALSE,
      alphabetical_order = FALSE,
      literal_names = FALSE,
      divider = " : ",
      sep = ", ",
      sep_last = " et "
    ) {
      super$get_contributions(
        roles_first = roles_first,
        by_author = by_author,
        alphabetical_order = alphabetical_order,
        literal_names = literal_names,
        divider = divider,
        sep = sep,
        sep_last = sep_last
      )
    }
  )
)
```

``` r
aut <- PlumeFr$new(
  encyclopedists_fr,
  roles = c(supervision = "Supervision", rédaction = "Rédaction")
)
aut$get_contributions()
#> Supervision : D.D. et J.L.R.d'A.
#> Rédaction : D.D., J.-J.R., F.-M.A. et J.L.R.d'A.
```
