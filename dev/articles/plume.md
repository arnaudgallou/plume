# Introduction to plume

The goal of the plume package is to make the handling and formatting of
author data for scientific writing in R Markdown and Quarto easy and
painless.

## Example data

We’ll use the datasets `encyclopedists` and `encyclopedists_fr` to
explore the different functionalities of the package. These datasets
contain information about four notable authors of the “Encyclopédie”,
published in France in the 18th century. `encyclopedists_fr` is the
French translation of `encyclopedists` and will be used to illustrate
how to handle custom variable names. Both datasets are documented in
[`?encyclopedists`](https://arnaudgallou.github.io/plume/dev/reference/encyclopedists.md).

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
```

## Creating a plume object

plume provides two R6 classes: `Plume` and `PlumeQuarto`. You can create
a plume object with `Plume$new()` or `PlumeQuarto$new()`. Alternatively,
you can use their alias
[`new_plume()`](https://arnaudgallou.github.io/plume/dev/reference/Plume.md)
and
[`new_plume_quarto()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeQuarto.md).
plume classes take a data frame or tibble as input data. The input data
must have at least two columns, one for given names and another for
family names.

``` r
Plume$new(encyclopedists)
#> # A tibble: 4 × 11
#>      id given_name     family_name literal_name initials orcid email phone note 
#>   <int> <chr>          <chr>       <chr>        <chr>    <chr> <chr> <chr> <chr>
#> 1     1 Denis          Diderot     Denis Dider… D.D.     0000… dide… +1234 born…
#> 2     2 Jean-Jacques   Rousseau    Jean-Jacque… J.-J.R.  0000… rous… NA    NA   
#> 3     3 François-Marie Arouet      François-Ma… F.-M.A.  NA    arou… NA    also…
#> 4     4 Jean           Le Rond d'… Jean Le Ron… J.L.R.d… 0000… alem… NA    born…
#> # ℹ 2 more variables: affiliation <list>, role <list>
```

## Available names

The default variables handled by plume classes are organised into six
categories:

**Primaries**: variables required to create a plume object.

| Name        | Plume                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | PlumeQuarto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| given_name  | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| family_name | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |

**Secondaries**: optional variables that can be provided in the input
data.

| Name              | Plume                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | PlumeQuarto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| orcid             | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| email             | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| phone             | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| fax               | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| url               | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| number            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| dropping_particle |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| acknowledgements  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |

**Nestables**: optional variables that can be provided in the input data
to pass multiple independent values to authors. Nestable variables must
start with the same prefix. For example, `affiliation_1`,
`affiliation_2`, …, `affiliation_n` to pass several affiliations to
authors.

| Name        | Plume                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | PlumeQuarto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| affiliation | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| note        | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| degree      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |

