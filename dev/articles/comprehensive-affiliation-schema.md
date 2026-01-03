# Comprehensive affiliation schema

Quarto provides a complete [affiliation
schema](https://quarto.org/docs/journals/authors.html#affiliations-schema)
to define affiliations in more detail.

To generate comprehensive affiliations in plume, you can specify
affiliation items in the input data using the following syntax
`key_1=item_1 key_2=item_2 key_n=item_n`. `PlumeQuarto` will
automatically parse affiliations and assign each item to its respective
key.

Affiliations with no or unrecognised keys are assigned to the `name`
key.

``` r
author <- tibble::tibble(
  given_name = "René",
  family_name = "Descartes",
  affiliation1 = "Collège royal Henri-le-Grand",
  affiliation2 = "
  city=Poitiers
  name=Université de Poitiers
  address=15 Rue de l'Hôtel Dieu
  country=Kingdom of France
  ",
  affiliation3 = "name=Academia Franekerensis country=The Netherlands city=Franeker"
)
```

``` r
aut <- PlumeQuarto$new(author, file = "file.qmd")
aut$to_yaml()
```

The above will produce the following YAML header:

    ---
    title: Cogito ergo sum
    author:
      - name:
          given: René
          family: Descartes
        affiliations:
          - ref: aff1
          - ref: aff2
          - ref: aff3
    affiliations:
      - id: aff1
        name: Collège royal Henri-le-Grand
      - id: aff2
        name: Université de Poitiers
        city: Poitiers
        address: 15 Rue de l'Hôtel Dieu
        country: Kingdom of France
      - id: aff3
        name: Academia Franekerensis
        city: Franeker
        country: The Netherlands
    ---
