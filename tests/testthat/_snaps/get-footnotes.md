# get_affiliations() give meaningful error messages

    Code
      (expect_error(aut$get_affiliations(sep = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_affiliations(superscript = "")))
    Output
      <error/rlang_error>
      Error:
      ! `superscript` must be `TRUE` or `FALSE`.

# get_notes() give meaningful error messages

    Code
      (expect_error(aut$get_notes(sep = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_notes(superscript = "")))
    Output
      <error/rlang_error>
      Error:
      ! `superscript` must be `TRUE` or `FALSE`.

