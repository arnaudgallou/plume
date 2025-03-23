# initialize() gives meaningful error messages

    Code
      (expect_error(Plume$new(list(x = 1))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `data` must be a data frame or tibble.
    Code
      (expect_error(Plume$new(data.frame(family_name = "x"))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! Column `given_name` doesn't exist.
    Code
      (expect_error(Plume$new(data.frame(given_name = "x", family_name = ""))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! Missing author name found in position 1.
      i All authors must have a given and family name.
    Code
      (expect_error(Plume$new(data.frame(given_name = "x"))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! Column `family_name` doesn't exist.
    Code
      (expect_error(Plume$new(basic_df, names = list(given_name = "prénom"))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `names` must be a character vector.
    Code
      (expect_error(Plume$new(basic_df, names = "prénom")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! All `names` inputs must be named.
    Code
      (expect_error(Plume$new(basic_df, names = c(given_name = "prénom", family_name = "prénom")))
      )
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `names` must have unique input values.
    Code
      (expect_error(Plume$new(basic_df, names = c(given_name = "prénom", given_name = "nom")))
      )
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `names` must have unique input names.
    Code
      (expect_error(Plume$new(basic_df, symbols = c(note = letters))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `symbols` must be a list.
    Code
      (expect_error(Plume$new(basic_df, symbols = list(note = NULL, note = NULL))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `symbols` must have unique input names.
    Code
      (expect_error(Plume$new(basic_df, orcid_icon = NULL)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! Invalid `orcid_icon` input.
      i Use `icn_orcid()` to set the ORCID icon.
    Code
      (expect_error(Plume$new(basic_df, initials_given_name = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `initials_given_name` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(basic_df, family_name_first = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `family_name_first` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(basic_df, credit_roles = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `credit_roles` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(basic_df, interword_spacing = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `interword_spacing` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(basic_df, roles = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `roles` must be a character vector.
    Code
      (expect_error(Plume$new(basic_df, roles = "foo")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! All `roles` inputs must be named.
    Code
      (expect_error(Plume$new(basic_df, roles = c(role = "foo", role = "bar"))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `roles` must have unique input names.
    Code
      (expect_error(Plume$new(basic_df, roles = c(role = "foo", role_2 = "foo"))))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `roles` must have unique input values.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `file` must be a character string.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = "")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `file` must be a non-empty string.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = "test.rmd")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `file` must be a `.qmd`, `.yml` or `.yaml` file.
    Code
      (expect_error(PlumeQuarto$new(basic_df, file = "~/test.qmd")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `~/test.qmd` doesn't exist.
    Code
      (expect_error(PlumeQuarto$new(basic_df, temp_file(), by = 1)))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `by` must be a character string.
    Code
      (expect_error(PlumeQuarto$new(basic_df, temp_file(), by = "")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! `by` must be a non-empty string.
    Code
      (expect_error(PlumeQuarto$new(basic_df, temp_file(), by = "foo")))
    Output
      <error/rlang_error>
      Error in `initialize()`:
      ! Column `foo` doesn't exist.

