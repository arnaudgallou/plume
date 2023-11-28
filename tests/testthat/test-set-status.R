test_that("sets status to selected authors", {
  aut <- PlumeQuarto$new(basic_df, tempfile_())

  # set_corresponding_authors

  expect_equal({
    aut$set_corresponding_authors(everyone())
    aut$get_plume()$corresponding
  }, rep(TRUE, 3))

  expect_equal({
    withr::local_options(lifecycle_verbosity = "quiet")
    aut$set_corresponding_authors(everyone_but(ric), .by = "given_name")
    aut$get_plume()$corresponding
  }, c(TRUE, FALSE, TRUE))

  expect_equal({
    aut$set_corresponding_authors(1)
    aut$get_plume()$corresponding
  }, c(TRUE, FALSE, FALSE))

  expect_equal({
    aut$set_corresponding_authors(1, 3)
    aut$get_plume()$corresponding
  }, c(TRUE, FALSE, TRUE))

  expect_equal({
    aut$set_corresponding_authors(zip, .by = "given_name")
    aut$get_plume()$corresponding
  }, c(TRUE, FALSE, FALSE))

  # set_cofirst_authors

  expect_equal({
    aut$set_cofirst_authors(zip, .by = "given_name")
    aut$get_plume()$equal_contributor
  }, c(TRUE, FALSE, FALSE))

  # set_deceased

  expect_equal({
    aut$set_deceased(zip, .by = "given_name")
    aut$get_plume()$deceased
  }, c(TRUE, FALSE, FALSE))
})

# Deprecation ----

test_that("the `by` parameter is deprecated", {
  expect_snapshot({
    aut <- Plume$new(basic_df)
    aut$set_corresponding_authors(zip, by = "given_name")
  })
  expect_equal(aut$get_plume()$corresponding, c(TRUE, FALSE, FALSE))
})

test_that("set_equal_contributor() is deprecated", {
  expect_snapshot({
    aut <- PlumeQuarto$new(basic_df, tempfile_())
    aut$set_equal_contributor(1, 3)
  })
  expect_equal(aut$get_plume()$equal_contributor, c(TRUE, FALSE, TRUE))
})

# Errors ----

test_that("set_*() methods give meaningful error messages", {
  aut <- PlumeQuarto$new(basic_df, tempfile_())

  expect_snapshot({
    (expect_error(
      aut$set_corresponding_authors()
    ))
    (expect_error(
      aut$set_corresponding_authors(a, .by = "foo")
    ))
    (expect_error(
      aut$set_corresponding_authors(a, .by = "")
    ))
    (expect_error(
      aut$set_corresponding_authors(a, .by = 1)
    ))
    (expect_error(
      aut$set_cofirst_authors(a, .by = "foo")
    ))
    (expect_error(
      aut$set_cofirst_authors(a, .by = "")
    ))
    (expect_error(
      aut$set_cofirst_authors(a, .by = 1)
    ))
    (expect_error(
      aut$set_deceased(a, .by = "foo")
    ))
    (expect_error(
      aut$set_deceased(a, .by = "")
    ))
    (expect_error(
      aut$set_deceased(a, .by = 1)
    ))
  })
})

test_that("everyone*() selectors error if used in a wrong context", {
  expect_snapshot({
    (expect_error(everyone()))
    (expect_error(everyone_but()))
  })
})
