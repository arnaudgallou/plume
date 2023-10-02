schemas_are_up_to_date <- function(current, new) {
  current <- current[c("author", "affiliations")]
  identical(current, new)
}

json_update <- function(x, json) {
  x <- yaml.load(x)
  if (is.null(x)) {
    return(json)
  }
  if (schemas_are_up_to_date(x, json)) {
    return()
  }
  list_assign(x, !!!json)
}

as_json <- function(x) {
  x <- toJSON(x)
  parse_json(x)
}

separate_yaml_header <- function(x) {
  # use of stringr to preserve a match at the end of the string
  stringr::str_split(x, "(?m:^|\\R)-{3}(?:\\R|$)")[[1]]
}

as_verbatim_lgl <- function(x) {
  x <- if_else(x, "true", "false")
  structure(x, class = "verbatim")
}

get_eol <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n" # nocov
}

yaml_inject <- function(lines, replacement) {
  eol <- get_eol()
  yaml <- as.yaml(
    replacement,
    line.sep = eol,
    indent.mapping.sequence = TRUE,
    handlers = list(logical = as_verbatim_lgl)
  )
  out <- replace(lines, 2, yaml)
  collapse(out, paste0("---", eol))
}

has_yaml <- function(x) {
  string_detect(x, "(?s)^\\R*---\\R.*\\B---(?:\\R|$)")
}

check_has_yaml <- function(x) {
  if (has_yaml(x)) {
    return(invisible(NULL))
  }
  abort_check(msg = c(
    "No YAML headers found.",
    i = "YAML headers must be at the top of the document.",
    i = "YAML headers must start and end with three hyphens."
  ))
}

yaml_push <- function(what, file) {
  text <- read_file(file)
  check_has_yaml(text)
  items <- separate_yaml_header(text)
  json <- as_json(what)
  json <- json_update(items[2], json)
  if (is.null(json)) {
    return(invisible(NULL))
  }
  lines <- yaml_inject(items, json)
  write_lines(lines, file = file, sep = "")
}
