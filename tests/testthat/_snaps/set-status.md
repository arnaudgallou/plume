# set_*() methods give meaningful error messages

    Code
      (expect_error(aut$set_corresponding_authors()))
    Output
      <error/rlang_error>
      Error in `aut$set_corresponding_authors()`:
      ! `...` must not be empty.
    Code
      (expect_error(aut$set_corresponding_authors(a, .by = "foo")))
    Output
      <error/rlang_error>
      Error in `aut$set_corresponding_authors()`:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_corresponding_authors(a, .by = "")))
    Output
      <error/rlang_error>
      Error in `aut$set_corresponding_authors()`:
      ! `.by` must be a non-empty string.
    Code
      (expect_error(aut$set_corresponding_authors(a, .by = 1)))
    Output
      <error/rlang_error>
      Error in `aut$set_corresponding_authors()`:
      ! `.by` must be a character string.
    Code
      (expect_error(aut$set_corresponding_authors(x <- y)))
    Output
      <error/rlang_error>
      Error in `aut$set_corresponding_authors()`:
      ! Can't match elements with `x <- y`.
    Code
      (expect_error(aut$set_cofirst_authors(a, .by = "foo")))
    Output
      <error/rlang_error>
      Error in `aut$set_cofirst_authors()`:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_cofirst_authors(a, .by = "")))
    Output
      <error/rlang_error>
      Error in `aut$set_cofirst_authors()`:
      ! `.by` must be a non-empty string.
    Code
      (expect_error(aut$set_cofirst_authors(a, .by = 1)))
    Output
      <error/rlang_error>
      Error in `aut$set_cofirst_authors()`:
      ! `.by` must be a character string.
    Code
      (expect_error(aut$set_deceased(a, .by = "foo")))
    Output
      <error/rlang_error>
      Error in `aut$set_deceased()`:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_deceased(a, .by = "")))
    Output
      <error/rlang_error>
      Error in `aut$set_deceased()`:
      ! `.by` must be a non-empty string.
    Code
      (expect_error(aut$set_deceased(a, .by = 1)))
    Output
      <error/rlang_error>
      Error in `aut$set_deceased()`:
      ! `.by` must be a character string.

# everyone*() selectors error if used in a wrong context

    Code
      everyone()
    Condition
      Error in `everyone()`:
      ! `everyone()` must be used within a *status setter* method.

