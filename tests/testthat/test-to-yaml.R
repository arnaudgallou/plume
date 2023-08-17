test_that("to_yaml() injects authors and affiliations into a `.qmd`", {
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n---\n\n```{r}\n#| echo: false\nx <- 1\n```",
    fileext = ".qmd"
  )

  df <- basic_df()

  aut <- PlumeQuarto$new(df, tmp_file)
  aut$set_corresponding_authors(1)
  aut$to_yaml()
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(df[c(3, 2, 1), ], tmp_file)
  aut$set_corresponding_authors(1)
  aut$to_yaml()
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X", family_name = "Z",
    affiliation1 = "name=a department=b city=c postal-code=d",
    affiliation2 = "city=e name=f department=g",
    affiliation3 = "h"
  ), tmp_file)
  aut$to_yaml()
  expect_snapshot(read_test_file(tmp_file))

  # to ensure that metadata can be pushed to empty YAML headers
  tmp_file <- withr::local_tempfile(lines = "---\n---", fileext = ".qmd")

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X",
    family_name = "Z",
    `meta-foo` = "Bar",
    check.names = FALSE
  ), tmp_file)
  aut$to_yaml()

  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() exits before pushing new header if invalid YAML", {
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n--\n\nLorem ipsum\n\n---",
    fileext = ".qmd"
  )

  old <- readr::read_file(tmp_file)

  aut <- PlumeQuarto$new(basic_df(), tmp_file)
  try(aut$to_yaml(), silent = TRUE)

  new <- readr::read_file(tmp_file)

  expect_equal(old, new)
})

# Errors ----

test_that("to_yaml() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      PlumeQuarto$new(basic_df(), file = 1)
    ))
    (expect_error(
      PlumeQuarto$new(basic_df(), file = "")
    ))
    (expect_error(
      PlumeQuarto$new(basic_df(), file = "test.rmd")
    ))
    (expect_error(
      PlumeQuarto$new(basic_df(), file = "~/test.qmd")
    ))
  })

  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test---",
    fileext = ".qmd"
  )
  aut <- PlumeQuarto$new(basic_df(), tmp_file)

  expect_snapshot(aut$to_yaml(), error = TRUE)
})
