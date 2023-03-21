basic_df <- function() {
  given_names <- c("Aa", "Cc-Ca", "Bb")
  family_names <- c("Xx", "Zz", "Yy")
  data.frame(
    given_name = given_names,
    family_name = family_names,
    literal_name = paste(given_names, family_names),
    affiliation = letters[1:3],
    affiliation2 = c("d", NA, "a"),
    contribution = rep("a", 3),
    contribution2 = c("d", NA, NA),
    note = c("a", NA, "b"),
    email = paste0(c("a@x", "c@z", "b@y"), ".foo"),
    number = c("00", NA, NA)
  )
}
