test_that("deprecated functionalities generate informative errors", {
  expect_snapshot({
    aut <- Plume$new(basic_df)

    aut$set_corresponding_authors(1)
    aut$get_contact_details(format = "{name} {details}")
  })
})
