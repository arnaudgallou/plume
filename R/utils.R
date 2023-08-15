unique.list <- function(x, ...) {
  unique(unlist(x, use.names = FALSE), ...)
}

selfname <- function(x) {
  set_names(x, x)
}

includes <- function(x, y, ignore_case = TRUE) {
  out <- list(x = x, y = y)
  if (ignore_case) {
    out <- map(out, tolower)
  }
  out$x %in% out$y
}

true_if <- function(condition, ...) {
  if_else(condition, TRUE, FALSE, ...)
}

if_not_na <- function(x, value, ..., all = FALSE) {
  cnd <- is.na(x)
  if (all) {
    cnd <- all(cnd)
  }
  if_else(cnd, NA, value, ...)
}

is_not_na <- Negate(is.na)

not_na_any <- function(cols) {
  if_any(all_of(cols), is_not_na)
}

dot <- function(x) {
  string_replace_all(x, "(*UCP)(?<=\\w(?!\\p{Po}))", ".")
}

make_initials <- function(x, dot = FALSE) {
  out <- string_remove_all(x, "(*UCP)\\B\\w+|\\s+")
  if (dot) {
    out <- dot(out)
  }
  out
}

drop_from <- function(x, ...) {
  x[!x %in% c(...)]
}

vec_drop_na <- function(x, ...) {
  x[is_not_na(x)]
}

vec_arrange <- function(x) {
  x[order(nchar(x), x)]
}

condense <- function(x) {
  vec_drop_na(unique(x))
}

collapse <- function(x, sep = "") {
  paste(x, collapse = sep)
}

bind <- function(x, sep = ",", arrange = TRUE) {
  out <- condense(x)
  if (arrange) {
    out <- vec_arrange(out)
  }
  collapse(out, sep)
}

caller_args <- function(n = 2) {
  as.list(caller_env(n))
}

arg_names_true <- function() {
  args <- caller_args()
  args_true <- args[map_vec(args, is_true)]
  names(args_true)
}

extract_glue_exprs <- function(x) {
  string_extract_all(x, "(?<=\\{)[^}]+")
}

group_id <- function(x) {
  out <- vec_group_id(x)
  out <- replace(out, is.na(x) | x == 0L, NA)
  dense_rank(out)
}

predot <- function(name) {
  name[] <- paste0(".", name)
  name
}

propagate_na <- function(x, from) {
  replace(x, is.na(from), NA)
}

to_chr_class <- function(x, negate = FALSE) {
  neg <- if (negate) "^" else ""
  x <- collapse(x)
  x <- string_replace(x, r"{([-\\\[\]])}", r"{\\\1}")
  paste0("[", neg, x, "]")
}

wrap <- function(x, value) {
  paste0(value, x, value)
}

is_blank <- function(x) {
  string_detect(x, "^\\s*$")
}

blank_to_na <- function(x) {
  replace(x, is_blank(x), NA)
}

get_eol <- function() {
  if (.Platform$OS.type == "unix") "\n" else "\r\n" # nocov
}

unstructure <- function(x) {
  attributes(x) <- NULL
  x
}
