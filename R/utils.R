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

all_na <- function(cols) {
  dplyr::if_all(all_of(cols), is.na)
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

lengthen_initials <- function(initials, names) {
  str_replace(initials, "(?=\\.?$)", get_shortest_unique_suffixes(names))
}

last_word <- function(x) {
  x <- strsplit(x, "\\W")
  map_vec(x, \(.x) .x[length(.x)])
}

str_starts <- function(x, y) {
  substr(x, 1L, nchar(y)) == y
}

get_shortest_unique_suffixes <- function(x) {
  x <- last_word(x)
  purrr::imap_vec(x, \(value, key) {
    names <- x[-key]
    n_chars <- nchar(value)
    if (value %in% names || n_chars == 1L) {
      return("")
    }
    for (i in seq_len(n_chars)[-1]) {
      prefix <- substr(value, 1L, i)
      if (!any(str_starts(names, prefix))) {
        return(stringr::str_sub(prefix, 2L))
      }
    }
  })
}

undot <- function(x) {
  gsub(".", "", x, fixed = TRUE)
}

vec_drop_na <- function(x) {
  x[!is.na(x)]
}

vec_arrange <- function(x) {
  x[order(nchar(x), x)]
}

vec_normalise <- function(x, y, ignore_case = TRUE, ignore_dots = FALSE) {
  map(list(x = x, y = y), \(item) {
    if (ignore_case) {
      item <- tolower(item)
    }
    if (ignore_dots) {
      item <- undot(item)
    }
    item
  })
}

vec_in <- function(x, y, ignore_case = TRUE, ignore_dots = FALSE) {
  items <- vec_normalise(x, y, ignore_case, ignore_dots)
  items$x %in% items$y
}

vec_match <- function(x, y, ignore_case = TRUE, ignore_dots = TRUE) {
  items <- vec_normalise(x, y, ignore_case, ignore_dots)
  match(items$x, items$y)
}

rank <- function(x, base) {
  matches <- vec_match(x, base)
  vctrs::vec_rank(matches, ties = "dense")
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
      "Can't match elements with `{deparse(expr)}`.",
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

get_detail_vars <- function() {
  args <- caller_args()
  args_true <- args[map_vec(args, rlang::is_true)]
  names(args_true)
}

extract_glue_vars <- function(x) {
  str_extract_all(x, "(?<=\\{\\b)[^}]+", simplify = TRUE)
}

group_id <- function(x) {
  out <- vctrs::vec_group_id(x)
  out <- replace(out, is.na(x) | x == 0L, NA)
  dplyr::dense_rank(out)
}

predot <- function(x) {
  x[] <- paste0(".", x)
  x
}

propagate_na <- function(x, from) {
  replace(x, is.na(from), NA)
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

add_class <- function(x, cls, inherit = TRUE) {
  class(x) <- c(cls, if (inherit) class(x))
  x
}

split_chars <- function(x) {
  strsplit(x, "", fixed = TRUE)[[1]]
}

quos <- function(...) {
  rlang::quos(..., .named = TRUE)
}

md_escape <- function(x) {
  if (is.null(x)) {
    return()
  }
  gsub("([\\\\`#.*+!_{}\\[\\]()-])", "\\\\\\1", x, perl = TRUE)
}
