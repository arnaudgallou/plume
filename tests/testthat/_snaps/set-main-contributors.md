# set_ranks() gives meaningful error messages

    Code
      (expect_error(aut$set_main_contributors()))
    Output
      <error/rlang_error>
      Error in `aut$set_main_contributors()`:
      ! `...` must not be empty.
    Code
      (expect_error(aut$set_main_contributors(1, .roles = 1)))
    Output
      <error/rlang_error>
      Error in `aut$set_main_contributors()`:
      ! `.roles` must be a character vector.
    Code
      (expect_error(aut$set_main_contributors(1, .roles = c("x", "x"))))
    Output
      <error/rlang_error>
      Error in `aut$set_main_contributors()`:
      ! `.roles` must have unique input values.
    Code
      (expect_error(aut$set_main_contributors(1, .by = 1)))
    Output
      <error/rlang_error>
      Error in `aut$set_main_contributors()`:
      ! `.by` must be a character string.

