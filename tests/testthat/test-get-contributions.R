test_that("get_contributions() return authors' contributions", {
  df <- basic_df()
  aut <- Plume$new(df)

  expect_s3_class(aut$get_contributions(), c("plm_agt", "plm"))

  df_roles <- select(df, starts_with("role"))
  initials <- dot(df$initials)
  list_initials <- list(initials, initials[1])

  # contributors-roles combinations

  roles <- apply(t(df_roles), 2, \(x) enumerate(na.omit(x)))
  contributors <- initials

  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = TRUE),
    paste0(contributors, ": ", roles)
  )
  expect_equal(
    aut$get_contributions(roles_first = TRUE, by_author = TRUE),
    paste0(roles, ": ", contributors)
  )

  roles <- condense(c(df_roles))
  contributors <- lapply(list_initials, enumerate)

  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = FALSE),
    paste0(contributors, ": ", roles)
  )
  expect_equal(
    aut$get_contributions(roles_first = TRUE, by_author = FALSE),
    paste0(roles, ": ", contributors)
  )

  # other arguments

  expect_equal(
    aut$get_contributions(by_author = FALSE, divider = " "),
    paste0(roles, " ", contributors)
  )

  contributors <- lapply(list_initials, \(x) enumerate(sort(x)))

  expect_equal(
    aut$get_contributions(by_author = FALSE, alphabetical_order = TRUE),
    paste0(roles, ": ", contributors)
  )

  contributors <- lapply(list_initials, \(x) enumerate(x, last = " & "))

  expect_equal(
    aut$get_contributions(by_author = FALSE, sep_last = " & "),
    paste0(roles, ": ", contributors)
  )

  list_initials <- list(df$initials, df$initials[1])
  contributors <- lapply(list_initials, enumerate)

  expect_equal(
    aut$get_contributions(by_author = FALSE, dotted_initials = FALSE),
    paste0(roles, ": ", contributors)
  )

  list_literal_names <- list(df$literal_name, df$literal_name[1])
  contributors <- lapply(list_literal_names, enumerate)

  expect_equal(
    aut$get_contributions(by_author = FALSE, literal_names = TRUE),
    paste0(roles, ": ", contributors)
  )
})

test_that("get_contributions() rearranges authors only (#18)", {
  aut <- Plume$new(data.frame(
    given_name = c("Zip", "Pim"),
    family_name = c("Zap", "Pam"),
    role_1 = c("z", NA),
    role_2 = c("a", "a")
  ))

  expect_equal(
    aut$get_contributions(alphabetical_order = TRUE),
    c("z: Z.Z.", "a: P.P. and Z.Z.")
  )
  expect_equal(
    aut$get_contributions(by_author = TRUE, alphabetical_order = TRUE),
    c("z and a: Z.Z.", "a: P.P.")
  )
})

test_that("get_contributions() handles namesakes (#15)", {
  aut <- Plume$new(data.frame(
    given_name = c("Zip", "Zip"),
    family_name = c("Zap", "Zap"),
    role_1 = c("a", NA),
    role_2 = c("b", "b")
  ))

  expect_equal(
    aut$get_contributions(roles_first = FALSE),
    c("Z.Z.: a", "Z.Z. and Z.Z.: b")
  )
  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = TRUE),
    c("Z.Z.: a and b", "Z.Z.: b")
  )
})

# Errors ----

test_that("get_contributions() gives meaningful error messages", {
  aut <- Plume$new(basic_df())

  expect_snapshot({
    (expect_error(
      aut$get_contributions(roles_first = "")
    ))
    (expect_error(
      aut$get_contributions(by_author = "")
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
