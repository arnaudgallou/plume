# plume (development version)

## Documentation improvements

* New `vignette("using-credit-roles")` which describes how to work with the [Contributor Roles Taxonomy](https://credit.niso.org) in plume.

* New `vignette("plume-workflow")` which describes how to use plume and [googlesheets4](https://googlesheets4.tidyverse.org) to manage author metadata.

## Minor improvements and bug fixes

* `$new()` and `plm_template()` gain a new parameter `credit_roles` to facilitate the use of the [Contributor Roles Taxonomy](https://credit.niso.org).

* `PlumeQuarto` now handles roles via the `roles` YAML key (#5).

* New method `get_orcids()` that returns authors' ORCID.

* Phone numbers are now set using the variable and attribute `phone` (#4).

* plume methods now print outputs in the same way.

* `get_author_list()` now accepts `format = ""` to return author names only. This is equivalent to `format = NULL` (#3).

* plume classes now error when a given or family name is `NA` or a blank string.

* Blank and empty strings are now converted to `NA` when creating a plume object (#2).

* `get_contact_details()` now drops corresponding authors with no contact details.

* `get_contact_details()` has been reworked to bind any combination of contact details properly.

* `to_yaml()` now outputs verbatim `true`/`false` (#1).
