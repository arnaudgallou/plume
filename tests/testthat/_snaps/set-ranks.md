# set_ranks() gives meaningful error messages

    Code
      (expect_error(aut$set_lead_contributors(1, roles = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `roles` must be a character vector.
    Code
      (expect_error(aut$set_lead_contributors(1, roles = c("x", "x"))))
    Output
      <error/rlang_error>
      Error:
      ! `roles` must have unique input values.

