test_that("printing a `plm_icon` object returns a formatted output", {
  expect_output(print(orcid()), "<orcid>")
})

test_that("orcid() makes orcid icon metadata", {
  render <- partial(rmarkdown::render, clean = FALSE, quiet = TRUE)

  read_rendered_md <- function() {
    read_test_file(list.files(pattern = "\\.md$"))
  }

  withr::with_tempdir({
    tmp_file <- withr::local_tempfile(lines = dedent("
      ---
      title: test
      ---
      ```{r results = 'asis'}
      str(attributes(orcid()))
      str(attributes(orcid(size = 24)))
      str(attributes(orcid(bw = TRUE)))
      ```
    "), fileext = ".Rmd", tmpdir = getwd())

    # pdf
    # use rtf_document to speed up test runs
    render(tmp_file, output_format = "rtf_document")
    expect_snapshot(read_rendered_md())

    # svg
    render(tmp_file, output_format = "html_document")
    expect_snapshot(read_rendered_md())
  })
})

# Errors ----

test_that("orcid() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      orcid(size = NULL)
    ))
    (expect_error(
      orcid(bw = 1)
    ))
  })
})