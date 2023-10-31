test_that("get_orcids() returns authors' ORCID", {
  aut <- Plume$new(basic_df)

  expect_s3_class(aut$get_orcids(), "plm")

  expect_snapshot(aut$get_orcids(), transform = scrub_icon_path)
  expect_snapshot(aut$get_orcids(sep = " - "), transform = scrub_icon_path)
  expect_snapshot(aut$get_orcids(icon = FALSE))
  expect_snapshot(aut$get_orcids(icon = FALSE, compact = TRUE))
})

# Errors ----

test_that("get_orcids() gives meaningful error messages", {
  aut <- Plume$new(basic_df)

  expect_snapshot({
    (expect_error(
      aut$get_orcids(compact = 1)
    ))
    (expect_error(
      aut$get_orcids(icon = 1)
    ))
    (expect_error(
      aut$get_orcids(sep = 1)
    ))
  })
})