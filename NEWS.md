# plume (development version)

## Documentation improvements

* New `vignette("plume-workflow")` which describes how to use plume and [googlesheets4](https://googlesheets4.tidyverse.org) to manage author metadata.

## Minor improvements and bug fixes

* Blank and empty strings are now converted to `NA` when creating a plume object (#2).

* `get_contact_details()` now drops corresponding authors with no contact details.

* `get_contact_details()` has been reworked to bind any combination of contact details properly.

* `to_yaml()` now outputs verbatim `true`/`false` (#1).
