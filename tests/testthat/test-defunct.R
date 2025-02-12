test_that("defunct functionalities generate informative errors", {
  expect_snapshot(error = TRUE, {
    aut <- PlumeQuarto$new(basic_df, temp_file())
    aut$set_equal_contributor(1)

    aut <- Plume$new(basic_df)
    aut$set_corresponding_authors(zip, by = "given_name")
    aut$get_author_list(format = "a")

    Plume$new(data.frame(
      given_name = "X",
      family_name = "Y",
      role = "a"
    ))

    Plume$new(basic_df, credit_roles = TRUE)

    plm_template(credit_roles = TRUE)

    everyone_but()
  })
})
