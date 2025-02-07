# the `by` parameter is deprecated

    Code
      aut$set_corresponding_authors(zip, by = "given_name")
    Condition
      Error:
      ! The `by` argument of `set_corresponding_author()` was deprecated in plume 0.2.0 and is now defunct.
      i Please use the `.by` argument instead.

# set_equal_contributor() is deprecated

    Code
      aut$set_equal_contributor(1, 3)
    Condition
      Error:
      ! `set_equal_contributor()` was deprecated in plume 0.2.0 and is now defunct.
      i Please use `set_cofirst_authors()` instead.

# everyone_but() is deprecated

    Code
      aut$set_corresponding_authors(everyone_but(ric))
    Condition
      Error:
      ! `everyone_but()` was deprecated in plume 0.2.0 and is now defunct.

# set_*() methods give meaningful error messages

    Code
      (expect_error(aut$set_corresponding_authors()))
    Output
      <error/rlang_error>
      Error:
      ! `...` must not be empty.
    Code
      (expect_error(aut$set_corresponding_authors(a, .by = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_corresponding_authors(a, .by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `.by` must be a non-empty string.
    Code
      (expect_error(aut$set_corresponding_authors(a, .by = 1)))
    Output
      <error/rlang_error>
      Error:
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
      Error:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_cofirst_authors(a, .by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `.by` must be a non-empty string.
    Code
      (expect_error(aut$set_cofirst_authors(a, .by = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `.by` must be a character string.
    Code
      (expect_error(aut$set_deceased(a, .by = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_deceased(a, .by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `.by` must be a non-empty string.
    Code
      (expect_error(aut$set_deceased(a, .by = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `.by` must be a character string.

# everyone*() selectors error if used in a wrong context

    Code
      everyone()
    Condition
      Error:
      ! `everyone()` must be used within a *status setter* method.

