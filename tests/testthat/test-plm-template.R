test_that("plm_template() returns a table template", {
  df <- plm_template()

  expect_equal(nrow(df), 0)

  nms_minimal <- c(
    "given_name", "family_name", "email", "orcid", "affiliation_1",
    "affiliation_2", "contribution_1", "contribution_2", "note"
  )
  expect_named(df, nms_minimal, ignore.order = TRUE)

  nms_all <- c(nms_minimal, "dropping_particle", "number", "phone", "fax", "url")
  expect_named(plm_template(FALSE), nms_all, ignore.order = TRUE)
})

# Errors ----

test_that("plm_template() gives meaningful error messages", {
  expect_snapshot(plm_template(1), error = TRUE)
})

