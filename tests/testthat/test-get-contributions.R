test_that("get_contributions() return authors' contributions", {
  df <- basic_df()
  aut <- Plume$new(df)

  df_contributions <- select(df, starts_with("contribution"))

  literal_names <- paste0(df$given_name, df$family_name)
  initials <- make_initials(literal_names)
  list_initials <- list(initials, initials[1])

  contributions <- condense(c(df_contributions))
  contributors <- lapply(list_initials, \(x) enumerate(dot(x)))

  expect_equal_plm(
    aut$get_contributions(),
    paste0(contributions, ": ", contributors)
  )

  contributors <- lapply(list_initials, enumerate)

  expect_equal_plm(
    aut$get_contributions(dotted_initials = FALSE),
    paste0(contributions, ": ", contributors)
  )
  expect_equal_plm(
    aut$get_contributions(dotted_initials = FALSE, divider = " - "),
    paste0(contributions, " - ", contributors)
  )
  expect_equal_plm(
    aut$get_contributions(
      role_first = FALSE,
      name_list = TRUE,
      dotted_initials = FALSE
    ),
    paste0(contributors, " ", contributions)
  )

  contributors <- lapply(list_initials, \(x) enumerate(x, last = " & "))

  expect_equal_plm(
    aut$get_contributions(dotted_initials = FALSE, sep_last = " & "),
    paste0(contributions, ": ", contributors)
  )

  contributors <- lapply(list_initials, \(x) enumerate(sort(x)))

  expect_equal_plm(
    aut$get_contributions(alphabetical_order = TRUE, dotted_initials = FALSE),
    paste0(contributions, ": ", contributors)
  )

  literal_names <- df$literal_name
  contributions <- apply(t(df_contributions), 2, \(x) {
    enumerate(na.omit(x))
  })

  expect_equal_plm(
    aut$get_contributions(role_first = FALSE, literal_name = TRUE),
    paste0(literal_names, ": ", contributions)
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
      aut$get_contributions(literal_name = "")
    ))
    (expect_error(
      aut$get_contributions(sep_last = 1)
    ))
    (expect_error(
      aut$get_contributions(divider = 1)
    ))
  })
})
