test_that("get_author_list() returns author list", {
  df <- basic_df()

  aut <- Plume$new(df)
  aut$set_corresponding_authors(1, 3)

  expect_s3_class(aut$get_author_list(), "plm")
  expect_equal(
    aut$get_author_list(format = NULL),
    df$literal_name
  )
  expect_equal(
    aut$get_author_list(format = ""),
    df$literal_name
  )

  affix_to_authors <- function(...) {
    paste0(basic_df()$literal_name, ...)
  }

  .a <- c("1,2", "3", "1,4")
  .c <- c("\\*", "", "\\*")
  .n <- c("†,‡", "", "§")

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

  # overrides default symbols
  aut <- Plume$new(df, symbols = list(
    affiliation = letters,
    corresponding = "#",
    note = NULL
  ))
  aut$set_corresponding_authors(1, 3)

  .a <- c("a,b", "c", "a,d")
  .c <- c("#", "", "#")
  .n <- c("1,2", "", "3")

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
  aut <- Plume$new(basic_df())
  expect_snapshot(aut$get_author_list("o"), transform = scrub_icon_path)
})

# Errors ----

test_that("get_author_list() gives meaningful error messages", {
  df <- basic_df()
  df["orcid"] <- c(NA, "0000", NA)
  aut <- Plume$new(df)

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
