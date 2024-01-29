test_that("initialize() builds a plume dataset", {
  aut <- Plume$new(basic_df)
  nms_en <- c(
    "id", "initials", "given_name", "family_name", "literal_name",
    "affiliation", "role", "note", "email", "phone", "orcid"
  )

  expect_named(aut$get_plume(), nms_en, ignore.order = TRUE)

  df_fr <- set_names(basic_df, c(
    "prénom", "nom", "nom_complet", "initiales", "affiliation", "affiliation2",
    "analyse", "rédaction", "note", "note2", "courriel", "téléphone", "orcid"
  ))
  nms_fr <- c(
    "id", "initiales", "prénom", "nom", "nom_complet", "affiliation",
    "role", "note", "courriel", "téléphone", "orcid"
  )
  aut <- Plume$new(
    df_fr,
    names = set_names(nms_fr, nms_en),
    roles = c(analyse = "a", rédaction = "b")
  )

  expect_named(aut$get_plume(), nms_fr, ignore.order = TRUE)
})

test_that("objects of class `data.frame` are converted to tibbles", {
  aut <- Plume$new(data.frame(given_name = "X", family_name = "Y"))
  expect_true(tibble::is_tibble(aut$get_plume()))
})

test_that("`Plume` drops `PlumeQuarto`-specific variables", {
  df <- data.frame(given_name = "X", family_name = "Y", dropping_particle = "o")

  aut <- Plume$new(df)
  nms <- c("id", "given_name", "family_name", "literal_name", "initials")
  expect_named(aut$get_plume(), nms)

  aut <- PlumeQuarto$new(df, tempfile_())
  nms <- c(nms, "dropping_particle")
  expect_named(aut$get_plume(), nms)
})

test_that("initialize() ignores unknown variables", {
  aut <- Plume$new(data.frame(given_name = "X", family_name = "Y", foo = ""))
  expect_false(has_name(aut$get_plume(), "foo"))
})

test_that("initialize() makes proper literal names", {
  aut <- Plume$new(basic_df)
  expect_equal(
    aut$get_plume()$literal_name,
    c("Zip Zap", "Ric Rac", "Pim-Pam Pom")
  )
})

test_that("initialize() ignores variables with the same name as internal ones", {
  aut <- Plume$new(data.frame(
    given_name = "X",
    family_name = "Y",
    literal_name = "A B"
  ))
  expect_equal(aut$get_plume()$literal_name, "X Y")
})

test_that("initialize() makes proper initials", {
  aut <- Plume$new(data.frame(
    given_name = c("Zip", "ric", "Pim-Pam", "Tic", "Fip", "12"),
    family_name = c("Zap", "rac", "Pom", "tac Toc", "A'Fop", "34")
  ))
  expect_equal(
    aut$get_plume()$initials,
    c("ZZ", "rr", "P-PP", "TtT", "FA'F", "13")
  )
})

test_that("initials remove dots (#31)", {
  aut <- Plume$new(data.frame(given_name = "X Y.", family_name = "Z"))
  expect_equal(aut$get_plume()$initials, "XYZ")
})

test_that("`affiliation`, `role` and `note` columns are nestable", {
  aut <- Plume$new(basic_df)

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

test_that("`roles = credit_roles()` handles CRediT roles", {
  aut <- Plume$new(data.frame(
    given_name = "X",
    family_name = "Y",
    supervision = 1,
    writing = 1,
    editing = NA
  ), roles = credit_roles())

  expect_equal(
    unlist(aut$get_plume()$role, use.names = FALSE),
    c("Supervision", "Writing - original draft", NA)
  )
})

test_that("`initials_given_name = TRUE` initialises given names", {
  aut <- Plume$new(basic_df, initials_given_name = TRUE)

  expect_equal(aut$get_plume()$given_name, c("Z.", "R.", "P.-P."))
  expect_equal(
    aut$get_plume()$literal_name,
    c("Z. Zap", "R. Rac", "P.-P. Pom")
  )
})

test_that("`initials_given_name` doesn't make initials in scripts not using letter cases (#73)", {
  aut <- Plume$new(
    data.frame(given_name = "菖蒲", family_name = "佐藤"),
    initials_given_name = TRUE
  )
  expect_equal(aut$get_plume()$given_name, "菖蒲")
})

test_that("`family_name_first = TRUE` switches given and family name", {
  aut <- Plume$new(basic_df, family_name_first = TRUE)
  expect_equal(
    aut$get_plume()$literal_name,
    c("Zap Zip", "Rac Ric", "Pom Pim-Pam")
  )
})

test_that("languages with no capital letters don't use initials", {
  df <- data.frame(given_name = "耳", family_name = "李")
  aut <- Plume$new(df)
  expect_false(has_name(aut$get_plume(), "initials"))
})

test_that("`interword_spacing = FALSE` binds given and family names", {
  aut <- Plume$new(
    data.frame(given_name = "耳", family_name = "李"),
    interword_spacing = FALSE
  )
  expect_equal(aut$get_plume()$literal_name, "耳李")
})

test_that("`by` overrides default `by` value", {
  aut <- Plume$new(basic_df, by = "initials")
  aut$set_corresponding_authors(zz)
  expect_equal(aut$get_plume()$corresponding, c(TRUE, FALSE, FALSE))

  aut <- PlumeQuarto$new(basic_df, tempfile_(), by = "initials")
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
      Plume$new(basic_df, names = list(given_name = "prénom"))
    ))
    (expect_error(
      Plume$new(basic_df, names = "prénom")
    ))
    (expect_error(
      Plume$new(
        basic_df,
        names = c(given_name = "prénom", family_name = "prénom")
      )
    ))
    (expect_error(
      Plume$new(basic_df, names = c(given_name = "prénom", given_name = "nom"))
    ))
    (expect_error(
      Plume$new(basic_df, symbols = c(note = letters))
    ))
    (expect_error(
      Plume$new(basic_df, symbols = list(note = NULL, note = NULL))
    ))
    (expect_error(
      Plume$new(basic_df, orcid_icon = NULL)
    ))
    (expect_error(
      Plume$new(basic_df, initials_given_name = 1)
    ))
    (expect_error(
      Plume$new(basic_df, family_name_first = 1)
    ))
    (expect_error(
      Plume$new(basic_df, credit_roles = 1)
    ))
    (expect_error(
      Plume$new(basic_df, interword_spacing = 1)
    ))
    (expect_error({
      withr::local_options(lifecycle_verbosity = "quiet")
      Plume$new(data.frame(
        given_name = "x", family_name = "y",
        role_1 = c("a", ""),
        role_2 = c("b", "c")
      ))
    }))
    (expect_error(
      Plume$new(basic_df, roles = 1)
    ))
    (expect_error(
      Plume$new(basic_df, roles = "foo")
    ))
    (expect_error(
      Plume$new(basic_df, roles = c(role = "foo", role = "bar"))
    ))
    (expect_error(
      Plume$new(basic_df, roles = c(role = "foo", role_2 = "foo"))
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, file = 1)
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, file = "")
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, file = "test.rmd")
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, file = "~/test.qmd")
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, tempfile_(), by = 1)
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, tempfile_(), by = "")
    ))
    (expect_error(
      PlumeQuarto$new(basic_df, tempfile_(), by = "foo")
    ))
  })
})
