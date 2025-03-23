# get_affiliations()/get_notes() give meaningful error messages

    Code
      (expect_error(aut$get_affiliations(sep = 1)))
    Output
      <error/rlang_error>
      Error in `aut$get_affiliations()`:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_affiliations(superscript = "")))
    Output
      <error/rlang_error>
      Error in `aut$get_affiliations()`:
      ! `superscript` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_notes(sep = 1)))
    Output
      <error/rlang_error>
      Error in `aut$get_notes()`:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_notes(superscript = "")))
    Output
      <error/rlang_error>
      Error in `aut$get_notes()`:
      ! `superscript` must be `TRUE` or `FALSE`.

---

    Code
      (expect_error(aut$get_affiliations()))
    Output
      <error/rlang_error>
      Error in `aut$get_affiliations()`:
      ! Column `affiliation` doesn't exist.
    Code
      (expect_error(aut$get_notes()))
    Output
      <error/rlang_error>
      Error in `aut$get_notes()`:
      ! Column `note` doesn't exist.

