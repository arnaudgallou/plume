# Add or update author data in YAML for Quarto

`PlumeQuarto` allows you to add or update author data in YAML files or
the YAML header of Quarto documents. The generated YAML complies with
Quarto's [author and affiliations
schemas](https://quarto.org/docs/journals/authors.html). Use this class
when working with journal templates.

## Notes

`new_plume_quarto()` is an alias for `PlumeQuarto$new()`.

## Super classes

`plume::NameHandler` -\>
[`plume::PlumeHandler`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.md)
-\>
[`plume::StatusSetter`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.md)
-\>
[`plume::StatusSetterPlumeQuarto`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetterPlumeQuarto.md)
-\> `PlumeQuarto`

## Methods

### Public methods

- [`PlumeQuarto$new()`](#method-PlumeQuarto-new)

- [`PlumeQuarto$to_yaml()`](#method-PlumeQuarto-to_yaml)

- [`PlumeQuarto$clone()`](#method-PlumeQuarto-clone)

Inherited methods

- [`plume::PlumeHandler$data()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-data)
- [`plume::PlumeHandler$get_plume()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_plume)
- [`plume::PlumeHandler$get_roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_roles)
- [`plume::PlumeHandler$print()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-print)
- [`plume::PlumeHandler$roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-roles)
- [`plume::StatusSetter$set_corresponding_authors()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.html#method-set_corresponding_authors)
- [`plume::StatusSetterPlumeQuarto$set_cofirst_authors()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetterPlumeQuarto.html#method-set_cofirst_authors)
- [`plume::StatusSetterPlumeQuarto$set_deceased()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetterPlumeQuarto.html#method-set_deceased)
- [`plume::StatusSetterPlumeQuarto$set_equal_contributor()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetterPlumeQuarto.html#method-set_equal_contributor)

------------------------------------------------------------------------

### Method `new()`

Create a `PlumeQuarto` object.

#### Usage

    PlumeQuarto$new(
      data,
      file,
      names = NULL,
      roles = credit_roles(),
      credit_roles = FALSE,
      initials_given_name = FALSE,
      dotted_initials = TRUE,
      by = NULL
    )

#### Arguments

- `data`:

  A data frame containing author data.

- `file`:

  A `.qmd`, `.yml` or `.yaml` file to insert author data into.

- `names`:

  A vector of key-value pairs specifying custom names to use, where keys
  are default names and values their respective replacements.

- `roles`:

  A vector of key-value pairs defining roles where keys identify columns
  and values describe the actual roles to use.

- `credit_roles`:

  **\[deprecated\]**

  It is now recommended to use `roles = credit_roles()` to use the
  [Contributor Roles Taxonomy](https://credit.niso.org).

- `initials_given_name`:

  Should the initials of given names be used?

- `dotted_initials`:

  Should initials be dot-separated?

- `by`:

  A character string defining the default variable used to assign
  specific metadata to authors in all `set_*()` methods. By default,
  uses authors' id.

#### Returns

A `PlumeQuarto` object.

------------------------------------------------------------------------

### Method `to_yaml()`

Add or update author data in the input `file`.

#### Usage

    PlumeQuarto$to_yaml()

#### Returns

The input `file`, invisibly.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    PlumeQuarto$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create a simple temporary YAML file containing a title
tmp_file <- tempfile(fileext = ".yml")
readr::write_lines("title: Encyclopédie", tmp_file)

# View the temporary file
cat(readr::read_file(tmp_file))
#> title: Encyclopédie

# Create a PlumeQuarto instance using the temporary file
# we've just created
aut <- PlumeQuarto$new(
  encyclopedists,
  file = tmp_file
)

# And add author data to the YAML file
aut$to_yaml()

cat(readr::read_file(tmp_file))
#> title: Encyclopédie
#> author:
#>   - id: aut1
#>     name:
#>       given: Denis
#>       family: Diderot
#>     email: diderot@encyclopediste.fr
#>     phone: '+1234'
#>     orcid: 0000-0000-0000-0001
#>     note: born in 1713 in Langres
#>     roles:
#>       - Supervision
#>       - Writing - original draft
#>     affiliations:
#>       - ref: aff1
#>   - id: aut2
#>     name:
#>       given: Jean-Jacques
#>       family: Rousseau
#>     email: rousseau@encyclopediste.fr
#>     orcid: 0000-0000-0000-0002
#>     roles:
#>       - Writing - original draft
#>     affiliations:
#>       - ref: aff2
#>   - id: aut3
#>     name:
#>       given: François-Marie
#>       family: Arouet
#>     email: arouet@encyclopediste.fr
#>     note: also known as Voltaire
#>     roles:
#>       - Writing - original draft
#>     affiliations:
#>       - ref: aff2
#>   - id: aut4
#>     name:
#>       given: Jean
#>       family: Le Rond d'Alembert
#>     email: alembert@encyclopediste.fr
#>     orcid: 0000-0000-0000-0003
#>     note: born in 1717 in Paris
#>     roles:
#>       - Supervision
#>       - Writing - original draft
#>     affiliations:
#>       - ref: aff1
#>       - ref: aff3
#> affiliations:
#>   - id: aff1
#>     name: Université de Paris
#>   - id: aff2
#>     name: Lycée Louis-le-Grand
#>   - id: aff3
#>     name: Collège des Quatre-Nations

# Running the method again with new data updates the YAML
# accordingly
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 2),
  file = tmp_file
)
aut$to_yaml()

cat(readr::read_file(tmp_file))
#> title: Encyclopédie
#> author:
#>   - name:
#>       given: Jean-Jacques
#>       family: Rousseau
#>     email: rousseau@encyclopediste.fr
#>     orcid: 0000-0000-0000-0002
#>     roles:
#>       - Writing - original draft
#>     affiliations:
#>       - ref: aff1
#> affiliations:
#>   - id: aff1
#>     name: Lycée Louis-le-Grand

# Clean up
unlink(tmp_file)
```
