# plume (development version)

## Minor improvements and bug fixes

* Blank and empty strings are now converted to `NA` when creating a plume object (#2).

* `get_contact_details()` now drops corresponding authors with no contact details.

* `get_contact_details()` has been reworked to bind any combination of contact details properly.

* `to_yaml()` now outputs verbatim `true`/`false` (#1).
