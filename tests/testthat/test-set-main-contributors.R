test_that("ranking contributors makes a `contributor_rank` column", {
  aut <- Plume$new(basic_df)
  aut$set_main_contributors(1, .roles = "analysis")

  expect_named(
    aut$get_plume()$role[[1]],
    c("role", "contributor_rank")
  )
})

test_that("set_main_contributors() ranks contributors", {
  aut <- Plume$new(basic_df)
  aut$set_main_contributors(2, 3, .roles = "analysis")

  pull_contributor_ranks <- function(data) {
    out <- unnest(data, cols = role)
    dplyr::pull(out)
  }

  expect_equal(
    pull_contributor_ranks(aut$get_plume()),
    c(3, NA, 1, NA, 2, NA)
  )
})

# Errors ----

test_that("set_ranks() gives meaningful error messages", {
  aut <- Plume$new(basic_df)

  expect_snapshot({
    (expect_error(aut$set_main_contributors()))
    (expect_error(aut$set_main_contributors(1, .roles = 1)))
    (expect_error(aut$set_main_contributors(1, .roles = c("x", "x"))))
    (expect_error(aut$set_main_contributors(1, .by = 1)))
  })
})
