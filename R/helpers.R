col_count <- function(x, name) {
  length(grep(name, names(x)))
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

if_not_empty <- function(x, value, ...) {
  if_else(x == "", x, value, ...)
}

if_not_na <- function(x, value, ..., all = FALSE) {
  cnd <- is.na(x)
  if (all) {
    cnd <- all(cnd)
  }
  if_else(cnd, NA, value, ...)
}

dot <- function(x) {
  string_replace_all(x, "(?<=\\pL)", ".")
}

make_initials <- function(x, dot = FALSE) {
  out <- string_remove_all(x, "[^\\p{Lu}-]+")
  if (dot) {
    out <- dot(out)
  }
  out
}

make_suffixes <- function(x) {
  string_remove(
    glue(x, .envir = caller_env()),
    "\\^(?=,\\^)|(?<=^),|^\\^{2}|\\^{2}$"
  )
}

bind <- function(x, sep = ",", arrange = TRUE) {
  out <- condense(x)
  if (arrange) {
    out <- vector_arrange(out)
  }
  paste(out, collapse = sep)
}

flatten <- partial(list_flatten, name_spec = "{inner}")

caller_args <- function(n = 2) {
  as.list(caller_env(n))
}

arg_names_true <- function() {
  args <- caller_args()
  args_true <- args[map_vec(args, is_true)]
  names(args_true)
}

join <- function(data, cols, sep) {
  if (length(cols) == 1L) {
    return(data[[cols]])
  }
  head <- cols[1]
  out <- map(cols, \(value) {
    values <- data[[value]]
    these <- values
    if (value != head) {
      these <- paste0(sep, these)
    }
    replace(these, is.na(values), "")
  })
  reduce(out, paste0)
}

dissolve <- function(data, dict, callback, env = caller_env()) {
  iwalk(dict, \(value, key) {
    assign(key, callback(data, value), envir = env)
  })
}

extract_glue_exprs <- function(x) {
  string_extract_all(x, "(?<=\\{)[^}]+")
}

invert <- function(x, sep) {
  paste(rev(string_split(x, sep)), collapse = sep)
}

unique.list <- function(x, ...) {
  unique(unlist(x, use.names = FALSE), ...)
}

vector_arrange <- function(x) {
  x[order(nchar(x), x)]
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

condense <- function(x) {
  x <- unique(x)
  x[!is.na(x)]
}

supplant <- function(old, new) {
  new <- new[names(new) %in% names(old)]
  if (identical(new, old)) {
    return(old)
  }
  indexes <- match(names(new), names(old))
  replace(old, indexes, new)
}

to_chr_class <- function(x, negate = FALSE) {
  neg <- if (negate) "^" else ""
  x <- paste(x, collapse = "")
  x <- string_replace(x, r"{([-\\\[\]])}", r"{\\\1}")
  paste0("[", neg, x, "]")
}

wrap <- function(x, value) {
  paste0(value, x, value)
}
