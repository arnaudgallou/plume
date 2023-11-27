unique.list <- function(x, ...) {
  unique(squash(x), ...)
}

squash <- function(x) {
  unlist(x, use.names = FALSE)
}

begins_with <- function(x) {
  paste0("^", x)
}

if_not_na <- function(x, value, ..., all = FALSE) {
  cnd <- is.na(x)
  if (all) {
    cnd <- all(cnd)
  }
  if_else(cnd, NA, value, ...)
}

not_na_any <- function(cols) {
  if_any(all_of(cols), is_not_na)
}

dot <- function(x) {
  string_replace_all(x, "(?<=[\\pL\\pN](?!\\p{Po}))", ".")
}

make_initials <- function(x, dot = FALSE) {
  out <- string_remove_all(x, "(*UCP)\\B\\w+|[\\s.]+")
  if (dot) {
    out <- dot(out)
  }
  out
}

discard <- function(x, ...) {
  x[!vec_in(x, c(...))]
}

vec_drop_na <- function(x) {
  x[is_not_na(x)]
}

vec_arrange <- function(x) {
  x[order(nchar(x), x)]
}

vec_in <- function(x, y, ignore_case = TRUE) {
  if (ignore_case) {
    x <- tolower(x)
    y <- tolower(y)
  }
  x %in% y
}

vec_match <- function(x, y, ignore_case = TRUE) {
  if (ignore_case) {
    x <- tolower(x)
    y <- tolower(y)
  }
  match(x, y)
}

rank <- function(x, base) {
  matches <- vec_match(x, base)
  vec_rank(matches, ties = "dense")
}

assign_to_names <- function(x, names) {
  x <- rep(list(x), length(names))
  set_names(x, names)
}

collect_dots <- function(...) {
  if (are_calls(...)) {
    return(c(...))
  }
  enexprs(...)
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

get_params_set_to_true <- function() {
  args <- caller_args()
  args_true <- args[map_vec(args, is_true)]
  names(args_true)
}

extract_glue_vars <- function(x) {
  string_extract_all(x, "(?<=\\{\\b)[^}]+")
}

group_id <- function(x) {
  out <- vec_group_id(x)
  out <- replace(out, is.na(x) | x == 0L, NA)
  dense_rank(out)
}

predot <- function(x) {
  x[] <- paste0(".", x)
  x
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

blank_to_na <- function(x) {
  replace(x, is_blank(x), NA)
}

unstructure <- function(x) {
  attributes(x) <- NULL
  x
}
