test_that("get_contact_details() returns contact details of corresponding authors", {
  df <- basic_df()
  aut <- Plume$new(df)
  aut$set_corresponding_authors(1, 2)

  expect_s3_class(aut$get_contact_details(), "plm")

  df2 <- df[1:2, ]
  literal_names <- df2$literal_name
  emails <- df2$email

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
    paste0(emails, c(", 00", ""), " (", literal_names, ")")
  )
  expect_equal(
    aut$get_contact_details(phone = TRUE, sep = "; "),
    paste0(emails, c("; 00", ""), " (", literal_names, ")")
  )
  expect_equal(
    aut$get_contact_details(email = FALSE, phone = TRUE),
    paste0("00", " (", literal_names[1], ")")
  )
})

test_that("get_contact_details() returns `NULL` if all boolean arguments are `FALSE`", {
  aut <- Plume$new(encyclopedists)
  aut$set_corresponding_authors(1)
  expect_null(aut$get_contact_details(email = FALSE))
})

# Errors ----

test_that("get_conctact_details() gives meaningful error messages", {
  aut <- Plume$new(encyclopedists)

  expect_snapshot({
    (expect_error(
      aut$get_contact_details(format = 1)
    ))
    (expect_error(
      aut$get_contact_details(format = "")
    ))
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
      aut$get_contact_details(sep = 1)
    ))
    (expect_error(
      aut$get_contact_details(sep = "")
    ))
    (expect_error(
      aut$get_contact_details(sep = NULL)
    ))

    aut$set_corresponding_authors(1)

    (expect_error(
      aut$get_contact_details(fax = TRUE)
    ))
  })
})
