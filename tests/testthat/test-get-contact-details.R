test_that("get_contact_details() returns contact details of corresponding authors", {
  aut <- Plume$new(basic_df)
  aut$set_corresponding_authors(1, 2)

  expect_s3_class(aut$get_contact_details(), "plm")

  literal_names <- c("Zip Zap", "Ric Rac")
  emails <- c("zipzap@test.com", "ricrac@test.com")

  expect_equal(
    aut$get_contact_details(),
    paste0(emails, " (", literal_names, ")")
  )
  expect_equal(
    aut$get_contact_details("{name}: {details}"),
    paste(literal_names, emails, sep = ": ")
  )
  expect_equal(
    aut$get_contact_details("{details}"),
    emails
  )
  expect_equal(
    aut$get_contact_details(phone = TRUE),
    paste0(emails, c(", +1234", ""), " (", literal_names, ")")
  )
  expect_equal(
    aut$get_contact_details(phone = TRUE, sep = "; "),
    paste0(emails, c("; +1234", ""), " (", literal_names, ")")
  )
  expect_equal(
    aut$get_contact_details(email = FALSE, phone = TRUE),
    "+1234 (Zip Zap)"
  )
})

test_that("get_contact_details() returns `NULL` if all booleans are `FALSE`", {
  aut <- Plume$new(basic_df)
  aut$set_corresponding_authors(1)
  expect_null(aut$get_contact_details(email = FALSE))
})

# Errors ----

test_that("get_conctact_details() gives meaningful error messages", {
  aut <- Plume$new(basic_df)

  expect_snapshot({
    (expect_error(
      aut$get_contact_details(format = "foo")
    ))
    (expect_error(
      aut$get_contact_details(format = "{foo}")
    ))
    (expect_error(
      aut$get_contact_details()
    ))
    (expect_error(
      aut$get_contact_details(email = 1)
    ))
    (expect_error(
      aut$get_contact_details(sep = NULL)
    ))
    (expect_error(
      aut$get_contact_details(sep = "")
    ))

    aut$set_corresponding_authors(1)

    (expect_error(
      aut$get_contact_details(fax = TRUE)
    ))
  })
})
