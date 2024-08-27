test_that("to_yaml() injects authors and affiliations into a `.qmd`", {
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test\n---\n\n```{r}\n#| echo: false\nx <- 1\n```",
    fileext = ".qmd"
  )

  aut <- PlumeQuarto$new(basic_df, tmp_file)
  aut$set_corresponding_authors(1)
  aut$to_yaml()
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(basic_df[c(3, 2, 1), ], tmp_file)
  aut$set_corresponding_authors(1)
  aut$to_yaml()
  expect_snapshot(read_test_file(tmp_file))

  aut <- PlumeQuarto$new(data.frame(
    given_name = "Zip", family_name = "Zap",
    affiliation1 = "name=a department=b city=c postal-code=d",
    affiliation2 = "city=e name=f department=g",
    affiliation3 = "h"
  ), tmp_file)
  aut$to_yaml()
  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() doesn't add the `affiliations` schema if there're no affiliations", {
  tmp_file <- withr::local_tempfile(
    lines = dedent("
      ---
      affiliations:
        - name: a
      ---
    "),
    fileext = ".qmd"
  )

  aut <- PlumeQuarto$new(
    data.frame(given_name = "Zip", family_name = "Zap"),
    tmp_file
  )
  aut$to_yaml()

  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() pushes data to empty YAML headers", {
  tmp_file <- withr::local_tempfile(lines = "---\n---", fileext = ".qmd")

  aut <- PlumeQuarto$new(tibble(
    given_name = "Zip",
    family_name = "Zap",
    `meta-foo` = "bar"
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

  aut <- PlumeQuarto$new(basic_df, tmp_file)
  try(aut$to_yaml(), silent = TRUE)

  new <- readr::read_file(tmp_file)

  expect_equal(old, new)
})

test_that("to_yaml() preserves line breaks preceding `---` (#37)", {
  tmp_file <- withr::local_tempfile(
    lines = "---\n---\nLorem ipsum\n---",
    fileext = ".qmd"
  )

  aut <- PlumeQuarto$new(
    data.frame(given_name = "Zip", family_name = "Zap"),
    tmp_file
  )
  aut$to_yaml()

  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() writes in a separate header to preserve strippable data (#56)", {
  tmp_file <- withr::local_tempfile(
    lines = dedent("
      ---
      title: test # this is a title
      foo: >
        Lorem ipsum
        Vivamus quis
      ---
    "),
    fileext = ".qmd"
  )

  aut <- PlumeQuarto$new(
    data.frame(given_name = "Zip", family_name = "Zap"),
    tmp_file
  )

  expect_warning(
    aut$to_yaml(),
    "Writing author metadata in a separate YAML header"
  )
  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() can push data into YAML files", {
  tmp_file <- withr::local_tempfile(
    lines = "title: foo",
    fileext = ".yaml"
  )

  aut <- PlumeQuarto$new(
    data.frame(given_name = "Zip", family_name = "Zap"),
    tmp_file
  )
  aut$to_yaml()

  expect_snapshot(read_test_file(tmp_file))
})

test_that("to_yaml() properly handles authors with no roles (#81)", {
  tmp_file <- withr::local_tempfile(
    lines = "title: foo",
    fileext = ".yaml"
  )

  aut <- PlumeQuarto$new(
    data.frame(
      given_name = c("A", "B"),
      family_name = c("A", "B"),
      writing = c(1, NA),
      analysis = c(1, NA)
    ),
    tmp_file
  )
  aut$to_yaml()

  expect_snapshot(read_test_file(tmp_file))
})

# Errors ----

test_that("to_yaml() errors if no YAML headers is found", {
  tmp_file <- withr::local_tempfile(
    lines = "---\ntitle: test---",
    fileext = ".qmd"
  )
  aut <- PlumeQuarto$new(basic_df, tmp_file)

  expect_snapshot(aut$to_yaml(), error = TRUE)
})

test_that("to_yaml() errors if an invalid ORCID identifier is found ", {
  aut <- PlumeQuarto$new(
    data.frame(given_name = "X", family_name = "Y", orcid = "0000"),
    tempfile_()
  )
  expect_snapshot(aut$to_yaml(), error = TRUE)
})
