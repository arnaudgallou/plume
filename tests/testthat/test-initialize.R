test_that("initialize() builds a plume dataset", {
  aut <- Plume$new(basic_df())
  nms_en <- c(
    "id", "initials", "given_name", "family_name", "literal_name",
    "affiliation", "role", "note", "email", "phone", "orcid"
  )

  expect_true(tibble::is_tibble(aut$get_plume()))
  expect_named(aut$get_plume(), nms_en, ignore.order = TRUE)

  nms_fr <- c(
    "id", "initiales", "prénom", "nom", "nom_complet", "affiliation",
    "role", "note", "courriel", "téléphone", "orcid"
  )
  nms_new <- setNames(nms_en, nms_fr)[-(1:2)]
  aut <- Plume$new(
    dplyr::rename(basic_df(), tidyselect::all_of(nms_new)),
    names = setNames(nms_fr, nms_en)
  )

  expect_named(aut$get_plume(), nms_fr, ignore.order = TRUE)

  # ensure that `Plume` drops `PlumeQuarto`-specific variables
  df <- data.frame(given_name = "X", family_name = "Y", dropping_particle = "o")

  aut <- Plume$new(df)
  nms <- c("id", "given_name", "family_name", "literal_name", "initials")
  expect_named(aut$get_plume(), nms)

  aut <- PlumeQuarto$new(df, tempfile_())
  nms <- c(nms, "dropping_particle")
  expect_named(aut$get_plume(), nms)

  # ensure that `credit_roles = TRUE` preserves nestables
  aut <- Plume$new(basic_df(), credit_roles = TRUE)
  expect_named(aut$get_plume(), nms_en[nms_en != "role"], ignore.order = TRUE)
})

test_that("initialize() ignores unknown variables", {
  df <- data.frame(given_name = "X", family_name = "Y", foo = "")
  aut <- Plume$new(df)
  expect_false(has_name(aut$get_plume(), "foo"))
})

test_that("initialize() ignores variables with the same name as internal ones", {
  df <- data.frame(given_name = "X", family_name = "Y", literal_name = "A B")
  aut <- Plume$new(df)
  expect_equal(aut$get_plume()$literal_name, "X Y")
})

test_that("initialize() makes proper initials and literal names", {
  df <- data.frame(
    given_name = c("Zip", "ric", "Pim-Pam", "Tic", "Fip", "12"),
    family_name = c("Zap", "rac", "Pom", "tac Toc", "A'Fop", "34")
  )
  aut <- Plume$new(df)

  expect_equal(
    aut$get_plume()$literal_name,
    paste(df$given_name, df$family_name)
  )
  expect_equal(
    aut$get_plume()$initials,
    c("ZZ", "rr", "P-PP", "TtT", "FA'F", "13")
  )
})

test_that("`affiliation`, `role` and `note` columns are nestable", {
  aut <- Plume$new(basic_df())

  get_nested_cols <- function(x) {
    names(x)[sapply(x, is.list)]
  }

  cols <- get_nested_cols(aut$get_plume())
  expect_equal(cols, c("affiliation", "role", "note"))
})

test_that("single nestables don't nest", {
  aut <- Plume$new(data.frame(given_name = "X", family_name = "Y", note = "a"))
  expect_false(is_nested(aut$get_plume(), "note"))
})

test_that("`credit_roles = TRUE` handles CRediT roles", {
  aut <- Plume$new(data.frame(
    given_name = "X",
    family_name = "Y",
    supervision = 1,
    writing = 1,
    editing = NA
  ), credit_roles = TRUE)

  expect_equal(
    sort(unlist(aut$get_plume()$role, use.names = FALSE)),
    sort(c("Supervision", "Writing - original draft", NA))
  )
})

