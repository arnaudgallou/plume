# Generate author information within a document

`Plume` provides several methods to generate author information directly
within an R Markdown or Quarto document. This is a convenient solution
when you don't need preformatted reports.

In some cases, `Plume` gives you greater control over the formatting of
author information, as it supports features not available in
[`PlumeQuarto`](https://arnaudgallou.github.io/plume/dev/reference/PlumeQuarto.md).

## Notes

`new_plume()` is an alias for `Plume$new()`.

## Super classes

`plume::NameHandler` -\>
[`plume::PlumeHandler`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.md)
-\>
[`plume::StatusSetter`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.md)
-\>
[`plume::StatusSetterPlume`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetterPlume.md)
-\> `Plume`

## Methods

### Public methods

- [`Plume$new()`](#method-Plume-new)

- [`Plume$get_author_list()`](#method-Plume-get_author_list)

- [`Plume$get_affiliations()`](#method-Plume-get_affiliations)

- [`Plume$get_notes()`](#method-Plume-get_notes)

- [`Plume$get_orcids()`](#method-Plume-get_orcids)

- [`Plume$get_contact_details()`](#method-Plume-get_contact_details)

- [`Plume$get_contributions()`](#method-Plume-get_contributions)

- [`Plume$clone()`](#method-Plume-clone)

Inherited methods

- [`plume::PlumeHandler$data()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-data)
- [`plume::PlumeHandler$get_plume()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_plume)
- [`plume::PlumeHandler$get_roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-get_roles)
- [`plume::PlumeHandler$print()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-print)
- [`plume::PlumeHandler$roles()`](https://arnaudgallou.github.io/plume/dev/reference/PlumeHandler.html#method-roles)
- [`plume::StatusSetter$set_corresponding_authors()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetter.html#method-set_corresponding_authors)
- [`plume::StatusSetterPlume$set_main_contributors()`](https://arnaudgallou.github.io/plume/dev/reference/StatusSetterPlume.html#method-set_main_contributors)

------------------------------------------------------------------------

### Method `new()`

Create a `Plume` object.

#### Usage

    Plume$new(
      data,
      names = NULL,
      roles = credit_roles(),
      symbols = plm_symbols(),
      credit_roles = FALSE,
      initials_given_name = FALSE,
      dotted_initials = TRUE,
      family_name_first = FALSE,
      distinct_initials = FALSE,
      interword_spacing = TRUE,
      orcid_icon = icn_orcid(),
      by = NULL
    )

#### Arguments

- `data`:

  A data frame containing author data.

- `names`:

  A vector of key-value pairs specifying custom names to use, where keys
  are default names and values their respective replacements.

- `roles`:

  A vector of key-value pairs defining roles where keys identify role
  columns and values describe the actual roles to use.

- `symbols`:

  Symbols, as defined by
  [`plm_symbols()`](https://arnaudgallou.github.io/plume/dev/reference/plm_symbols.md),
  used to link authors to their metadata. Special Markdown characters
  are automatically escaped internally.

- `credit_roles`:

  **\[deprecated\]**

  It is now recommended to use `roles = credit_roles()` to use the
  [Contributor Roles Taxonomy](https://credit.niso.org).

- `initials_given_name`:

  Should the initials of given names be used?

- `dotted_initials`:

  Should initials be dot-separated?

- `family_name_first`:

  Should literal names show family names first?

- `distinct_initials`:

  If `TRUE`, will expand identical initials with additional letters from
  the last word of their respective family name until initials are
  unique. Initials of authors sharing the exact same name will remain in
  the short form.

- `interword_spacing`:

  Should literal names use spacing? This parameter is only useful for
  people writing in languages that don't separate words with a space
  such as Chinese or Japanese.

- `orcid_icon`:

  The ORCID icon, as defined by
  [`icn_orcid()`](https://arnaudgallou.github.io/plume/dev/reference/icn_orcid.md),
  to be used. Only supported in R Markdown.

- `by`:

  A character string defining the default variable used to assign
  specific metadata to authors in all `set_*()` methods. By default,
  uses authors' id.

#### Returns

A `Plume` object.

------------------------------------------------------------------------

### Method `get_author_list()`

Get the list of authors.

#### Usage

    Plume$get_author_list(suffix = NULL, format = deprecated())

#### Arguments

- `suffix`:

  A character string defining the format of symbols suffixing author
  names. See details.

- `format`:

  **\[deprecated\]**

  Please use the parameter `suffix` instead.

#### Details

`suffix` lets you choose which symbol categories to suffix authors with,
using the following keys:

- `a` for affiliations

- `c` for corresponding authors

- `n` for notes

- `o` for ORCID icons (only supported in R Markdown)

The order of the keys determines the order of symbol types. For example,
`"ac"` shows affiliation ids first and corresponding author mark second,
when `"ca"` shows corresponding author mark first and affiliation ids
second. Use `","` to separate and `"^"` to superscript symbols.

Set to `NULL` or `""` to list authors without suffixes.

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `get_affiliations()`

Get authors' affiliations.

#### Usage

    Plume$get_affiliations(superscript = TRUE, sep = "")

#### Arguments

- `superscript`:

  Should affiliation ids be superscripted?

- `sep`:

  Separator used to separate affiliation ids and affiliations.

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `get_notes()`

Get authors' notes.

#### Usage

    Plume$get_notes(superscript = TRUE, sep = "")

#### Arguments

- `superscript`:

  Should note ids be superscripted?

- `sep`:

  Separator used to separate note ids and notes.

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `get_orcids()`

Get authors' ORCID.

#### Usage

    Plume$get_orcids(compact = FALSE, icon = TRUE, sep = "")

#### Arguments

- `compact`:

  Should links only display the 16-digit identifier?

- `icon`:

  Should the ORCID icon be shown? This is only supported in R Markdown.

- `sep`:

  Separator used to separate authors and their respective ORCID.

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `get_contact_details()`

Get the contact details of corresponding authors.

#### Usage

    Plume$get_contact_details(
      template = "{details} ({name})",
      email = TRUE,
      phone = FALSE,
      fax = FALSE,
      url = FALSE,
      sep = ", ",
      format = deprecated()
    )

#### Arguments

- `template`:

  A [glue](https://glue.tidyverse.org/reference/glue.html) specification
  that uses the variables `name` and/or `details`.

- `email, phone, fax, url`:

  Arguments equal to `TRUE` are evaluated and passed to the variable
  `details`. By default, only `email` is set to `TRUE`.

- `sep`:

  Separator used to separate `details` items.

- `format`:

  **\[deprecated\]**

  Please use the parameter `template` instead.

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `get_contributions()`

Get authors' contributions.

#### Usage

    Plume$get_contributions(
      roles_first = TRUE,
      by_author = FALSE,
      alphabetical_order = FALSE,
      literal_names = FALSE,
      divider = ": ",
      sep = ", ",
      sep_last = " and ",
      dotted_initials = deprecated()
    )

#### Arguments

- `roles_first`:

  If `TRUE`, displays roles first and authors second. If `FALSE`, roles
  follow authors.

- `by_author`:

  Should roles be grouped by author?

- `alphabetical_order`:

  Should authors be listed in alphabetical order? By default, lists
  authors in the order they are defined in the data.

- `literal_names`:

  Should literal names be used?

- `divider`:

  Separator used to separate roles from authors.

- `sep`:

  Separator used to separate roles or authors.

- `sep_last`:

  Separator used to separate the last two roles or authors if more than
  one item is associated to a role or author.

- `dotted_initials`:

  **\[deprecated\]**

  Please use the `dotted_initials` parameter of `Plume$new()` instead.

#### Returns

A character vector.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Plume$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
# Create a Plume instance
aut <- Plume$new(encyclopedists)

# Set the desired corresponding authors, using
# authors' id by default
aut$set_corresponding_authors(1, 4)

# Listing authors, followed by affiliation ids
# and the corresponding author mark:
aut$get_author_list("^a,c^")
#> Denis Diderot^1,\*^
#> Jean-Jacques Rousseau^2^
#> François-Marie Arouet^2^
#> Jean Le Rond d'Alembert^1,3,\*^

# Or maybe with the corresponding author mark
# coming before affiliation ids:
aut$get_author_list("^c,a^")
#> Denis Diderot^\*,1^
#> Jean-Jacques Rousseau^2^
#> François-Marie Arouet^2^
#> Jean Le Rond d'Alembert^\*,1,3^

# Getting more author metadata
aut$get_affiliations()
#> ^1^Université de Paris
#> ^2^Lycée Louis-le-Grand
#> ^3^Collège des Quatre-Nations

aut$get_contributions()
#> Supervision: D.D. and J.L.R.d'A.
#> Writing - original draft: D.D., J.-J.R., F.-M.A. and J.L.R.d'A.

# Use `symbols` to change the default symbols.
# E.g. to use letters as affiliation ids:
aut <- Plume$new(
  encyclopedists,
  symbols = plm_symbols(affiliation = letters)
)

aut$get_author_list("^a^")
#> Denis Diderot^a^
#> Jean-Jacques Rousseau^b^
#> François-Marie Arouet^b^
#> Jean Le Rond d'Alembert^a,c^

aut$get_affiliations()
#> ^a^Université de Paris
#> ^b^Lycée Louis-le-Grand
#> ^c^Collège des Quatre-Nations

# It is also possible to output contributions in the
# active voice
aut <- Plume$new(
  encyclopedists,
  roles = c(
    supervision = "supervised the project",
    writing = "contributed to the Encyclopédie"
  )
)
aut$get_contributions(roles_first = FALSE, divider = " ")
#> D.D. and J.L.R.d'A. supervised the project
#> D.D., J.-J.R., F.-M.A. and J.L.R.d'A. contributed to the Encyclopédie
```
