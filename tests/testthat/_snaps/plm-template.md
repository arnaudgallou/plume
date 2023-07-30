# plm_template() gives meaningful error messages

    Code
      (expect_error(plm_template(minimal = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 1.
      Caused by error:
      ! `minimal` must be `TRUE` or `FALSE`.
    Code
      (expect_error(plm_template(credit_roles = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 2.
      Caused by error:
      ! `credit_roles` must be `TRUE` or `FALSE`.

