test_that("plm_symbols() returns a list of symbols", {
  expect_snapshot(plm_symbols())
  expect_s3_class(plm_symbols(), "plm_list")
})

# Errors ----

test_that("plm_symbols() gives meaningful error messages", {
  expect_snapshot(plm_symbols(affiliation = 1), error = TRUE)
})
