# initialize() gives meaningful error messages

    Code
      (expect_error(Plume$new(list(x = 1))))
    Output
      <error/rlang_error>
      Error:
      ! `data` must be a data frame or tibble.
    Code
      (expect_error(Plume$new(data.frame(family_name = "x"))))
    Output
      <error/rlang_error>
      Error:
      ! Column `given_name` doesn't exist.
    Code
      (expect_error(Plume$new(data.frame(given_name = "x", family_name = ""))))
    Output
      <error/rlang_error>
      Error:
      ! Missing author name found in position 1.
      i All authors must have a given and family name.
    Code
      (expect_error(Plume$new(data.frame(given_name = "x"))))
    Output
      <error/rlang_error>
      Error:
      ! Column `family_name` doesn't exist.
    Code
      (expect_error(Plume$new(df, names = list(given_name = "prénom"))))
    Output
      <error/rlang_error>
      Error:
      ! `names` must be a character vector.
    Code
      (expect_error(Plume$new(df, names = "prénom")))
    Output
      <error/rlang_error>
      Error:
      ! All `names` inputs must be named.
    Code
      (expect_error(Plume$new(df, names = c(given_name = "prénom", family_name = "prénom")))
      )
    Output
      <error/rlang_error>
      Error:
      ! `names` must have unique input values.
    Code
      (expect_error(Plume$new(df, names = c(given_name = "prénom", given_name = "nom")))
      )
    Output
      <error/rlang_error>
      Error:
      ! `names` must have unique input names.
    Code
      (expect_error(Plume$new(df, symbols = c(note = letters))))
    Output
      <error/rlang_error>
      Error:
      ! `symbols` must be a list.
    Code
      (expect_error(Plume$new(df, symbols = list(note = NULL, note = NULL))))
    Output
      <error/rlang_error>
      Error:
      ! `symbols` must have unique input names.
    Code
      (expect_error(Plume$new(df, orcid_icon = NULL)))
    Output
      <error/rlang_error>
      Error:
      ! Invalid `orcid_icon` input.
      i Use `orcid()` to set the ORCID icon.
    Code
      (expect_error(Plume$new(df, initials_given_name = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 2.
      Caused by error:
      ! `initials_given_name` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(df, family_name_first = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 3.
      Caused by error:
      ! `family_name_first` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(df, credit_roles = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 1.
      Caused by error:
      ! `credit_roles` must be `TRUE` or `FALSE`.
    Code
      (expect_error(Plume$new(df, interword_spacing = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 4.
      Caused by error:
      ! `interword_spacing` must be `TRUE` or `FALSE`.
    Code
      (expect_error(PlumeQuarto$new(df, tempfile_(), by = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a character string.
    Code
      (expect_error(PlumeQuarto$new(df, tempfile_(), by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a non-empty string.
    Code
      (expect_error(PlumeQuarto$new(df, tempfile_(), by = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Column `foo` doesn't exist.

