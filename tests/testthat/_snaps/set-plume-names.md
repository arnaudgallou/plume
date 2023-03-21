# set_default_names() gives meaningful error messages

    Code
      (expect_error(set_default_names(1)))
    Output
      <error/rlang_error>
      Error:
      ! `...` inputs must be character vectors.
    Code
      (expect_error(set_default_names("a")))
    Output
      <error/rlang_error>
      Error:
      ! All `...` inputs must be named.
    Code
      (expect_error(set_default_names(c(x = "a", y = "a"))))
    Output
      <error/rlang_error>
      Error:
      ! `...` must have unique input values.
    Code
      (expect_error(set_default_names(c(x = "a", x = "b"))))
    Output
      <error/rlang_error>
      Error:
      ! `...` must have unique input names.

