test_that("as_lines() prints vector elements on distinct lines", {
  expect_output(as_lines("a", "b"), "a\\R{2}b", perl = TRUE)
})
