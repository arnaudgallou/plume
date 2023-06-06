test_that("plm_push() inject data to a `.qmd` file.", {
  tmp_file <- withr::local_tempfile(
    lines = dedent("
      ---
      title: test
      ---
      # Contributions

      Lorem ipsum
    "),
    fileext = ".qmd"
  )
  aut <- Plume$new(basic_df())

  contributions <- aut$get_contributions()
  plm_push(contributions, tmp_file, "# Contributions")

  expect_snapshot(cat(read_file(tmp_file)))

  contributions <- aut$get_contributions(role_first = FALSE, name_list = TRUE)
  plm_push(contributions, tmp_file, "# Contributions")

  expect_snapshot(cat(read_file(tmp_file)))
})

# Errors ----

test_that("plm_push() gives meaningful error messages", {
  tmp_file <- withr::local_tempfile(lines = "test", fileext = ".qmd")

  aut <- Plume$new(basic_df())
  contributions <- aut$get_contributions()

  expect_snapshot({
    (expect_error(
      plm_push("foo", file = tmp_file)
    ))
    (expect_error(
      plm_push(contributions, file = "file.pdf")
    ))
    (expect_error(
      plm_push(contributions, file = tmp_file, where = TRUE)
    ))
    (expect_error(
      plm_push(contributions, file = tmp_file, where = "foo")
    ))
    (expect_error(
      plm_push(contributions, file = tmp_file, where = "$", sep = TRUE)
    ))
  })
})
