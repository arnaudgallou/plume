test_that("to_yaml() injects authors and affiliations into a `.qmd`", {
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n---\n\n```{r}\n#| echo: false\nx <- 1\n```",
    fileext = ".qmd"
  )

  df <- basic_df()

  aut <- PlumeQuarto$new(df)
  aut$set_corresponding_authors(1)
  aut$to_yaml(tmp_file)
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(df[c(3, 2, 1), ])
  aut$set_corresponding_authors(1)
  aut$to_yaml(tmp_file)
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X", family_name = "Z",
    affiliation1 = "name=a department=b city=c postal-code=d",
    affiliation2 = "city=e name=f department=g",
    affiliation3 = "h"
  ))
  aut$to_yaml(tmp_file)
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X",
    family_name = "Z",
    `meta-foo` = "Bar",
    check.names = FALSE
  ))
  aut$to_yaml(tmp_file)
  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() exits before pushing new header if invalid yaml", {
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n--\n\nLorem ipsum\n\n---",
    fileext = ".qmd"
  )

  old <- readr::read_file(tmp_file)

  aut <- PlumeQuarto$new(basic_df())
  try(aut$to_yaml(tmp_file), silent = TRUE)

  new <- readr::read_file(tmp_file)

  expect_equal(old, new)
})

# Errors ----

test_that("to_yaml() gives meaningful error messages", {
  aut <- PlumeQuarto$new(basic_df())

  expect_snapshot({
    (expect_error(aut$to_yaml(1)))
    (expect_error(aut$to_yaml("")))
    (expect_error(aut$to_yaml("test.pdf")))
  })

  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test---",
    fileext = ".qmd"
  )

  expect_snapshot(aut$to_yaml(tmp_file), error = TRUE)
})