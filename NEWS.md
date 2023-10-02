# plume 0.1.0

## Documentation improvements

* New `vignette("using-credit-roles")` which describes how to work with the [Contributor Roles Taxonomy](https://credit.niso.org) in plume.

* New `vignette("plume-workflow")` which describes how to use plume and [googlesheets4](https://googlesheets4.tidyverse.org) to manage author metadata.

## Minor improvements and bug fixes

* New helpers `everyone()` and `everyone_but()` to select all authors or exclude some in `$set_*()` methods.

* Leading and trailing white spaces are now trimmed when creating `plume` objects.

* `$get_contributions()` now handles namesakes (#15).

* `$get_contributions(alphabetical_order = TRUE)` now reorders contributors only (#18).

* R6 classes have been overhauled for a better separation of concerns (#5, #12).

  * `$set_*()` methods have been moved to their own classes.

  * `PlumeQuarto` now only does what it is designed for: injecting author metadata into the YAML header of Quarto files. This means that `PlumeQuarto` can no longer generate author information as character strings.

  * `Plume` now drops variables that are `PlumeQuarto`-specific. `Plume`'s constructor also lost the `by` parameter as it was only used in `$set_corresponding_authors()`.

* `$new()` and `plm_template()` gain a new parameter `credit_roles` to facilitate the use of the [Contributor Roles Taxonomy](https://credit.niso.org).

* `$to_yaml()` can now push data to empty YAML headers (#9).

* `PlumeQuarto` now handles roles via the `roles` YAML key (#5).

* New method `$get_orcids()` that returns authors' ORCID.

* Phone numbers are now set using the variable and attribute `phone` (#4).

* plume methods now print outputs in a consistent way.

* `$get_author_list()` now accepts `format = ""` to return author names only. This is equivalent to `format = NULL` (#3).

* plume classes now error when a given or family name is `NA` or a blank string.

* Blank and empty strings are now converted to `NA` when creating `plume` objects (#2).

* `$get_contact_details()` now drops corresponding authors with no contact details.

* `$get_contact_details()` has been reworked to bind any combination of contact details properly.

* `$to_yaml()` now outputs verbatim `true`/`false` (#1).
