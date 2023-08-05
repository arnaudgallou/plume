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

  expect_null(nms$internals$equal_contributor)

  nms <- set_default_names(
    equal_contributor = "contribution_égale",
    .plume_quarto = TRUE
  )

  expect_equal(nms$internals$equal_contributor, "contribution_égale")

  nms <- set_default_names(foo = "foo", bar = "bar")

  expect_equal(nms, default_names)
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
