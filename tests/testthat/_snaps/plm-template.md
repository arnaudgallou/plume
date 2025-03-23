# plm_template() gives meaningful error messages

    Code
      (expect_error(plm_template(minimal = 1)))
    Output
      <error/rlang_error>
      Error in `plm_template()`:
      ! `minimal` must be `TRUE` or `FALSE`.
    Code
      (expect_error(plm_template(role_cols = 1)))
    Output
      <error/rlang_error>
      Error in `plm_template()`:
      ! `role_cols` must be a character vector.
    Code
      (expect_error(plm_template(role_cols = c("foo", "foo"))))
    Output
      <error/rlang_error>
      Error in `plm_template()`:
      ! `role_cols` must have unique input values.

