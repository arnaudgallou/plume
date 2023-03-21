test_that("sequential() creates a logical sequence of characters", {
  values <- rep(LETTERS, 3)
  df <- data.frame(
    given_name = values,
    family_name = values,
    affiliation = seq_along(values)
  )

  aut <- Plume$new(df, interword_spacing = FALSE)
  aut$symbols$affiliation <- letters

  author_list_head <- c("AAa", "BBb", "CCc", "DDd", "EEe", "FFf")

  expect_equal(
    head(aut$get_author_list(format = "a")),
    author_list_head
  )
  expect_equal(
    tail(aut$get_author_list(format = "a")),
    c("UUuuu", "VVvvv", "WWwww", "XXxxx", "YYyyy", "ZZzzz")
  )

  aut$symbols$affiliation <- sequential(letters)

  expect_equal(
    head(aut$get_author_list(format = "a")),
    author_list_head
  )
  expect_equal(
    tail(aut$get_author_list(format = "a")),
    c("UUbu", "VVbv", "WWbw", "XXbx", "YYby", "ZZbz")
  )
})

# Errors ----

test_that("sequential() gives meaningful error messages", {
  expect_snapshot(sequential(1), error = TRUE)
})
