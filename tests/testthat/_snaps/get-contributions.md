# get_contributions() gives meaningful error messages

    Code
      (expect_error(aut$get_contributions(roles_first = "")))
    Output
      <error/rlang_error>
      Error:
      ! `roles_first` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(by_author = "")))
    Output
      <error/rlang_error>
      Error:
      ! `by_author` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(alphabetical_order = "")))
    Output
      <error/rlang_error>
      Error:
      ! `alphabetical_order` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(dotted_initials = "")))
    Output
      <error/rlang_error>
      Error:
      ! `dotted_initials` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(literal_names = "")))
    Output
      <error/rlang_error>
      Error:
      ! `literal_names` must be `TRUE` or `FALSE`.
    Code
      (expect_error(aut$get_contributions(sep = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `sep` must be a character string.
    Code
      (expect_error(aut$get_contributions(sep_last = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `sep_last` must be a character string.
    Code
      (expect_error(aut$get_contributions(divider = 1)))
    Output
      <error/rlang_error>
      Error:
      ! `divider` must be a character string.

