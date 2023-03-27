test_that("set_default_names() sets new plume names", {
  nms <- set_default_names(
    initials = "initiales",
    literal_name = "nom_complet",
    corresponding = "correspondant",
    deceased = "décédé",
    equal_contributor = "contribution_égale",
    given_name = "prénom",
    family_name = "nom",
    dropping_particle = "particule_délaissée",
    email = "courriel",
    number = "numéro"
  )

  new_nms <- list(
    internal = list(
      id = "id",
      initials = "initiales",
      literal_name = "nom_complet",
      corresponding = "correspondant",
      deceased = "décédé",
      equal_contributor = "contribution_égale"
    ),
    primary = list(
      given_name = "prénom",
      family_name = "nom"
    ),
    secondary = list(
      dropping_particle = "particule_délaissée",
      email = "courriel",
      orcid = "orcid",
      number = "numéro",
      fax = "fax",
      url = "url"
    ),
    nestable = list(
      affiliation = "affiliation",
      contribution = "contribution",
      note = "note"
    )
  )

  expect_equal(nms, new_nms)
})

# Errors ----

test_that("set_default_names() gives meaningful error messages", {
  expect_snapshot({
    (expect_error(set_default_names(1)))
    (expect_error(set_default_names("a")))
    (expect_error(set_default_names(x = "a", y = "a")))
    (expect_error(set_default_names(x = "a", x = "b")))
  })
})
