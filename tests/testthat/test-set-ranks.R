test_that("ranking contributors makes a `contribution_degree` column", {
  aut <- Plume$new(basic_df)
  aut$set_lead_contributors(1, roles = "analysis")

  expect_named(
    aut$get_plume()$role[[1]],
    c("role", "contribution_degree")
  )
})

test_that("set_lead_contributors() ranks contributors", {
  aut <- Plume$new(basic_df)
  aut$set_lead_contributors(2, 3, roles = "analysis")

  pull_contribution_degrees <- function(data) {
    out <- unnest(data, cols = role)
    dplyr::pull(out)
  }

  expect_equal(
    pull_contribution_degrees(aut$get_plume()),
    c(3, NA, 1, NA, 2, NA)
  )
})

# Errors ----

test_that("set_ranks() gives meaningful error messages", {
  aut <- Plume$new(basic_df)

  expect_snapshot({
    (expect_error(aut$set_lead_contributors(1, roles = 1)))
    (expect_error(aut$set_lead_contributors(1, roles = c("x", "x"))))
  })
})
