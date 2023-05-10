is_schema_up_to_date <- function(current, new) {
  current <- current[c("author", "affiliations")]
  identical(current, new)
}

line_break <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n"
}

json_update <- function(text, json) {
  out <- yaml.load(text)
  if (is.null(out)) {
    return(json)
  }
  if (is_schema_up_to_date(out, json)) {
    return()
  }
  list_assign(out, !!!json)
}

as_json <- function(x) {
  x <- toJSON(x)
  parse_json(x)
}

separate_yaml_header <- function(text) {
  # use of stringr to preserve a match at the end of the string
  stringr::str_split(text, "(?:^|\\R)-{3}(?:\\R|$)")[[1]]
}

as_verbatim_lgl <- function(x) {
  x <- if_else(x, "true", "false")
  structure(x, class = "verbatim")
}

yaml_inject <- function(lines, replacement) {
  if (length(lines) < 3L) {
    abort_check(msg = c(
      "Invalid YAML header.",
      i = "Did you forget to separate the YAML header with three hyphens?"
    ))
  }
  line_break <- line_break()
  yaml <- as.yaml(
    replacement,
    line.sep = line_break,
    indent.mapping.sequence = TRUE,
    handlers = list(logical = as_verbatim_lgl)
  )
  out <- replace(lines, 2, yaml)
  collapse(out, paste0("---", line_break))
}

yaml_push <- function(file, what) {
  text <- read_file(file)
  items <- separate_yaml_header(text)
  json <- as_json(what)
  json <- json_update(items[2], json)
  if (is.null(json)) {
    return(invisible(NULL))
  }
  lines <- yaml_inject(items, json)
  write_lines(lines, file = file, sep = "")
}
