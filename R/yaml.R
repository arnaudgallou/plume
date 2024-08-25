schemas_are_up_to_date <- function(current, new) {
  current <- current[c("author", "affiliations")]
  identical(current, new)
}

json_update <- function(x, json) {
  json <- as_json(json)
  if (schemas_are_up_to_date(x, json)) {
    return()
  }
  out <- if (is.null(x)) json else list_assign(x, !!!json)
  list_drop_empty(out)
}

as_json <- function(x) {
  x <- toJSON(x)
  parse_json(x)
}

separate_yaml_header <- function(x) {
  str_split_1(x, "(?m:^|\\R\\K)-{3}(?:\\R|$)")
}

as_verbatim_lgl <- function(x) {
  x <- if_else(x, "true", "false")
  structure(x, class = "verbatim")
}

get_eol <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n" # nocov
}

yaml_inject <- function(x, lines) {
  eol <- get_eol()
  yaml <- as.yaml(
    x,
    line.sep = eol,
    indent.mapping.sequence = TRUE,
    handlers = list(logical = as_verbatim_lgl)
  )
  out <- replace(lines, 2, yaml)
  collapse(out, paste0("---", eol))
}

has_yaml <- function(x) {
  str_detect(x, "(?s)^\\R*---\\R.*\\B---(?:\\R|$)")
}

check_has_yaml <- function(x) {
  if (has_yaml(x)) {
    return(invisible())
  }
  abort_check(msg = c(
    "No YAML headers found.",
    i = "YAML headers must be at the beginning of the document.",
    i = "YAML headers must start and end with three hyphens."
  ))
}

yaml_has_strippable <- function(x) {
  pattern <- paste(
    "\\B#(?=(?:[^'\"]*['\"][^'\"]*['\"])*[^'\"]*$)",
    ":\\s*(?:>|!!?[a-z]+|&)",
    sep = "|"
  )
  str_detect(x, pattern)
}

add_yaml_header <- function(x) {
  rlang::warn(c(
    "Writing author metadata in a separate YAML header.",
    i = "This happens because the original YAML contained information such as",
    "  comments, custom tags or folded blocks that would otherwise be lost."
  ))
  c("", "", x)
}

yaml_push <- function(x, file) {
  UseMethod("yaml_push")
}

yaml_push.default <- function(x, file) {
  old <- yaml::read_yaml(file)
  json <- json_update(old, x)
  if (is.null(json)) {
    return(invisible())
  }
  yaml::write_yaml(
    json,
    file,
    line.sep = get_eol(),
    indent.mapping.sequence = TRUE,
    handlers = list(logical = as_verbatim_lgl)
  )
}

yaml_push.qmd <- function(x, file) {
  text <- read_file(file)
  check_has_yaml(text)
  items <- separate_yaml_header(text)
  if (yaml_has_strippable(items[[2]])) {
    items <- add_yaml_header(items)
  }
  old <- yaml.load(items[[2]])
  json <- json_update(old, x)
  if (is.null(json)) {
    return(invisible())
  }
  lines <- yaml_inject(json, items)
  write_lines(lines, file = file, sep = "")
}
