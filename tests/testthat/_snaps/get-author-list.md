# get_author_list() gives meaningful error messages

    Code
      (expect_error(aut$get_author_list(format = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `format` must be a character string.
    Code
      (expect_error(aut$get_author_list(format = "")))
    Output
      <error/rlang_error>
      Error:
      ! `format` must have at least one key.
    Code
      (expect_error(aut$get_author_list(format = "anca")))
    Output
      <error/rlang_error>
      Error:
      ! `format` must have unique keys.
    Code
      (expect_error(aut$get_author_list(format = "az")))
    Output
      <error/rlang_error>
      Error:
      ! `format` must only contain any of `a`, `c`, `n`, `o`, `^` or `,`.
    Code
      (expect_error(aut$get_author_list(format = "ac")))
    Output
      <error/rlang_error>
      Error:
      ! Column `corresponding` doesn't exist.
    Code
      (expect_error(aut$get_author_list(format = "o")))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 1.
      i With name: orcid.
      Caused by error:
      ! Invalid ORCID identifier found: `0000`.
      i ORCID identifiers must have 16 digits, separated by a hyphen every 4 digits.
      i The last character of the identifier must be a digit or `X`.

