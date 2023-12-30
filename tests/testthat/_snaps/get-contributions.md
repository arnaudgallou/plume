# specifying roles inside columns is deprecated

    Code
      aut <- Plume$new(data.frame(given_name = "Zip", family_name = "Zap", role = "a"))
    Condition
      Warning:
      Defining explicit roles in the input data was deprecated in plume 0.2.0.
      i Please use the `roles` argument of `new()` instead.
      i See <https://arnaudgallou.github.io/plume/articles/plume.html#defining-roles-and-contributors>.

# `credit_roles = TRUE` is deprecated

    Code
      aut <- Plume$new(data.frame(given_name = "Zip", family_name = "Zap", analysis = 1),
      credit_roles = TRUE)
    Condition
      Warning:
      The `credit_roles` argument of `new()` is deprecated as of plume 0.2.0.
      i Please use `roles = credit_roles()` instead.

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

