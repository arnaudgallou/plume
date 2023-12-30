# `credit_roles = TRUE` is deprecated

    Code
      tbl <- plm_template(credit_roles = TRUE)
    Condition
      Warning:
      The `credit_roles` argument of `plm_template()` is deprecated as of plume 0.2.0.
      i Please use `role_cols = credit_roles()` instead.

# plm_template() gives meaningful error messages

    Code
      (expect_error(plm_template(minimal = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `minimal` must be `TRUE` or `FALSE`.
    Code
      (expect_error(plm_template(role_cols = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `role_cols` must be a character vector.
    Code
      (expect_error(plm_template(role_cols = c("foo", "foo"))))
    Output
      <error/rlang_error>
      Error:
      ! `role_cols` must have unique input values.
    Code
      (expect_error(plm_template(credit_roles = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `credit_roles` must be `TRUE` or `FALSE`.

