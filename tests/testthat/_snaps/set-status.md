# the `by` parameter is deprecated

    Code
      aut <- Plume$new(basic_df)
      aut$set_corresponding_authors(zip, by = "given_name")
    Condition
      Warning:
      The `by` argument of `set_corresponding_author()` is deprecated as of plume 0.2.0.
      i Please use the `.by` argument instead.

# set_equal_contributor() is deprecated

    Code
      aut <- PlumeQuarto$new(basic_df, tempfile_())
      aut$set_equal_contributor(1, 3)
    Condition
      Warning:
      `set_equal_contributor()` was deprecated in plume 0.2.0.
      i Please use `set_cofirst_authors()` instead.

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
      (expect_error(everyone()))
    Output
      <error/rlang_error>
      Error:
      ! `everyone()` must be used within a *status setter* method.
    Code
      (expect_error(everyone_but()))
    Condition
      Warning:
      `everyone_but()` was deprecated in plume 0.2.0.
    Output
      <error/rlang_error>
      Error:
      ! `everyone_but()` must be used within a *status setter* method.

