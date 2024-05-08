make_emails <- function(x) {
  out <- gsub(".+\\b(\\w+)$", "\\1", x, perl = TRUE)
  out <- tolower(out)
  paste0(out, "@encyclopediste.fr")
}

encyclopedists <- tibble::tibble(
  given_name = c("Denis", "Jean-Jacques", "François-Marie", "Jean"),
  family_name = c("Diderot", "Rousseau", "Arouet", "Le Rond d'Alembert"),
  email = make_emails(family_name),
  phone = c("+1234", NA, NA, NA),
  orcid = c(paste0("0000-0000-0000-000", 1:2), NA, "0000-0000-0000-0003"),
  supervision = c(1, NA, NA, 1),
  writing = 1,
  note = c(
    "born in 1713 in Langres",
    NA,
    "also known as Voltaire",
    "born in 1717 in Paris"
  ),
  affiliation_1 = c(
    "Université de Paris",
    rep("Lycée Louis-le-Grand", 2L),
    "Université de Paris"
  ),
  affiliation_2 = c(NA, NA, NA, "Collège des Quatre-Nations"),
)

encyclopedists_fr <- encyclopedists |>
  dplyr::rename(
    prénom = given_name,
    nom = family_name,
    courriel = email,
    téléphone = phone,
    rédaction = writing
  ) |>
  dplyr::mutate(note = c(
    "né en 1713 à Langres",
    NA,
    "dit Voltaire",
    "né en 1717 à Paris"
  ))

usethis::use_data(encyclopedists, encyclopedists_fr, overwrite = TRUE)