test_that("`initials_given_name = TRUE` turns given names into initials", {
  df <- basic_df()
  aut <- Plume$new(df, initials_given_name = TRUE)
  initials <- make_initials(df$given_name, dot = TRUE)

  expect_equal(aut$get_plume()$given_name, initials)
  expect_equal(aut$get_plume()$literal_name, paste(initials, df$family_name))
})

test_that("`family_name_first = TRUE` switches given and family name", {
  df <- basic_df()
  aut <- Plume$new(df, family_name_first = TRUE)
  expect_equal(
    aut$get_plume()$literal_name,
    paste(df$family_name, df$given_name)
  )
})

test_that("languages with no capital letters don't use initials", {
  df <- data.frame(given_name = "耳", family_name = "李")
  aut <- Plume$new(df)
  expect_false(has_name(aut$get_plume(), "initials"))
})

test_that("`interword_spacing = FALSE` binds given and family names", {
  df <- data.frame(given_name = "耳", family_name = "李")
  aut <- Plume$new(df, interword_spacing = FALSE)
  expect_equal(aut$get_plume()$literal_name, "耳李")
})

test_that("`by` overrides default `by` value", {
  aut <- PlumeQuarto$new(basic_df(), tempfile_(), by = "initials")
  aut$set_corresponding_authors(zz)
  expect_equal(aut$get_plume()$corresponding, c(TRUE, FALSE, FALSE))
})

test_that("initialize() converts blank and empty strings to `NA` (#2)", {
  aut <- Plume$new(data.frame(
    given_name = "X",
    family_name = "Y",
    email = "",
    affiliation = "a",
    affiliation2 = "  ",
    affiliation3 = "\n"
  ))

  expect_equal(
    unlist(aut$get_plume(), use.names = FALSE),
    c("1", "X", "Y", "X Y", "XY", NA, "a", NA, NA)
  )
})

test_that("initialize() trims leading/trailing white spaces", {
  aut <- Plume$new(data.frame(
    given_name = "zip\n ",
    family_name = "zap",
    email = "  zipzap@email.com ",
    affiliation = "\n\na",
    affiliation2 = " b\t"
  ))

  expect_equal(
    unlist(aut$get_plume(), use.names = FALSE),
    c("1", "zip", "zap", "zip zap", "zipzap@email.com", "a", "b")
  )
})

# Errors ----

test_that("initialize() gives meaningful error messages", {
  df <- basic_df()

  expect_snapshot({
    (expect_error(
      Plume$new(list(x = 1))
    ))
    (expect_error(
      Plume$new(data.frame(family_name = "x"))
    ))
    (expect_error(
      Plume$new(data.frame(given_name = "x", family_name = ""))
    ))
    (expect_error(
      Plume$new(data.frame(given_name = "x"))
    ))
    (expect_error(
      Plume$new(df, names = list(given_name = "prénom"))
    ))
    (expect_error(
      Plume$new(df, names = "prénom")
    ))
    (expect_error(
      Plume$new(df, names = c(given_name = "prénom", family_name = "prénom"))
    ))
    (expect_error(
      Plume$new(df, names = c(given_name = "prénom", given_name = "nom"))
    ))
    (expect_error(
      Plume$new(df, symbols = c(note = letters))
    ))
    (expect_error(
      Plume$new(df, symbols = list(note = NULL, note = NULL))
    ))
    (expect_error(
      Plume$new(df, orcid_icon = NULL)
    ))
    (expect_error(
      Plume$new(df, initials_given_name = 1)
    ))
    (expect_error(
      Plume$new(df, family_name_first = 1)
    ))
    (expect_error(
      Plume$new(df, credit_roles = 1)
    ))
    (expect_error(
      Plume$new(df, interword_spacing = 1)
    ))
    (expect_error(
      PlumeQuarto$new(df, tempfile_(), by = 1)
    ))
    (expect_error(
      PlumeQuarto$new(df, tempfile_(), by = "")
    ))
    (expect_error(
      PlumeQuarto$new(df, tempfile_(), by = "foo")
    ))
  })
})
