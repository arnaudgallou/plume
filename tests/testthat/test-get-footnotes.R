test_that("get_affiliations/notes() return affiliations/notes", {
  aut <- Plume$new(basic_df)

  expect_s3_class(aut$get_notes(), "plm")

  expect_equal(
    aut$get_affiliations(),
    c("^1^a", "^2^b", "^3^c", "^4^d")
  )
  expect_equal(
    aut$get_affiliations(superscript = FALSE),
    c("1a", "2b", "3c", "4d")
  )
  expect_equal(
    aut$get_affiliations(sep = ": ", superscript = FALSE),
    c("1: a", "2: b", "3: c", "4: d")
  )

  aut <- Plume$new(basic_df, symbols = list(affiliation = letters))

  expect_equal(aut$get_affiliations(), c("^a^a", "^b^b", "^c^c", "^d^d"))
  expect_equal(aut$get_notes(), c("^†^a", "^‡^c", "^§^b"))
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
  aut <- Plume$new(basic_df)

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
  aut <- Plume$new(basic_df)

  expect_snapshot({
    (expect_error(
      aut$get_notes(sep = 1)
    ))
    (expect_error(
      aut$get_notes(superscript = "")
    ))
  })
})
