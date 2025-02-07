test_that("sets status to selected authors", {
  aut <- PlumeQuarto$new(basic_df, temp_file())

  # set_corresponding_authors

  expect_equal({
    aut$set_corresponding_authors(everyone())
    aut$get_plume()$corresponding
  }, rep(TRUE, 3))

  expect_equal({
    aut$set_corresponding_authors(plume::everyone())
    aut$get_plume()$corresponding
  }, rep(TRUE, 3))

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

# Errors ----

test_that("set_*() methods give meaningful error messages", {
  aut <- PlumeQuarto$new(basic_df, temp_file())

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
      aut$set_corresponding_authors(x <- y)
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
  expect_snapshot(everyone(), error = TRUE)
})