**Roles**: optional user-defined variables describing authors’ roles
(see [Defining roles and contributors](#defining_roles) for details). By
default, uses CRediT roles as defined by
[`credit_roles()`](https://arnaudgallou.github.io/plume/dev/reference/credit_roles.md).

**Internals**: variables created internally. These variables don’t need
to be provided in the input data and are ignored if supplied. You
shouldn’t worry much about these variables unless you want to customise
names or extend plume classes with new default names.

| Name              | Plume                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | PlumeQuarto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id                | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| initials          | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| literal_name      | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| corresponding     | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| role              | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| contributor_rank  | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| deceased          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| equal_contributor |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |

**Meta**: `PlumeQuarto`-specific variables used to pass extra
information that doesn’t fit in other categories. Meta columns must
start with the prefix `meta-` and are followed by a custom name
(e.g. `meta-custom_name`). You should only use these variables to pass
data that are template specific. See Quarto’s
[arbitrary-metadata](https://quarto.org/docs/journals/authors.html#arbitrary-metadata)
section for details.

## Using custom names

plume lets you use custom variable names. Simply provide the `names`
parameter a named vector when instantiating a plume class, where keys
are default names and values their respective replacements.

``` r
Plume$new(
  encyclopedists_fr,
  names = c(
    given_name = "prénom",
    family_name = "nom",
    literal_name = "nom_complet",
    email = "courriel",
    initials = "initiales"
  )
)
#> # A tibble: 4 × 10
#>      id prénom         nom      nom_complet initiales orcid courriel role  note 
#>   <int> <chr>          <chr>    <chr>       <chr>     <chr> <chr>    <chr> <chr>
#> 1     1 Denis          Diderot  Denis Dide… D.D.      0000… diderot… Supe… né e…
#> 2     2 Jean-Jacques   Rousseau Jean-Jacqu… J.-J.R.   0000… roussea… NA    NA   
#> 3     3 François-Marie Arouet   François-M… F.-M.A.   NA    arouet@… NA    dit …
#> 4     4 Jean           Le Rond… Jean Le Ro… J.L.R.d'… 0000… alember… Supe… né e…
#> # ℹ 1 more variable: affiliation <list>
```

## Defining roles and contributors

You can add roles by creating specific role columns in the input data
and indicating contributors with the number `1`:

    #> # A tibble: 4 × 4
    #>   given_name     family_name        supervision writing
    #>   <chr>          <chr>                    <dbl>   <dbl>
    #> 1 Denis          Diderot                      1       1
    #> 2 Jean-Jacques   Rousseau                    NA       1
    #> 3 François-Marie Arouet                      NA       1
    #> 4 Jean           Le Rond d'Alembert           1       1

plume uses the [Contributor Roles Taxonomy](https://credit.niso.org)
(CRediT) by default, assuming the input data contains the appropriate
columns (see
[`credit_roles()`](https://arnaudgallou.github.io/plume/dev/reference/credit_roles.md)
for details). You can specify your own roles via the `roles` parameter
when creating a plume object. The `roles` parameter takes a vector of
key-value pairs where keys identify role columns and values define the
actual roles to use.

``` r
Plume$new(
  data,
  roles = c(
    supervision = "supervised the project",
    writing = "contributed to the writing"
  )
)
```

## Assigning status to authors

plume provides 4 methods to set particular status to authors:

| Name                        | Plume                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | PlumeQuarto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| set_corresponding_authors() | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| set_main_contributors()     | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| set_cofirst_authors()       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |
| set_deceased()              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ![](data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIiB2aWV3Ym94PSIwIDAgNDQ4IDUxMiIgc3R5bGU9ImhlaWdodDoxZW07d2lkdGg6MC44OGVtO3ZlcnRpY2FsLWFsaWduOi0wLjEyNWVtO21hcmdpbi1sZWZ0OmF1dG87bWFyZ2luLXJpZ2h0OmF1dG87Zm9udC1zaXplOmluaGVyaXQ7ZmlsbDpjdXJyZW50Q29sb3I7b3ZlcmZsb3c6dmlzaWJsZTtwb3NpdGlvbjpyZWxhdGl2ZTsiPjxwYXRoIGQ9Ik00MzguNiAxMDUuNGMxMi41IDEyLjUgMTIuNSAzMi44IDAgNDUuM2wtMjU2IDI1NmMtMTIuNSAxMi41LTMyLjggMTIuNS00NS4zIDBsLTEyOC0xMjhjLTEyLjUtMTIuNS0xMi41LTMyLjggMC00NS4zczMyLjgtMTIuNSA0NS4zIDBMMTYwIDMzOC43IDM5My40IDEwNS40YzEyLjUtMTIuNSAzMi44LTEyLjUgNDUuMyAweiIgLz48L3N2Zz4=) |

By default, `set_*()` methods assign values by authors’ id. You can
change this behaviour at the object or method level using the `by` or
`.by` parameter.

Note that these methods are case-insensitive and dot-agnostic.

``` r
aut <- Plume$new(dplyr::select(encyclopedists, given_name, family_name))

aut$set_corresponding_authors(dd, "j-jr", .by = "initials")
aut
#> # A tibble: 4 × 6
#>      id given_name     family_name        literal_name    initials corresponding
#>   <int> <chr>          <chr>              <chr>           <chr>    <lgl>        
#> 1     1 Denis          Diderot            Denis Diderot   D.D.     TRUE         
#> 2     2 Jean-Jacques   Rousseau           Jean-Jacques R… J.-J.R.  TRUE         
#> 3     3 François-Marie Arouet             François-Marie… F.-M.A.  FALSE        
#> 4     4 Jean           Le Rond d'Alembert Jean Le Rond d… J.L.R.d… FALSE
```

Use
[`everyone()`](https://arnaudgallou.github.io/plume/dev/reference/everyone.md)
to assign `TRUE` to all authors:

``` r
aut$set_corresponding_authors(everyone())
aut
#> # A tibble: 4 × 6
#>      id given_name     family_name        literal_name    initials corresponding
#>   <int> <chr>          <chr>              <chr>           <chr>    <lgl>        
#> 1     1 Denis          Diderot            Denis Diderot   D.D.     TRUE         
#> 2     2 Jean-Jacques   Rousseau           Jean-Jacques R… J.-J.R.  TRUE         
#> 3     3 François-Marie Arouet             François-Marie… F.-M.A.  TRUE         
#> 4     4 Jean           Le Rond d'Alembert Jean Le Rond d… J.L.R.d… TRUE
```

## Inserting data into a YAML or Quarto file

`PlumeQuarto` allows you to add or update author data directly into YAML
files or the YAML header of `.qmd` documents.

Consider the following YAML file:

    title: Encyclopédie

You can add author data to the file using the `to_yaml()` method:

``` r
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 1, 4),
  file = "example.yml"
)
aut$to_yaml()
```

    title: Encyclopédie
    author:
      - id: aut1
        name:
          given: Denis
          family: Diderot
        email: diderot@encyclopediste.fr
        phone: '+1234'
        orcid: 0000-0000-0000-0001
        note: born in 1713 in Langres
        roles:
          - Supervision
          - Writing - original draft
        affiliations:
          - ref: aff1
      - id: aut2
        name:
          given: Jean
          family: Le Rond d'Alembert
        email: alembert@encyclopediste.fr
        orcid: 0000-0000-0000-0003
        note: born in 1717 in Paris
        roles:
          - Supervision
          - Writing - original draft
        affiliations:
          - ref: aff1
          - ref: aff2
    affiliations:
      - id: aff1
        name: Université de Paris
      - id: aff2
        name: Collège des Quatre-Nations

Authors are listed in the order they’re defined in the input data.

If the YAML or Quarto file already has an `author` and `affiliations`
keys, `to_yaml()` replaces old values with new ones.

``` r
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 2),
  file = "example.yml"
)
aut$to_yaml()
```

    title: Encyclopédie
    author:
      - name:
          given: Jean-Jacques
          family: Rousseau
        email: rousseau@encyclopediste.fr
        orcid: 0000-0000-0000-0002
        roles:
          - Writing - original draft
        affiliations:
          - ref: aff1
    affiliations:
      - id: aff1
        name: Lycée Louis-le-Grand

## Getting author information

`get_*()` methods (available in the `Plume` class) generate author
information as character vectors. This is useful when you don’t need or
want to output author information using journal templates.

### Author lists

`get_author_list()` generates author lists. You can control the
formatting of author suffixes (symbols linking authors to affiliations,
notes and other metadata) using the `suffix` parameter. `suffix` takes a
character string as argument and allows you to choose which symbol
categories to suffix authors with, using the following keys:

- `a` for affiliations

- `c` for corresponding authors

- `n` for notes

- `o` for ORCIDs (only supported in R Markdown)

The order of the keys determines the order of symbol categories.

``` r
aut <- Plume$new(encyclopedists)
aut$set_corresponding_authors(everyone())

aut$get_author_list(suffix = "ac")
#> Denis Diderot1\*
#> Jean-Jacques Rousseau2\*
#> François-Marie Arouet2\*
#> Jean Le Rond d'Alembert1,3\*

aut$get_author_list(suffix = "ca")
#> Denis Diderot\*1
#> Jean-Jacques Rousseau\*2
#> François-Marie Arouet\*2
#> Jean Le Rond d'Alembert\*1,3
```

In addition, you can use `^` to superscript and `,` to separate symbols:

``` r
aut$set_corresponding_authors(1, 4)

aut$get_author_list("^a,^cn")
#> Denis Diderot^1,^\*†
#> Jean-Jacques Rousseau^2^
#> François-Marie Arouet^2^‡
#> Jean Le Rond d'Alembert^1,3,^\*§
```

Use `suffix = NULL` or `suffix = ""` to ignore suffixes:

``` r
aut$get_author_list(suffix = NULL)
#> Denis Diderot
#> Jean-Jacques Rousseau
#> François-Marie Arouet
#> Jean Le Rond d'Alembert
```

### Affiliations & notes

`get_affiliations()` and `get_notes()` return authors’ affiliations and
notes.

``` r
aut$get_affiliations()
#> ^1^Université de Paris
#> ^2^Lycée Louis-le-Grand
#> ^3^Collège des Quatre-Nations

aut$get_notes(sep = ": ", superscript = FALSE)
#> †: born in 1713 in Langres
#> ‡: also known as Voltaire
#> §: born in 1717 in Paris
```

### ORCIDs

`get_orcids()` returns authors with their respective ORCID.

``` r
aut$get_orcids(icon = FALSE, sep = " ")
#> Denis Diderot <https://orcid.org/0000-0000-0000-0001>
#> Jean-Jacques Rousseau <https://orcid.org/0000-0000-0000-0002>
#> Jean Le Rond d'Alembert <https://orcid.org/0000-0000-0000-0003>
```

### Contact details

You can get contact details of corresponding authors using the
`get_contact_details()` method:

``` r
aut$get_contact_details()
#> diderot@encyclopediste.fr (Denis Diderot)
#> alembert@encyclopediste.fr (Jean Le Rond d'Alembert)

aut$get_contact_details(phone = TRUE)
#> diderot@encyclopediste.fr, +1234 (Denis Diderot)
#> alembert@encyclopediste.fr (Jean Le Rond d'Alembert)

aut$get_contact_details(template = "{name}: {details}")
#> Denis Diderot: diderot@encyclopediste.fr
#> Jean Le Rond d'Alembert: alembert@encyclopediste.fr
```

### Contributions

plume provides a convenient way to generate contribution lists using the
`get_contributions()` method.

``` r
aut$get_contributions()
#> Supervision: D.D. and J.L.R.d'A.
#> Writing - original draft: D.D., J.-J.R., F.-M.A. and J.L.R.d'A.

aut$get_contributions(
  roles_first = FALSE,
  by_author = TRUE,
  literal_names = TRUE
)
#> Denis Diderot: Supervision and Writing - original draft
#> Jean-Jacques Rousseau: Writing - original draft
#> François-Marie Arouet: Writing - original draft
#> Jean Le Rond d'Alembert: Supervision and Writing - original draft

aut2 <- Plume$new(
  encyclopedists,
  roles = c(
    supervision = "supervised the project",
    writing = "contributed to the Encyclopédie"
  )
)
aut2$get_contributions(roles_first = FALSE, divider = " ")
#> D.D. and J.L.R.d'A. supervised the project
#> D.D., J.-J.R., F.-M.A. and J.L.R.d'A. contributed to the Encyclopédie
```

By default, `get_contributions()` lists contributors in the order
they’re defined. You can arrange contributors in alphabetical order with
`alphabetical_order = TRUE`:

``` r
aut$get_contributions(alphabetical_order = TRUE)
#> Supervision: D.D. and J.L.R.d'A.
#> Writing - original draft: D.D., F.-M.A., J.-J.R. and J.L.R.d'A.
```

It’s possible to force one or more contributors to appear first in any
given role by setting main contributors:

``` r
aut$set_main_contributors(supervision = 4, writing = c(3, 2))
aut$get_contributions()
#> Supervision: J.L.R.d'A. and D.D.
#> Writing - original draft: F.-M.A., J.-J.R., D.D. and J.L.R.d'A.
```

You can assign the same main contributors across multiple roles using
the `.roles` parameter. For example, to set a main contributor across
all roles:

``` r
aut$set_main_contributors(jean, .roles = aut$roles(), .by = "given_name")
aut$get_contributions()
#> Supervision: J.L.R.d'A. and D.D.
#> Writing - original draft: J.L.R.d'A., D.D., J.-J.R. and F.-M.A.
```

Note that main contributors have the priority over the alphabetical
ordering:

``` r
aut$get_contributions(alphabetical_order = TRUE)
#> Supervision: J.L.R.d'A. and D.D.
#> Writing - original draft: J.L.R.d'A., D.D., F.-M.A. and J.-J.R.
```

The `.roles` parameter only applies to unnamed expressions. This allows
you to set the same main contributors across all but a few specific
roles at once.

``` r
aut$set_main_contributors(4, 3, supervision = 1, .roles = aut$roles())
```

Here, authors 4 and 3 are the main contributors in all roles but
`supervision`, where author 1 is the main contributor.

## Symbols

Default symbols are:

    #> List of 3
    #>  $ affiliation  : NULL
    #>  $ corresponding: chr "*"
    #>  $ note         : chr [1:6] "†" "‡" "§" "¶" "#" "**"

You can change symbols when creating a plume object using the parameter
`symbols`.

Use `NULL` to display numerals:

``` r
aut <- Plume$new(
  encyclopedists,
  symbols = plm_symbols(affiliation = letters, note = NULL)
)

aut$get_author_list("^a,n^")
#> Denis Diderot^a,1^
#> Jean-Jacques Rousseau^b^
#> François-Marie Arouet^b,2^
#> Jean Le Rond d'Alembert^a,c,3^
```

Use `NULL` as much as possible for symbols using numerous unique items
(typically affiliations). If you have to use a character vector for a
given category that has more unique items than vector elements, you can
control the sequencing behaviour using the
[`sequential()`](https://arnaudgallou.github.io/plume/dev/reference/sequential.md)
modifier, as shown below:

``` r
Plume$new(
  encyclopedists,
  symbols = plm_symbols(affiliation = sequential(letters))
)
```

By default, plume repeats elements when all elements in a vector are
consumed. Using
[`sequential()`](https://arnaudgallou.github.io/plume/dev/reference/sequential.md)
allows you to display a logical sequence of characters
(e.g. `a, b, c, ..., z, aa, ab, ac, ..., az, ba, bb, bc, ...`).

## Outputting as markdown content

To output author data as markdown content, use the chunk option
`results: asis` in combination with
[`cat()`](https://rdrr.io/r/base/cat.html):

```` default
```{r}
#| results: asis
cat(aut$get_contributions(), sep = "; ")
```
````

Inline chunks output values “as is” by default and can be used as
follows:

`` `r aut$get_author_list()` ``
