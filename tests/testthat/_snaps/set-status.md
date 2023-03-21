# set_*() methods give meaningful error messages

    Code
      (expect_error(aut$set_corresponding_authors(a, by = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_corresponding_authors(a, by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a non-empty string.
    Code
      (expect_error(aut$set_corresponding_authors(a, by = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a character string.
    Code
      (expect_error(aut$set_equal_contributor(a, by = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_equal_contributor(a, by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a non-empty string.
    Code
      (expect_error(aut$set_equal_contributor(a, by = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a character string.
    Code
      (expect_error(aut$set_deceased(a, by = "foo")))
    Output
      <error/rlang_error>
      Error:
      ! Column `foo` doesn't exist.
    Code
      (expect_error(aut$set_deceased(a, by = "")))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a non-empty string.
    Code
      (expect_error(aut$set_deceased(a, by = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `by` must be a character string.

