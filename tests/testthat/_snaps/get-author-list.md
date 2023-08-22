# get_author_list() makes ORCID icons

    Code
      aut$get_author_list("o")
    Output
      Zip Zap[\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0001)
      Ric Rac[\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0002)
      Pim-Pam Pom

# get_author_list() gives meaningful error messages

    Code
      (expect_error(aut$get_author_list(format = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `format` must be a character string.
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
      i The last character of the identifiers must be a digit or `X`.

