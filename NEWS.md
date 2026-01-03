# plume (development version)

* `Plume$new(distinct_initials = TRUE)` now remains quiet when all initials are already unique (#134).

# plume 0.3.0

## New features

* New `new_plume()` and `new_plume_quarto()` that are aliases for `Plume$new()` and `PlumeQuarto$new()`, respectively (#124).

* New `plm_symbols()` to set the symbols used in `Plume` (#119).

* `Plume$new()` and `PlumeQuarto$new()` gain a new parameter `dotted_initials` to control whether or not initials should be dotted. This parameter replaces the `dotted_initials` parameter of `$get_contributions()`, which is now deprecated (#112).

* `Plume$new()` gains a new parameter `distinct_initials` to differentiate similar authors' initials, when possible. This is done by adding extra letters from the last word of authors' family name until initials are unique. Initials will remain in the short form if authors share the same family name (#111).

* New `as_lines()` to output vector elements on distinct lines when rendering an R Markdown or Quarto document (#98).

## Breaking changes

* Setting new default names to a plume subclass must now be done via the `names` field (#117).

## Minor improvements and bug fixes

* `$get_author_list()` now correctly drops leading `^` when there are no symbols to display (#127).

* ORCID icons are now ignored in Quarto documents due to a change introduced in Quarto 1.5 regarding how paths are resolved. They continue to work in R Markdown as before (#109).

* `Plume` now automatically escapes special Markdown characters used as symbols (#119).

* `$set_*()` methods are now dot-agnostic (#113).

* The `orcid` variable is now customisable (#96).

## Lifecycle changes

* All functionalities deprecated in 0.2.1 and earlier now throw an error. This includes:

  * The `credit_roles` parameter in `plm_template()` and `$new()`.

  * The `format` parameter in `$get_author_list()`.

  * The `by` parameter in `$set_*()` methods.

  * `everyone_but()`.

  * `$set_equal_contributor()`.

  * Defining authors' roles explicitly in the input dataset.

### Newly deprecated

* `$get_plume()` is deprecated in favour of `$data()` (#115).

* `$get_roles()` is deprecated in favour of `$roles()` (#114).

* The `dotted_initials` parameter of `$get_contributions()` is now deprecated. This parameter must now be set in the constructors (#112).

* `orcid()` is deprecated in favour of `icn_orcid()` (#105).

* The `format` parameter of `$get_contact_details()` is now deprecated in favour of the more explicit `template` parameter (#104).

# plume 0.2.5

* `$get_author_list(suffix =)` is now slightly more flexible and will try less hard to sanitise author list suffixes (#90).

* `PlumeQuarto` no longer converts roles to lower case (#88).

* `PlumeQuarto` now supports authors' `degrees` and the `group` affiliation property (#53).

* `PlumeQuarto` now properly handles authors with no roles (#81).

* `PlumeQuarto` now supports `.yml` and `.yaml` files (#82).

# plume 0.2.4

* Tweaked some examples in the vignettes and expanded the `Contributions` section in `vignette("plume")`.

* Fixed selection helpers not working when imported explicitly with `::` (#76).

* `citation("plume")` now generates the complete and up-to-date citation of plume (#75).

# plume 0.2.3

* `$new(initials_given_name = TRUE)` no longer makes initials if names are written in a script that doesn't use letter cases (#73).

* Fixed `PlumeQuarto`'s example no longer working with `withr` 3.0.0 due to a wrong usage of `local_tempfile()` (#70).

* `$get_author_list()` now throws a more informative error if corresponding authors have not been set (#69).

* The `.roles` parameter in `$set_main_contributors()` now propagates roles that are not already set to any unnamed expression. This allows you to set the same main contributors across all but a few specific roles in a single call (#65).

* `$to_yaml()` now only adds the `affiliations` schema if there is at least one affiliation (#67).

* `$to_yaml()` now only adds authors' id if there are at least two authors (#66).

# plume 0.2.2

## Documentation changes

* `vignette("working-in-other-languages")` has been extended to describe how to overwrite default arguments to match your preferred language better.

## Minor improvements and bug fixes

* Clarified error messages by suppressing purrr's wrapper error (#63).

* `$to_yaml()` now writes author metadata in a separate YAML header if the original YAML header contains strippable meta-information such as comments, custom tags or folded blocks (#56, #61).

* The way `$set_*()` methods handle `...` has been overhauled for more consistent results and to ensure the methods work correctly in edge cases (#59, #60).

* `$get_contributions()` now throws the correct error if you pass a wrong argument to the `sep` parameter (#55).

* The order of `$get_affiliations()`/`$get_notes()` parameters have been switched for consistency purposes (#54).

# plume 0.2.1

* Fixed `$get_contributions()` wrongly reordering authors when using CRediT roles and `by_author = TRUE` (#50).

* `$get_contributions()` gains a new parameter `sep` that allows for finer control of how to separate contributors or roles (#49).

* `$to_yaml()` now throws an error when invalid ORCID identifiers are found.

* `Plume`'s parameter `by` is now working properly (#48).

* The `format` parameter of `$get_author_list()` is now deprecated in favour of the less ambiguous parameter `suffix` (#47).

# plume 0.2.0

## New features

* `Plume` gains a new method `$set_main_contributors()` that allows you to force one or more contributors to appear first in the contribution list for any given role. Because of this new method, `Plume`'s contructor gained the parameter `by` to set the default `by`/`.by` value used in all `$set_*()` methods (#40).

* New `credit_roles()` that returns the 14 contributor roles of the [Contributor Roles Taxonomy](https://credit.niso.org). These are now the default roles used by plume.

<a name="new_role_system" />

* The plume role handling system has been overhauled for better flexibility and ease of use (#29).

  * plume classes gain a new parameter `roles` allowing you to specify roles using a named character vector.

    Rather than:

    ```
    # A tibble: 2 × 4
      given_name family_name role_1      role_2
      <chr>      <chr>       <chr>       <chr>
    1 Zip        Zap         Supervision Writing
    2 Ric        Rac         NA          Writing
    ```

    You can now use the following data structure:

    ```
    # A tibble: 2 × 4
      given_name family_name role_1 role_2
      <chr>      <chr>        <dbl>  <dbl>
    1 Zip        Zap              1      1
    2 Ric        Rac             NA      1
    ```

    And speficy roles when creating a plume object:

    ```
    Plume$new(data, roles = c(role_1 = "Supervision", role_2 = "Writing"))
    ```

  * `plm_template()` gains a new parameter `role_cols` to create role columns from a character vector.

## Lifecycle changes

* `$set_equal_contributor()` is now deprecated in favour of `$set_cofirst_authors()` due to the ambiguous name of the method (#45).

* `everyone_but()` is now deprecated as this function is not necessary since not more than a couple of authors should normally be given a particular status (#44).

* The `by` parameter in `$set_*()` methods is now deprecated in favour of `.by` for consistency purposes (#41).

* Defining roles explicitly in the input data or using `credit_roles = TRUE` are now deprecated in favour of defining role columns and roles via the parameters `role_cols` and `roles`, respectively (see details about the [new role handling system](#new_role_system) above).

## Documentation changes

* The `using-credit-roles` vignette was removed as it is no longer needed.

## Minor improvements and bug fixes

* Removed stringb dependency in favour of stringr (#42).

* Updated the `encyclopedists` and `encyclopedists_fr` data to comply with the new role column system (#39). Column names have also been homogenised (#46).

* `$to_yaml()` now preserves line breaks preceding leading or isolated `---` (#37).

* `plm_template()` now returns role columns as numeric type (#26).

* Initials now drop dots present in author names (#31).

* plume classes now error when a role column contains multiple roles (#28).

# plume 0.1.0

First CRAN release.
