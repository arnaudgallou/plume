test_that("printing a plume object is identical to cat()", {
  aut <- Plume$new(data.frame(given_name = "X", family_name = "Y"))
  expect_output(print(aut$get_author_list()), "X Y")
})
