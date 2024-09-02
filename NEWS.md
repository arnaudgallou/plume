# plume 0.2.5

* `$get_author_list(suffix =)` is now slightly more flexible and will try less hard to sanitise author list suffixes (#90).

* `PlumeQuarto` no longer converts roles to lower case (#88).

* `PlumeQuarto` now supports authors' `degrees` and the `group` affiliation property (#53).

* `PlumeQuarto` now properly handles authors with no roles (#81).

* `PlumeQuarto` now supports `.yml` and `.yaml` files (#82).

# plume 0.2.4

* Tweaked some examples in the vignettes and expand the `Contributions` section in `vignette("plume")`.

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

* New helper `credit_roles()` that returns the 14 contributor roles of the [Contributor Roles Taxonomy](https://credit.niso.org). These are now the default roles used by plume.

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

    And speficy roles when creating a `plume` object:

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
