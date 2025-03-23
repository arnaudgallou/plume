# get_conctact_details() gives meaningful error messages

    Code
      (expect_error(aut$get_contact_details("foo")))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! `template` must be a glue specification.
    Code
      (expect_error(aut$get_contact_details("{foo}")))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! Invalid variable `foo`.
      i `template` must use variables `name` and/or `details`.
    Code
      (expect_error(aut$get_contact_details()))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! Column `corresponding` doesn't exist.
      i Did you forget to assign corresponding authors?
      i Use `set_corresponding_authors()` to set corresponding authors.
    Code
      (expect_error(aut$get_contact_details(email = 1)))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! `email` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contact_details(sep = NULL)))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_contact_details(sep = "")))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! `sep` must be a non-empty string.
    Code
      aut$set_corresponding_authors(1)
      (expect_error(aut$get_contact_details(fax = TRUE)))
    Output
      <error/rlang_error>
      Error in `aut$get_contact_details()`:
      ! Column `fax` doesn't exist.

