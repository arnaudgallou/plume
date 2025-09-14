test_that("plm_symbols() returns a list of symbols", {
  expect_snapshot(str(plm_symbols()))
})

# Errors ----

test_that("plm_symbols() gives meaningful error messages", {
  expect_snapshot(plm_symbols(affiliation = 1), error = TRUE)
})
