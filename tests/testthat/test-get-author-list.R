test_that("get_author_list() returns author list", {
  aut <- Plume$new(basic_df)
  aut$set_corresponding_authors(1, 3)

  expect_s3_class(aut$get_author_list(), "plm")
  expect_equal(
    aut$get_author_list(NULL),
    c("Zip Zap", "Ric Rac", "Pim-Pam Pom")
  )
  expect_equal(
    aut$get_author_list(""),
    c("Zip Zap", "Ric Rac", "Pim-Pam Pom")
  )

  affix_to_authors <- function(...) {
    paste0(basic_df$literal_name, ...)
  }

  .a <- c("1,2", "3", "1,4")
  .c <- c("\\*", "", "\\*")
  .n <- c("†,‡", "", "§")

  expect_equal(
    aut$get_author_list("a"),
    affix_to_authors(.a)
  )
  expect_equal(
    aut$get_author_list("c"),
    affix_to_authors(.c)
  )
  expect_equal(
    aut$get_author_list("n"),
    affix_to_authors(.n)
  )
  expect_equal(
    aut$get_author_list("anc"),
    affix_to_authors(.a, .n, .c)
  )
  expect_equal(
    aut$get_author_list("can"),
    affix_to_authors(.c, .a, .n)
  )
  expect_equal(
    aut$get_author_list("^ac^n"),
    affix_to_authors("^", .a, .c, "^", .n)
  )

  .seps <- c(",", "", ",")

  expect_equal(
    aut$get_author_list("a,c"),
    affix_to_authors(.a, .seps, .c)
  )
  expect_equal(
    aut$get_author_list("^a,^c"),
    affix_to_authors("^", .a, .seps, "^", .c)
  )

  expect_equal(
    aut$get_author_list("a,,c"),
    affix_to_authors(.a, .seps, .c)
  )
  expect_equal(
    aut$get_author_list(",ac,"),
    affix_to_authors(.a, .c)
  )
  expect_equal(
    aut$get_author_list("^^ac^^"),
    affix_to_authors("^", .a, .c, "^")
  )

  .hats <- c("^", "", "^")

  expect_equal(
    aut$get_author_list("^a^c^n^"),
    affix_to_authors("^", .a, .hats, .c, .hats, .n, "^")
  )

  # overrides default symbols

  aut <- Plume$new(basic_df, symbols = list(
    affiliation = letters,
    corresponding = "#",
    note = NULL
  ))
  aut$set_corresponding_authors(1, 3)

  .a <- c("a,b", "c", "a,d")
  .c <- c("#", "", "#")
  .n <- c("1,2", "", "3")

  expect_equal(
    aut$get_author_list("anc"),
    affix_to_authors(.a, .n, .c)
  )

  # using custom names

  aut <- Plume$new(
    data.frame(given_name = "X", family_name = "Y", aff = "a", aff2 = "b"),
    names = c(affiliation = "aff")
  )

  expect_equal(
    aut$get_author_list("a"),
    "X Y1,2"
  )
})

test_that("get_author_list() makes ORCID icons", {
  aut <- Plume$new(basic_df)
  expect_snapshot(aut$get_author_list("o"), transform = scrub_icon_path)
})

# Deprecation ----

test_that("`format` is deprecated", {
  aut <- Plume$new(basic_df)
  expect_snapshot({
    author_list <- aut$get_author_list(format = "a")
  })
  expect_equal(author_list, paste0(
    c("Zip Zap", "Ric Rac", "Pim-Pam Pom"),
    c("1,2", "3", "1,4")
  ))
})

# Errors ----

test_that("get_author_list() gives meaningful error messages", {
  basic_df["orcid"] <- c(NA, "0000", NA)
  aut <- Plume$new(basic_df)

  expect_snapshot({
    (expect_error(
      aut$get_author_list(1)
    ))
    (expect_error(
      aut$get_author_list("anca")
    ))
    (expect_error(
      aut$get_author_list("az")
    ))
    (expect_error(
      aut$get_author_list("ac")
    ))
    (expect_error(
      aut$get_author_list("o")
    ))
  })
})
