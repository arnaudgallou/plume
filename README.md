
<!-- README.md is generated from README.Rmd. Please edit that file -->

# plume

<!-- badges: start -->

[![R-CMD-check](https://github.com/arnaudgallou/plume/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/arnaudgallou/plume/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/arnaudgallou/plume/branch/main/graph/badge.svg)](https://app.codecov.io/gh/arnaudgallou/plume?branch=main)
<!-- badges: end -->

## Overview

plume provides tools for handling and generating author-related
information for scientific writing in R Markdown and Quarto. The package
implements two `R6` classes:

- `Plume`: class that generates author lists and other author-related
  information from tabular data.

- `PlumeQuarto`: class extending `Plume` that allows you to push or
  update author metadata in the YAML header of a Quarto file. The
  generated YAML complies with [Quarto’s author and affiliations
  schemas](https://quarto.org/docs/journals/authors.html).

## Installation

You can install the development version of plume from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("arnaudgallou/plume")
```

## Usage

The minimal required data to work with plume classes is a data set
containing given and family names but you would normally want to provide
more information such as email addresses, ORCIDs, affiliations, etc.

``` r
library(plume)

encyclopedists
#> # A tibble: 4 × 11
#>   given_name     family_name        email  phone contribution_n1 contribution_n2
#>   <chr>          <chr>              <chr>  <chr> <chr>           <chr>          
#> 1 Denis          Diderot            dider… 00 0… Writing         Supervision    
#> 2 Jean-Jacques   Rousseau           rouss… <NA>  Writing         <NA>           
#> 3 François-Marie Arouet             aroue… <NA>  Writing         <NA>           
#> 4 Jean           Le Rond d'Alembert alemb… <NA>  Writing         Supervision    
#> # ℹ 5 more variables: contribution_v1 <chr>, contribution_v2 <chr>, note <chr>,
#> #   affiliation1 <chr>, affiliation2 <chr>

aut <- PlumeQuarto$new(encyclopedists)
aut
#> # A tibble: 4 × 10
#>      id given_name     family_name       literal_name initials email phone note 
#>   <int> <chr>          <chr>             <chr>        <chr>    <chr> <chr> <chr>
#> 1     1 Denis          Diderot           Denis Dider… DD       dide… 00 0… born…
#> 2     2 Jean-Jacques   Rousseau          Jean-Jacque… J-JR     rous… <NA>  <NA> 
#> 3     3 François-Marie Arouet            François-Ma… F-MA     arou… <NA>  also…
#> 4     4 Jean           Le Rond d'Alembe… Jean Le Ron… JLRA     alem… <NA>  born…
#> # ℹ 2 more variables: affiliation <list>, contribution <list>
```

`PlumeQuarto` lets you push author metadata in the YAML header of any
`.qmd` files using `to_yaml()`.

Consider the following example:

    ---
    title: Encyclopédie
    ---

    Qui scribit bis legit

``` r
aut$set_corresponding_authors(1, 4)
aut$to_yaml("file.qmd")
```

    ---
    title: Encyclopédie
    author:
      - id: aut1
        name:
          given: Denis
          family: Diderot
        email: diderot@encyclopediste.fr
        phone: 00 00 00 01
        note: born in 1713 in Langres
        attribute:
          corresponding: true
        affiliations:
          - ref: aff1
      - id: aut2
        name:
          given: Jean-Jacques
          family: Rousseau
        email: rousseau@encyclopediste.fr
        attribute:
          corresponding: false
        affiliations:
          - ref: aff2
      - id: aut3
        name:
          given: François-Marie
          family: Arouet
        email: arouet@encyclopediste.fr
        note: also known as Voltaire
        attribute:
          corresponding: false
        affiliations:
          - ref: aff2
      - id: aut4
        name:
          given: Jean
          family: Le Rond d'Alembert
        email: alembert@encyclopediste.fr
        note: born in 1717 in Paris
        attribute:
          corresponding: true
        affiliations:
          - ref: aff1
          - ref: aff3
    affiliations:
      - id: aff1
        name: Université de Paris
      - id: aff2
        name: Lycée Louis-le-Grand
      - id: aff3
        name: Collège des Quatre-Nations
    ---

    Qui scribit bis legit

You can also generate author information as character strings:

``` r
aut <- Plume$new(encyclopedists, names = c(contribution = "contribution_n"))
aut$set_corresponding_authors(diderot, by = "family_name")

aut$get_author_list(format = "^a,^cn") |> enumerate(last = ",\n")
#> Denis Diderot^1,^\*†, Jean-Jacques Rousseau^2^, François-Marie Arouet^2^‡,
#> Jean Le Rond d'Alembert^1,3^§

aut$get_contact_details()
#> Denis Diderot: diderot@encyclopediste.fr

aut$get_affiliations()
#> ^1^Université de Paris
#> ^2^Lycée Louis-le-Grand
#> ^3^Collège des Quatre-Nations

aut$get_notes()
#> ^†^born in 1713 in Langres
#> ^‡^also known as Voltaire
#> ^§^born in 1717 in Paris

aut$get_contributions()
#> Writing: D.D., J.-J.R., F.-M.A. and J.L.R.A.
#> Supervision: D.D. and J.L.R.A.

aut_v <- Plume$new(
  encyclopedists,
  names = c(contribution = "contribution_v"),
  symbols = list(affiliation = letters)
)

aut_v$get_author_list(format = "^a^") |> enumerate(last = ",\n")
#> Denis Diderot^a^, Jean-Jacques Rousseau^b^, François-Marie Arouet^b^,
#> Jean Le Rond d'Alembert^a,c^

aut_v$get_contributions(role_first = FALSE, name_list = TRUE)
#> D.D., J.-J.R., F.-M.A. and J.L.R.A. contributed to the Encyclopédie
#> D.D. and J.L.R.A. supervised the project
```

## Acknowledgements

Thanks to [Richard J. Telford](https://github.com/richardjtelford) for
his advice that helped me conceive this package.
