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
  str_replace_all(x, "(?<=[\\p{L}\\p{N}](?!\\p{Po}))", ".")
}

make_initials <- function(x, dot = FALSE) {
  out <- str_remove_all(x, "\\B\\w+|[\\s.]+")
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

recycle_to_names <- function(x, nms) {
  if (is_named(nms)) {
    nms <- names(nms)
  }
  x <- rep(list(x), length(nms))
  set_names(x, nms)
}

propagate_names <- function(x, nms) {
  if (is_named(nms)) {
    nms <- names(nms)
  }
  nms <- nms[!nms %in% names(x)]
  named <- have_name(x)
  items <- list(x[named], squash(x[!named]))
  items[[2]] <- recycle_to_names(items[[2]], nms)
  unlist(items, recursive = FALSE)
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

expr_type <- function(expr) {
  if (is.vector(expr) || is.symbol(expr)) {
    "symbol"
  } else if (is_call(expr, "c")) {
    "atomic"
  } else if (is_selector(expr)) {
    "selector"
  } else {
    typeof(expr)
  }
}

expr_cases <- function(expr) {
  switch(
    expr_type(expr),
    symbol = as.character(expr),
    atomic = as.character(expr[-1]),
    selector = eval(expr),
    abort(
      glue("Can't match elements with `{deparse(expr)}`."),
      call = caller_env(5)
    )
  )
}

collect_dots <- function(...) {
  out <- without_indexed_error(map(enexprs(...), expr_cases))
  if (any(have_name(out))) {
    return(out)
  }
  squash(out)
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
  str_extract_all(x, "(?<=\\{\\b)[^}]+", simplify = TRUE)
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
  x <- str_replace(x, r"{([-\\\[\]])}", r"{\\\1}")
  paste0("[", neg, x, "]")
}

str_contain <- function(string, pattern) {
  str_detect(string, fixed(pattern))
}

str_detect <- function(string, pattern) {
  out <- stringr::str_detect(string, pattern)
  replace(out, is.na(string), FALSE)
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

add_class <- function(x, cls) {
  class(x) <- c(cls, class(x))
  x
}
