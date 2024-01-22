# get_author_list() makes ORCID icons

    Code
      aut$get_author_list("o")
    Output
      Zip Zap[\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0001)
      Ric Rac[\hspace{3pt}![](orcid.pdf){height=16px}\hspace{3pt}](https://orcid.org/0000-0000-0000-0002)
      Pim-Pam Pom

# `format` is deprecated

    Code
      author_list <- aut$get_author_list(format = "a")
    Condition
      Warning:
      The `format` argument of `get_author_list()` is deprecated as of plume 0.2.0.
      i Please use the `suffix` argument instead.

# get_author_list() gives meaningful error messages

    Code
      (expect_error(aut$get_author_list(1)))
    Output
      <error/rlang_error>
      Error:
      ! `suffix` must be a character string.
    Code
      (expect_error(aut$get_author_list("anca")))
    Output
      <error/rlang_error>
      Error:
      ! `suffix` must have unique keys.
    Code
      (expect_error(aut$get_author_list("az")))
    Output
      <error/rlang_error>
      Error:
      ! `suffix` must only contain any of `a`, `c`, `n`, `o`, `^` or `,`.
    Code
      (expect_error(aut$get_author_list("ac")))
    Output
      <error/rlang_error>
      Error:
      ! Column `corresponding` doesn't exist.
      i Did you forget to assign corresponding authors?
      i Use `set_corresponding_authors()` to set corresponding authors.
    Code
      (expect_error(aut$get_author_list("o")))
    Output
      <error/rlang_error>
      Error:
      ! Invalid ORCID identifier found: `0000`.
      i ORCID identifiers must have 16 digits, separated by a hyphen every 4 digits.
      i The last character of the identifiers must be a digit or `X`.

