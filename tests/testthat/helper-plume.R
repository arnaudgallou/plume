basic_df <- tibble(
  given_name = c("Zip", "Ric", "Pim-Pam"),
  family_name = c("Zap", "Rac", "Pom"),
  literal_name = paste(given_name, family_name),
  initials = c("ZZ", "RR", "P-PP"),
  affiliation = c("a", "c", "d"),
  affiliation2 = c("b", NA, "a"),
  analysis = rep(1, 3),
  writing = c(1, NA, NA),
  note = c("a", NA, "b"),
  note2 = c("c", NA, NA),
  email = paste0(c("zipzap", "ricrac", "pimpampom"), "@test.com"),
  phone = c("+1234", NA, NA),
  orcid = c(
    "0000-0000-0000-0001",
    "0000-0000-0000-0002",
    NA
  ),
)

temp_file <- function() {
  withr::local_tempfile(
    lines = "---\n---",
    fileext = ".qmd",
    .local_envir = rlang::caller_env()
  )
}

dedent <- function(string) {
  indent <- sub("(?s)\\S*\n(\\s*).+", "\\1", string, perl = TRUE)
  out <- gsub(paste0("(?m)^", indent), "", string, perl = TRUE)
  trimws(out)
}

read_test_file <- function(file) {
  cat(readr::read_file(file))
}

scrub_icon_path <- function(x) {
  path_regex <- "(?<=\\()(?:[A-Z]:)?\\/.+\\/(?=[\\w-]+\\.(?:pdf|svg)\\))"
  sub(path_regex, "", x, perl = TRUE)
}

pull_nested_var <- function(cls, nested_var, pull) {
  out <- unnest(cls$data(), cols = all_of(nested_var))
  out[[pull]]
}
