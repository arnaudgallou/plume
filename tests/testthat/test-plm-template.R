test_that("plm_template() returns a table template", {
  df <- plm_template(role_cols = NULL)

  expect_equal(nrow(df), 0L)

  nms_minimal <- c(
    "given_name", "family_name", "email", "orcid",
    "affiliation_1", "affiliation_2", "note"
  )
  nms_minimal_crt <- c(nms_minimal, names(credit_roles()))

  expect_named(df, nms_minimal, ignore.order = TRUE)
  expect_named(
    plm_template(role_cols = credit_roles()),
    nms_minimal_crt,
    ignore.order = TRUE
  )

  df <- plm_template(minimal = FALSE, role_cols = NULL)
  nms_minimal_all <- c(nms_minimal, "phone", "fax", "url")

  expect_named(df, nms_minimal_all, ignore.order = TRUE)
})

test_that("role columns are of type numeric", {
  get_numeric_cols <- function(tbl) {
    names(tbl)[sapply(tbl, is.numeric)]
  }

  df <- plm_template(role_cols = c("foo"))
  expect_equal(get_numeric_cols(df), "foo")

  df <- plm_template(role_cols = c(a = "foo"))
  expect_equal(get_numeric_cols(df), "a")
})

# Deprecation ----

test_that("`credit_roles = TRUE` is deprecated", {
  expect_snapshot({
    tbl <- plm_template(credit_roles = TRUE)
  })
  expect_named(tbl, c(
    "given_name", "family_name", "email", "orcid",
    "affiliation_1", "affiliation_2", "note", names(credit_roles())
  ), ignore.order = TRUE)
})

# Errors ----

test_that("plm_template() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(
      plm_template(minimal = 1)
    ))
    (expect_error(
      plm_template(role_cols = 1)
    ))
    (expect_error(
      plm_template(role_cols = c("foo", "foo"))
    ))
    (expect_error(
      plm_template(credit_roles = 1)
    ))
  })
})
