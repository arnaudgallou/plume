test_that("sets status to selected authors", {
  aut <- PlumeQuarto$new(basic_df())

  # set_corresponding_authors

  expect_equal({
    aut$set_corresponding_authors("all")
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
    aut$set_corresponding_authors(zip, by = "given_name")
    aut$get_plume()$corresponding
  }, c(TRUE, FALSE, FALSE))

  # set_equal_contributor

  expect_equal({
    aut$set_equal_contributor("all")
    aut$get_plume()$equal_contributor
  }, rep(TRUE, 3))

  expect_equal({
    aut$set_equal_contributor(1)
    aut$get_plume()$equal_contributor
  }, c(TRUE, FALSE, FALSE))

  expect_equal({
    aut$set_equal_contributor(1, 3)
    aut$get_plume()$equal_contributor
  }, c(TRUE, FALSE, TRUE))

  expect_equal({
    aut$set_equal_contributor(zip, by = "given_name")
    aut$get_plume()$equal_contributor
  }, c(TRUE, FALSE, FALSE))

  # set_deceased

  expect_equal({
    aut$set_deceased("all")
    aut$get_plume()$deceased
  }, rep(TRUE, 3))

  expect_equal({
    aut$set_deceased(1)
    aut$get_plume()$deceased
  }, c(TRUE, FALSE, FALSE))

  expect_equal({
    aut$set_deceased(1, 3)
    aut$get_plume()$deceased
  }, c(TRUE, FALSE, TRUE))

  expect_equal({
    aut$set_deceased(zip, by = "given_name")
    aut$get_plume()$deceased
  }, c(TRUE, FALSE, FALSE))
})

# Errors ----

test_that("set_*() methods give meaningful error messages", {
  aut <- PlumeQuarto$new(basic_df())

  expect_snapshot({
    (expect_error(
      aut$set_corresponding_authors(a, by = "foo")
    ))
    (expect_error(
      aut$set_corresponding_authors(a, by = "")
    ))
    (expect_error(
      aut$set_corresponding_authors(a, by = 1)
    ))
    (expect_error(
      aut$set_equal_contributor(a, by = "foo")
    ))
    (expect_error(
      aut$set_equal_contributor(a, by = "")
    ))
    (expect_error(
      aut$set_equal_contributor(a, by = 1)
    ))
    (expect_error(
      aut$set_deceased(a, by = "foo")
    ))
    (expect_error(
      aut$set_deceased(a, by = "")
    ))
    (expect_error(
      aut$set_deceased(a, by = 1)
    ))
  })
})
