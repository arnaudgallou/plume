# Famous encyclopedists

Data on four notable authors of the Encyclopédie (originally
"Encyclopédie, ou dictionnaire raisonné des sciences, des arts et des
métiers") published in France in the second half of the 18th century.
The dataset is available in English (`encyclopedists`) and French
(`encyclopedists_fr`).

## Usage

``` r
encyclopedists

encyclopedists_fr
```

## Format

A tibble with 4 rows and 10 variables:

- given_name,prénom:

  authors' given names

- family_name,nom:

  authors' family names

- email,courriel:

  authors' email addresses

- phone,téléphone:

  authors' phone numbers

- orcid:

  authors' ORCID

- affiliation_1,affiliation_2:

  authors' affiliations

- supervision:

  authors that supervised the project

- writing,rédaction:

  authors involved in the writing

- note:

  special notes about authors

## Examples

``` r
encyclopedists
#> # A tibble: 4 × 10
#>   given_name     family_name        email  phone orcid supervision writing note 
#>   <chr>          <chr>              <chr>  <chr> <chr>       <dbl>   <dbl> <chr>
#> 1 Denis          Diderot            dider… +1234 0000…           1       1 born…
#> 2 Jean-Jacques   Rousseau           rouss… NA    0000…          NA       1 NA   
#> 3 François-Marie Arouet             aroue… NA    NA             NA       1 also…
#> 4 Jean           Le Rond d'Alembert alemb… NA    0000…           1       1 born…
#> # ℹ 2 more variables: affiliation_1 <chr>, affiliation_2 <chr>

encyclopedists_fr
#> # A tibble: 4 × 10
#>   prénom         nom        courriel téléphone orcid supervision rédaction note 
#>   <chr>          <chr>      <chr>    <chr>     <chr>       <dbl>     <dbl> <chr>
#> 1 Denis          Diderot    diderot… +1234     0000…           1         1 né e…
#> 2 Jean-Jacques   Rousseau   roussea… NA        0000…          NA         1 NA   
#> 3 François-Marie Arouet     arouet@… NA        NA             NA         1 dit …
#> 4 Jean           Le Rond d… alember… NA        0000…           1         1 né e…
#> # ℹ 2 more variables: affiliation_1 <chr>, affiliation_2 <chr>
```
