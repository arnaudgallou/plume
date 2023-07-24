test_that("sequences of characters are properly generated", {
  df <- data.frame(given_name = "X", family_name = "Y", affiliation = 1:55)
  aut <- Plume$new(df, symbols = list(affiliation = letters))

  .h <- paste0("X Y", c("a", "b", "c", "d", "e", "f"))

  expect_equal(head(aut$get_author_list("a")), .h)
  expect_equal(
    tail(aut$get_author_list("a")),
    paste0("X Y", c("xx", "yy", "zz", "aaa", "bbb", "ccc"))
  )

  aut <- Plume$new(df, symbols = list(affiliation = sequential(letters)))

  expect_equal(head(aut$get_author_list("a")), .h)
  expect_equal(
    tail(aut$get_author_list("a")),
    paste0("X Y", c("ax", "ay", "az", "ba", "bb", "bc"))
  )
})

# Errors ----

test_that("sequential() gives meaningful error messages", {
  expect_snapshot(sequential(1), error = TRUE)
})
