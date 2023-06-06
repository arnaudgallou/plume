test_that("get_author_list() returns author list", {
  df <- basic_df()

  aut <- Plume$new(df)
  aut$set_corresponding_authors(1, 3)

  expect_equal(
    aut$get_author_list(format = NULL),
    df$literal_name
  )

  affix_to_authors <- function(...) {
    paste0(basic_df()$literal_name, ...)
  }

  .a <- c("1,2", "3", "1,4")
  .c <- c("\\*", "", "\\*")
  .n <- c("†", "", "‡")

  expect_equal(
    aut$get_author_list(format = "a"),
    affix_to_authors(.a)
  )
  expect_equal(
    aut$get_author_list(format = "c"),
    affix_to_authors(.c)
  )
  expect_equal(
    aut$get_author_list(format = "n"),
    affix_to_authors(.n)
  )
  expect_equal(
    aut$get_author_list(format = "anc"),
    affix_to_authors(.a, .n, .c)
  )
  expect_equal(
    aut$get_author_list(format = "acn"),
    affix_to_authors(.a, .c, .n)
  )
  expect_equal(
    aut$get_author_list(format = "^ac^n"),
    affix_to_authors("^", .a, .c, "^", .n)
  )

  .seps <- c(",", "", ",")

  expect_equal(
    aut$get_author_list(format = "a,c"),
    affix_to_authors(.a, .seps, .c)
  )
  expect_equal(
    aut$get_author_list(format = "^a,^c"),
    affix_to_authors("^", .a, .seps, "^", .c)
  )

  expect_equal(
    aut$get_author_list(format = "a,,c"),
    affix_to_authors(.a, .seps, .c)
  )
  expect_equal(
    aut$get_author_list(format = ",ac,"),
    affix_to_authors(.a, .c)
  )
  expect_equal(
    aut$get_author_list(format = "^^ac^^"),
    affix_to_authors("^", .a, .c, "^")
  )

  .hats <- c("^", "", "^")

  expect_equal(
    aut$get_author_list(format = "^a^c^n^"),
    affix_to_authors("^", .a, .hats, .c, .hats, .n, "^")
  )

  aut$symbols <- list(affiliation = letters, corresponding = "†", note = NULL)

  .a <- c("a,b", "c", "a,d")
  .c <- c("†", "", "†")
  .n <- c("1", "", "2")

  expect_equal(
    aut$get_author_list(format = "anc"),
    affix_to_authors(.a, .n, .c)
  )

  # using custom names
  df <- data.frame(given_name = "X", family_name = "Y", aff = "a", aff2 = "b")
  aut <- Plume$new(df, names = c(affiliation = "aff"))

  expect_equal(
    aut$get_author_list(format = "a"),
    "X Y1,2"
  )
})

test_that("get_author_list() makes ORCID icons", {
  render <- partial(rmarkdown::render, clean = FALSE, quiet = TRUE)

  read_rendered_md <- function() {
    read_file(list.files(pattern = "\\.md$"))
  }

  withr::with_tempdir({
    tmp_file <- withr::local_tempfile(lines = dedent("
      ---
      title: foo
      ---
      ```{r echo = FALSE}
      aut <- Plume$new(tibble(
        given_name = 'X',
        family_name = 'Y',
        orcid = '0000-0000-0000-0000'
      ))
      cat(aut$get_author_list('o'))
      ```
    "), fileext = ".Rmd", tmpdir = getwd())

    url <- "https://orcid.org/0000-0000-0000-0000"

    # use rtf to speed up test runs
    render(tmp_file, output_format = "rtf_document")
    icon <- sprintf(
      "[\\hspace{3pt}![](%s){height=16px}\\hspace{3pt}](%s)",
      get_icon("orcid.pdf"),
      url
    )

    expect_match(read_rendered_md(), paste0("X Y", icon), fixed = TRUE)

    render(tmp_file, output_format = "html_document")
    icon <- sprintf(
      "[![](%s){height=20px style='margin: 0 4px; vertical-align: baseline'}](%s)",
      get_icon("orcid.svg"),
      url
    )

    expect_match(read_rendered_md(), paste0("X Y", icon), fixed = TRUE)
  })
})

# Errors ----

test_that("get_author_list() gives meaningful error messages", {
  aut <- Plume$new(basic_df())
  aut$plume$orcid <- c("0000", NA, NA)

  expect_snapshot({
    (expect_error(
      aut$get_author_list(format = 1)
    ))
    (expect_error(
      aut$get_author_list(format = "anca")
    ))
    (expect_error(
      aut$get_author_list(format = "az")
    ))
    (expect_error(
      aut$get_author_list(format = "ac")
    ))
    (expect_error(
      aut$get_author_list(format = "o")
    ))
  })
})
