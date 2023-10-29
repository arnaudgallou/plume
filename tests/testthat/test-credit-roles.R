test_that("credit_roles() returns CRediT roles", {
  expect_snapshot(credit_roles())
  expect_snapshot(credit_roles(oxford_spelling = FALSE))
})

# Errors ----

test_that("credit_roles() gives meaningful error messages", {
  expect_snapshot({
    credit_roles(oxford_spelling = 1)
  }, error = TRUE)
})
