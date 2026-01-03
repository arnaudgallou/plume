# CRediT roles

Helper function returning the 14 contributor roles of the [Contributor
Roles Taxonomy](https://credit.niso.org) (CRediT). This function is the
default argument of the `roles` and `role_cols` parameters in plume
classes and
[`plm_template()`](https://arnaudgallou.github.io/plume/dev/reference/plm_template.md),
respectively.

## Usage

``` r
credit_roles(oxford_spelling = TRUE)
```

## Arguments

- oxford_spelling:

  Should the suffix -ize/-ization be used?

## Value

A named vector.

## Examples

``` r
credit_roles()
#>            conceptualization                data_curation 
#>          "Conceptualization"              "Data curation" 
#>                     analysis                      funding 
#>            "Formal analysis"        "Funding acquisition" 
#>                investigation                  methodology 
#>              "Investigation"                "Methodology" 
#>               administration                    resources 
#>     "Project administration"                  "Resources" 
#>                     software                  supervision 
#>                   "Software"                "Supervision" 
#>                   validation                visualization 
#>                 "Validation"              "Visualization" 
#>                      writing                      editing 
#>   "Writing - original draft" "Writing - review & editing" 
```
