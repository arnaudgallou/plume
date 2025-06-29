test_that("get_contributions() return authors' contributions", {
  aut <- Plume$new(basic_df, roles = c(analysis = "a", writing = "b"))

  expect_s3_class(aut$get_contributions(), "plm")

  # contributors-roles combinations

  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = TRUE),
    c("Z.Z.: a and b", "R.R.: a", "P.-P.P.: a")
  )
  expect_equal(
    aut$get_contributions(roles_first = TRUE, by_author = TRUE),
    c("a and b: Z.Z.", "a: R.R.", "a: P.-P.P.")
  )
  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = FALSE),
    c("Z.Z., R.R. and P.-P.P.: a", "Z.Z.: b")
  )
  expect_equal(
    aut$get_contributions(roles_first = TRUE, by_author = FALSE),
    c("a: Z.Z., R.R. and P.-P.P.", "b: Z.Z.")
  )

  # other arguments

  expect_equal(
    aut$get_contributions(by_author = FALSE, divider = " "),
    c("a Z.Z., R.R. and P.-P.P.", "b Z.Z.")
  )
  expect_equal(
    aut$get_contributions(by_author = FALSE, alphabetical_order = TRUE),
    c("a: P.-P.P., R.R. and Z.Z.", "b: Z.Z.")
  )
  expect_equal(
    aut$get_contributions(by_author = FALSE, sep = "; "),
    c("a: Z.Z.; R.R. and P.-P.P.", "b: Z.Z.")
  )
  expect_equal(
    aut$get_contributions(by_author = FALSE, sep_last = " & "),
    c("a: Z.Z., R.R. & P.-P.P.", "b: Z.Z.")
  )
  expect_equal(
    aut$get_contributions(by_author = FALSE, literal_names = TRUE),
    c("a: Zip Zap, Ric Rac and Pim-Pam Pom", "b: Zip Zap")
  )
})

test_that("get_contributions() returns `NULL` if no contributions", {
  aut <- Plume$new(data.frame(
    given_name = "Zip",
    family_name = "Zap",
    analysis = ""
  ))
  expect_null(aut$get_contributions())
})

test_that("get_contributions() rearranges authors only (#18)", {
  aut <- Plume$new(
    data.frame(
      given_name = c("Zip", "Pim"),
      family_name = c("Zap", "Pam"),
      role_1 = c(1, NA),
      role_2 = c(1, 1)
    ),
    roles = c(role_1 = "z", role_2 = "a")
  )

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
  aut <- Plume$new(
    data.frame(
      given_name = c("Zip", "Zip"),
      family_name = c("Zap", "Zap"),
      role_1 = c(1, NA),
      role_2 = c(1, 1)
    ),
    roles = c(role_1 = "a", role_2 = "b")
  )

  expect_equal(
    aut$get_contributions(roles_first = FALSE),
    c("Z.Z.: a", "Z.Z. and Z.Z.: b")
  )
  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = TRUE),
    c("Z.Z.: a and b", "Z.Z.: b")
  )
})

test_that("get_contributions() reorders CRediT roles alphabetically", {
  aut <- Plume$new(data.frame(
    given_name = c("Zip", "Ric"),
    family_name = c("Zap", "Rac"),
    writing = c(1, NA),
    analysis = c(NA, 1)
  ), roles = credit_roles())

  expect_equal(
    aut$get_contributions(),
    c("Formal analysis: R.R.", "Writing - original draft: Z.Z.")
  )
})

test_that("author order is preserved when using CRediT and `by_author` (#50)", {
  aut <- Plume$new(data.frame(
    given_name = c("Z", "A"),
    family_name = c("Z", "A"),
    writing = c(1, NA),
    analysis = c(NA, 1)
  ))
  expect_equal(
    aut$get_contributions(roles_first = FALSE, by_author = TRUE),
    c("Z.Z.: Writing - original draft", "A.A.: Formal analysis")
  )
})

test_that("set_main_contributors() ranks contributors", {
  aut <- Plume$new(
    data.frame(
      given_name = c("C", "B", "A"),
      family_name = c("C", "B", "A"),
      writing = rep(1, 3),
      analysis = rep(1, 3)
    ),
    roles = c(writing = "Writing", analysis = "Analysis")
  )

  aut$set_main_contributors(3, 2, .roles = "writing")
  expect_equal(
    aut$get_contributions(),
    c("Writing: A.A., B.B. and C.C.", "Analysis: C.C., B.B. and A.A.")
  )

  aut$set_main_contributors(2, .roles = "writing")
  expect_equal(
    aut$get_contributions(alphabetical_order = TRUE),
    c("Writing: B.B., A.A. and C.C.", "Analysis: A.A., B.B. and C.C.")
  )

  aut$set_main_contributors(writing = c(3, 2))
  expect_equal(
    aut$get_contributions(),
    c("Writing: A.A., B.B. and C.C.", "Analysis: C.C., B.B. and A.A.")
  )

  aut$set_main_contributors(3, .roles = c("writing", "analysis", "test"))
  expect_equal(
    aut$get_contributions(),
    c("Writing: A.A., C.C. and B.B.", "Analysis: A.A., C.C. and B.B.")
  )

  aut$set_main_contributors(writing = a.a., analysis = b.b., .by = "initials")
  expect_equal(
    aut$get_contributions(),
    c("Writing: A.A., C.C. and B.B.", "Analysis: B.B., C.C. and A.A.")
  )

  aut$set_main_contributors(
    writing = c(a.a., b.b.), analysis = b.b.,
    .by = "initials"
  )
  expect_equal(
    aut$get_contributions(),
    c("Writing: A.A., B.B. and C.C.", "Analysis: B.B., C.C. and A.A.")
  )
})

# Errors ----

test_that("get_contributions() gives meaningful error messages", {
  aut <- Plume$new(basic_df)

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
      aut$get_contributions(literal_names = "")
    ))
    (expect_error(
      aut$get_contributions(sep = 1)
    ))
    (expect_error(
      aut$get_contributions(sep_last = 1)
    ))
    (expect_error(
      aut$get_contributions(divider = 1)
    ))
  })

  aut <- Plume$new(data.frame(given_name = "A", family_name = "B"))
  expect_snapshot(aut$get_contributions(), error = TRUE)
})
