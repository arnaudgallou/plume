# Create a table template for plume classes

Create an empty
[tibble](https://tibble.tidyverse.org/reference/tibble.html) that can be
used as a template to supply author data.

## Usage

``` r
plm_template(minimal = TRUE, role_cols = credit_roles(), credit_roles = FALSE)
```

## Arguments

- minimal:

  If `TRUE`, returns an empty tibble with the following columns:
  `given_name`, `family_name`, `email`, `orcid`, `affiliation` and
  `note`. Otherwise the function returns a template with all columns
  that can be supplied to plume classes that are not
  `PlumeQuarto`-specific.

- role_cols:

  A vector of names defining role columns to create. If the vector
  contains key-value pairs, columns will be named after the keys.

- credit_roles:

  **\[deprecated\]**

  It is now recommended to use `role_cols = credit_roles()` to use the
  [Contributor Roles Taxonomy](https://credit.niso.org).

## Value

An empty tibble.

## Examples

``` r
plm_template()
#> # A tibble: 0 × 21
#> # ℹ 21 variables: given_name <chr>, family_name <chr>, orcid <chr>,
#> #   email <chr>, affiliation_1 <chr>, affiliation_2 <chr>, note <chr>,
#> #   conceptualization <dbl>, data_curation <dbl>, analysis <dbl>,
#> #   funding <dbl>, investigation <dbl>, methodology <dbl>,
#> #   administration <dbl>, resources <dbl>, software <dbl>, supervision <dbl>,
#> #   validation <dbl>, visualization <dbl>, writing <dbl>, editing <dbl>

plm_template(role_cols = paste0("role_", 1:5))
#> # A tibble: 0 × 12
#> # ℹ 12 variables: given_name <chr>, family_name <chr>, orcid <chr>,
#> #   email <chr>, affiliation_1 <chr>, affiliation_2 <chr>, note <chr>,
#> #   role_1 <dbl>, role_2 <dbl>, role_3 <dbl>, role_4 <dbl>, role_5 <dbl>
```
