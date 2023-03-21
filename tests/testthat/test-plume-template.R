test_that("plume_template() returns a table template", {
  df <- plume_template()

  expect_equal(nrow(df), 0)

  nms_minimal <- c(
    "given_name", "family_name", "email", "orcid", "affiliation_1",
    "affiliation_2", "contribution_1", "contribution_2", "note"
  )
  expect_named(df, nms_minimal, ignore.order = TRUE)

  nms_complete <- c(nms_minimal, "dropping_particle", "number", "fax", "url")
  expect_named(plume_template(FALSE), nms_complete, ignore.order = TRUE)
})

# Errors ----

test_that("plume_template() gives meaningful error messages", {
  expect_snapshot(plume_template(1), error = TRUE)
})

