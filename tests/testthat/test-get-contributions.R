test_that("get_contributions() return authors' contributions", {
  df <- basic_df()
  aut <- Plume$new(df)

  expect_s3_class(aut$get_contributions(), c("plm_agt", "plm"))

  df_roles <- select(df, starts_with("role"))

  literal_names <- paste0(df$given_name, df$family_name)
  initials <- make_initials(literal_names)
  list_initials <- list(initials, initials[1])

  roles <- condense(c(df_roles))
  contributors <- lapply(list_initials, \(x) enumerate(dot(x)))

  expect_equal(
    aut$get_contributions(),
    paste0(roles, ": ", contributors)
  )

  contributors <- lapply(list_initials, enumerate)

  expect_equal(
    aut$get_contributions(dotted_initials = FALSE),
    paste0(roles, ": ", contributors)
  )
  expect_equal(
    aut$get_contributions(dotted_initials = FALSE, divider = " - "),
    paste0(roles, " - ", contributors)
  )
  expect_equal(
    aut$get_contributions(
      role_first = FALSE,
      name_list = TRUE,
      dotted_initials = FALSE
    ),
    paste0(contributors, " ", roles)
  )

  contributors <- lapply(list_initials, \(x) enumerate(x, last = " & "))

  expect_equal(
    aut$get_contributions(dotted_initials = FALSE, sep_last = " & "),
    paste0(roles, ": ", contributors)
  )

  contributors <- lapply(list_initials, \(x) enumerate(sort(x)))

  expect_equal(
    aut$get_contributions(alphabetical_order = TRUE, dotted_initials = FALSE),
    paste0(roles, ": ", contributors)
  )

  literal_names <- df$literal_name
  roles <- apply(t(df_roles), 2, \(x) {
    enumerate(na.omit(x))
  })

  expect_equal(
    aut$get_contributions(role_first = FALSE, literal_names = TRUE),
    paste0(literal_names, ": ", roles)
  )
})

# Errors ----

test_that("get_contributions() gives meaningful error messages", {
  aut <- Plume$new(basic_df())

  expect_snapshot({
    (expect_error(
      aut$get_contributions(role_first = "")
    ))
    (expect_error(
      aut$get_contributions(name_list = "")
    ))
    (expect_error(
      aut$get_contributions(alphabetical_order = "")
    ))
    (expect_error(
      aut$get_contributions(dotted_initials = "")
    ))
    (expect_error(
      aut$get_contributions(literal_names = "")
    ))
    (expect_error(
      aut$get_contributions(sep_last = 1)
    ))
    (expect_error(
      aut$get_contributions(divider = 1)
    ))
  })
})
