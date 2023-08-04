test_that("plm_template() returns a table template", {
  df <- plm_template()

  expect_equal(nrow(df), 0L)

  nms_base <- c(
    "given_name", "family_name", "email", "orcid",
    "affiliation_1", "affiliation_2", "note"
  )
  nms_minimal <- c(nms_base, paste0("role_", 1:2))
  nms_minimal_crt <- c(nms_base, names(.names$protected$crt))

  expect_named(df, nms_minimal, ignore.order = TRUE)
  expect_named(
    plm_template(credit_roles = TRUE),
    nms_minimal_crt,
    ignore.order = TRUE
  )

  nms_all <- c(nms_minimal, "phone", "fax", "url")

  expect_named(plm_template(minimal = FALSE), nms_all, ignore.order = TRUE)
})

# Errors ----

test_that("plm_template() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      plm_template(minimal = 1)
    ))
    (expect_error(
      plm_template(credit_roles = 1)
    ))
  })
})
