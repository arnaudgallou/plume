# get_conctact_details() gives meaningful error messages

    Code
      (expect_error(aut$get_contact_details(format = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! `format` must be a glue specification.
    Code
      (expect_error(aut$get_contact_details(format = "{foo}")))
    Output
      <error/rlang_error>
      Error:
      ! Invalid variable `foo`.
      i `format` must use variables `name` and/or `details`.
    Code
      (expect_error(aut$get_contact_details()))
    Output
      <error/rlang_error>
      Error:
      ! Column `corresponding` doesn't exist.
      i Did you forget to assign corresponding authors?
      i Use `set_corresponding_authors()` to set corresponding authors.
    Code
      (expect_error(aut$get_contact_details(email = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `email` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contact_details(sep = NULL)))
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_contact_details(sep = "")))
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a non-empty string.
    Code
      aut$set_corresponding_authors(1)
      (expect_error(aut$get_contact_details(fax = TRUE)))
    Output
      <error/rlang_error>
      Error:
      ! Column `fax` doesn't exist.

