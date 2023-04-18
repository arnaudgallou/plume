test_that("to_yaml() injects authors and affiliations into a `.qmd`", {
  yamls <- string_split(
    readr::read_file(test_path("yaml-headers.txt")),
    pattern = "%%\\R"
  )
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n---\n\n```{r}\n#| eval: false\n\nx <- 1\n```",
    fileext = ".qmd"
  )

  df <- basic_df()

  aut <- PlumeQuarto$new(df)
  aut$set_corresponding_authors(1)
  aut$to_yaml(tmp_file)
  expect_equal(readr::read_file(tmp_file), yamls[1])

  aut <- PlumeQuarto$new(df[c(2, 3, 1), ])
  aut$set_corresponding_authors(1)
  aut$to_yaml(tmp_file)
  expect_equal(readr::read_file(tmp_file), yamls[2])

  aut <- PlumeQuarto$new(df[2, ])
  aut$to_yaml(tmp_file)
  expect_equal(readr::read_file(tmp_file), yamls[3])

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X", family_name = "Z",
    affiliation1 = "name=a department=b city=c postal-code=d",
    affiliation2 = "city=e name=f department=g",
    affiliation3 = "h"
  ))
  aut$to_yaml(tmp_file)
  expect_equal(readr::read_file(tmp_file), yamls[4])

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X",
    family_name = "Z",
    `meta-foo` = "Bar",
    check.names = FALSE
  ))
  aut$to_yaml(tmp_file)
  expect_equal(readr::read_file(tmp_file), yamls[5])

  aut <- PlumeQuarto$new(data.frame(
    given_name = "X",
    family_name = "Z",
    note1 = "a",
    note2 = "b"
  ))
  aut$to_yaml(tmp_file)
  expect_equal(readr::read_file(tmp_file), yamls[6])
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

  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n--\n\nLorem ipsum\n\n---",
    fileext = ".qmd"
  )

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
