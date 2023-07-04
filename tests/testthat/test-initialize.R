test_that("initialize() builds a plume dataset", {
  df_en <- data.frame(given_name = "X", family_name = "Y", email = "@")
  nms_en <- c("id", "given_name", "family_name", "literal_name", "initials", "email")
  aut <- Plume$new(df_en)

  expect_true(tibble::is_tibble(aut$plume))
  expect_named(aut$plume, nms_en)

  df_fr <- data.frame(prénom = "X", nom = "Y", courriel = "@")
  nms_fr <- c("id", "prénom", "nom", "nom_complet", "initiales", "courriel")
  aut <- Plume$new(df_fr, names = setNames(nms_fr, nms_en))

  expect_named(aut$plume, nms_fr)
})

test_that("initialize() ignores unknown variables", {
  df <- data.frame(given_name = "X", family_name = "Y", foo = "")
  aut <- Plume$new(df)
  expect_false(has_name(aut$plume, "foo"))
})

test_that("initialize() ignores variables with the same name as internal ones", {
  df <- data.frame(given_name = "X", family_name = "Y", literal_name = "A B")
  aut <- Plume$new(df)
  expect_equal(aut$plume$literal_name, "X Y")
})

test_that("initialize() makes proper initials and literal names", {
  df <- basic_df()
  aut <- Plume$new(df)

  literal_names <- df$literal_name
  initials <- make_initials(literal_names)

  expect_equal(aut$plume$initials, initials)
  expect_equal(aut$plume$literal_name, literal_names)
})

test_that("`affiliation`, `role` and `note` columns are nestable", {
  aut <- Plume$new(cbind(basic_df(), data.frame(note2 = "")))

  get_nested_cols <- function(x) {
    names(x)[sapply(x, is.list)]
  }

  cols <- get_nested_cols(aut$plume)
  expect_equal(cols, c("affiliation", "role", "note"))
})

test_that("single nestables don't nest", {
  aut <- Plume$new(basic_df())
  expect_false(is_nested(aut$plume, "note"))
})

test_that("`initials_given_name = TRUE` turns given names into initials", {
  df <- basic_df()
  aut <- Plume$new(df, initials_given_name = TRUE)
  initials <- make_initials(df$given_name, dot = TRUE)

  expect_equal(aut$plume$given_name, initials)
  expect_equal(aut$plume$literal_name, paste(initials, df$family_name))
})

test_that("`family_name_first = TRUE` switches given and family name", {
  df <- basic_df()
  aut <- Plume$new(df, family_name_first = TRUE)
  expect_equal(
    aut$plume$literal_name,
    paste(df$family_name, df$given_name)
  )
})

test_that("languages with no capital letters don't use initials", {
  df <- data.frame(given_name = "耳", family_name = "李")
  aut <- Plume$new(df)
  expect_false(has_name(aut$plume, "initials"))
})

test_that("`interword_spacing = FALSE` binds given and family names", {
  df <- data.frame(given_name = "耳", family_name = "李")
  aut <- Plume$new(df, interword_spacing = FALSE)
  expect_equal(aut$plume$literal_name, "耳李")
})

test_that("`symbols` overrides default `symbols` values", {
  aut <- Plume$new(basic_df(), symbols = list(affiliation = letters, note = NULL))
  expect_equal(
    aut$symbols,
    list(affiliation = letters, corresponding = "\\*", note = NULL)
  )
})

test_that("`by` overrides default `by` value", {
  aut <- Plume$new(basic_df(), by = "initials")
  expect_equal(aut$by, "initials")
})

test_that("initialize() ignores unknown `symbols` keys", {
  aut <- Plume$new(basic_df(), symbols = list(foo = letters))
  expect_false(has_name(aut$symbols, "foo"))
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
    unlist(aut$plume, use.names = FALSE),
    c("1", "X", "Y", "X Y", "XY", NA, "a", NA, NA)
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
      Plume$new(df, names = c("prénom"))
    ))
    (expect_error(
      Plume$new(df, names = c(given_name = "prénom", family_name = "prénom"))
    ))
    (expect_error(
      Plume$new(df, names = c(given_name = "prénom", given_name = "nom"))
    ))
    (expect_error(
      Plume$new(df, by = 1)
    ))
    (expect_error(
      Plume$new(df, by = "")
    ))
    (expect_error(
      Plume$new(df, symbols = c(note = letters))
    ))
    (expect_error(
      Plume$new(df, symbols = list(note = NULL, note = NULL))
    ))
    (expect_error(
      Plume$new(df, by = "foo")
    ))
    (expect_error(
      Plume$new(df, initials_given_name = 1)
    ))
    (expect_error(
      Plume$new(df, family_name_first = 1)
    ))
    (expect_error(
      Plume$new(df, interword_spacing = 1)
    ))
  })
})
