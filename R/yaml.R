eol <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n" # nocov
}

.yaml_args <- list(
  line.sep = eol(),
  indent.mapping.sequence = TRUE,
  handlers = list(logical = yaml::verbatim_logical)
)

schemas_are_up_to_date <- function(old, new) {
  old <- old[c("author", "affiliations")]
  identical(old, new)
}

json_update <- function(old, new) {
  new <- as_json(new)
  if (schemas_are_up_to_date(old, new)) {
    return()
  }
  out <- if (is.null(old)) new else list_assign(old, !!!new)
  list_drop_empty(out)
}

as_json <- function(x) {
  x <- toJSON(x)
  parse_json(x)
}

separate_yaml_header <- function(x) {
  str_split_1(x, "(?m:^|\\R\\K)-{3}(?:\\R|$)")
}

yaml_inject <- function(x, lines) {
  yaml <- do.call(yaml::as.yaml, c(list(x), .yaml_args))
  out <- replace(lines, 2L, yaml)
  collapse(out, paste0("---", eol()))
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
  do.call(yaml::write_yaml, c(list(json), file, .yaml_args))
}

yaml_push.qmd <- function(x, file) {
  text <- read_file(file)
  check_has_yaml(text)
  items <- separate_yaml_header(text)
  if (yaml_has_strippable(items[[2]])) {
    items <- add_yaml_header(items)
  }
  old <- yaml::yaml.load(items[[2]])
  json <- json_update(old, x)
  if (is.null(json)) {
    return(invisible())
  }
  lines <- yaml_inject(json, items)
  write_lines(lines, file = file, sep = "")
}
