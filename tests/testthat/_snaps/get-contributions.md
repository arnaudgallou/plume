# get_contributions() gives meaningful error messages

    Code
      (expect_error(aut$get_contributions(role_first = "")))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 1.
      Caused by error:
      ! `role_first` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(name_list = "")))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 2.
      Caused by error:
      ! `name_list` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(alphabetical_order = "")))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 3.
      Caused by error:
      ! `alphabetical_order` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(dotted_initials = "")))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 4.
      Caused by error:
      ! `dotted_initials` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(literal_name = "")))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 5.
      Caused by error:
      ! `literal_name` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(sep_last = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 1.
      Caused by error:
      ! `sep_last` must be a character string.
    Code
      (expect_error(aut$get_contributions(divider = 1)))
    Output
      <error/purrr_error_indexed>
      Error in `map2()`:
      i In index: 2.
      Caused by error:
      ! `divider` must be a character string.

