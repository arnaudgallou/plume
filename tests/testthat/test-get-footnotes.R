test_that("get_affiliations/notes() return affiliations/notes", {
  df <- basic_df()
  aut <- Plume$new(df)

  expect_s3_class(aut$get_notes(), "plm")

  df_affiliations <- select(df, starts_with("affiliation"))

  affiliations <- condense(c(t(df_affiliations)))
  ids <- seq_along(affiliations)

  expect_equal(
    aut$get_affiliations(),
    paste0("^", ids, "^", affiliations)
  )
  expect_equal(
    aut$get_affiliations(superscript = FALSE),
    paste0(ids, affiliations)
  )
  expect_equal(
    aut$get_affiliations(sep = ": ", superscript = FALSE),
    paste0(ids, ": ", affiliations)
  )

  aut <- Plume$new(df, symbols = list(affiliation = letters))

  expect_equal(
    aut$get_affiliations(),
    paste0("^", letters[ids], "^", affiliations)
  )

  notes <- condense(t(df[grep("note", names(df))]))
  symbols <- c("†", "‡", "§")

  expect_equal(
    aut$get_notes(),
    paste0("^", symbols, "^", notes)
  )
})

test_that("get_affiliations/notes() returns `NULL` if no affiliations/notes", {
  aut <- Plume$new(data.frame(
    given_name = "Zip",
    family_name = "Zap",
    note = ""
  ))
  expect_null(aut$get_notes())
})

# Errors ----

test_that("get_affiliations() give meaningful error messages", {
  aut <- Plume$new(basic_df())

  expect_snapshot({
    (expect_error(
      aut$get_affiliations(sep = 1)
    ))
    (expect_error(
      aut$get_affiliations(superscript = "")
    ))
  })
})

test_that("get_notes() give meaningful error messages", {
  aut <- Plume$new(basic_df())

  expect_snapshot({
    (expect_error(
      aut$get_notes(sep = 1)
    ))
    (expect_error(
      aut$get_notes(superscript = "")
    ))
  })
})
