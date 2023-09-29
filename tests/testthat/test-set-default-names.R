test_that("set_default_names() sets new plume names", {
  nms <- set_default_names(
    initials = "initiales",
    literal_name = "nom_complet",
    corresponding = "correspondant",
    given_name = "prénom",
    family_name = "nom",
    email = "courriel",
    phone = "téléphone"
  )

  expect_snapshot(str(nms))

  nms <- set_default_names(
    equal_contributor = "contribution_égale",
    .plume_quarto = FALSE
  )

  expect_null(list_fetch(nms, "equal_contributor")[[1]])

  nms <- set_default_names(
    equal_contributor = "contribution_égale",
    .plume_quarto = TRUE
  )

  expect_equal(
    list_fetch(nms, "equal_contributor")[[1]],
    "contribution_égale"
  )

  nms <- set_default_names(foo = "foo", analysis = "bar")

  expect_equal(nms, .names)
})

# Errors ----

test_that("set_default_names() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(set_default_names(1)))
    (expect_error(set_default_names("a")))
    (expect_error(set_default_names(x = "a", y = "a")))
    (expect_error(set_default_names(x = "a", x = "b")))
    (expect_error(set_default_names(.plume_quarto = 1)))
  })
})
