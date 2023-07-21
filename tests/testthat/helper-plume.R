basic_df <- function() {
  given_names <- c("Zip", "Ric", "Pim-Pam")
  family_names <- c("Zap", "Rac", "Pom")
  data.frame(
    given_name = given_names,
    family_name = family_names,
    literal_name = paste(given_names, family_names),
    affiliation = c("a", "c", "d"),
    affiliation2 = c("b", NA, "a"),
    role = rep("a", 3),
    role2 = c("b", NA, NA),
    note = c("a", NA, "b"),
    note2 = c("c", NA, NA),
    email = paste0(c("zipzap", "ricrac", "pimpampom"), "@test.tst"),
    phone = c("00", NA, NA),
    orcid = c(
      "0000-0000-0000-0001",
      "0000-0000-0000-0002",
      NA
    )
  )
}

dedent <- function(string) {
  out <- string_trim(string)
  ws_regex <- "(?<=\n) "
  ws <- string_extract_all(out, paste0(ws_regex, "+"))
  ws_n <- min(nchar(ws))
  string_remove_all(out, paste0(ws_regex, "{", ws_n, "}"))
}

read_test_file <- function(file) {
  cat(readr::read_file(file))
}

scrub_icon_path <- function(x) {
    sub("(?<=\\()\\/.+\\/(?=[\\w-]+\\.(?:pdf|svg)\\))", "", x, perl = TRUE)
}