basic_df <- function() {
  given_names <- c("Aa", "Cc-Ca", "Bb")
  family_names <- c("Xx", "Zz", "Yy")
  data.frame(
    given_name = given_names,
    family_name = family_names,
    literal_name = paste(given_names, family_names),
    affiliation = letters[1:3],
    affiliation2 = c("d", NA, "a"),
    role = rep("a", 3),
    role2 = c("d", NA, NA),
    note = c("a", NA, "b"),
    email = paste0(c("a@x", "c@z", "b@y"), ".foo"),
    phone = c("00", NA, NA)
  )
}

dedent <- function(string) {
  out <- string_trim(string)
  ws_regex <- "(?<=\n) "
  ws <- string_extract_all(out, paste0(ws_regex, "+"))
  ws_n <- min(nchar(ws))
  string_remove_all(out, paste0(ws_regex, "{", ws_n, "}"))
}
