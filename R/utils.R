flatten <- partial(list_flatten, name_spec = "{inner}")

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

is_not_na <- Negate(is.na)

not_na_any <- function(cols) {
  if_any(all_of(cols), is_not_na)
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

bind <- function(x, sep = ",", arrange = TRUE) {
  out <- condense(x)
  if (arrange) {
    out <- vector_arrange(out)
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

drop_na.default <- function(data, ...) {
  data[is_not_na(data)]
}

itemise_rows <- function(data, cols) {
  out <- map(data[cols], as.character)
  list_transpose(out)
}

collapse <- function(x, sep = "") {
  paste(x, collapse = sep)
}

collapse_cols <- function(data, cols, sep) {
  if (length(cols) == 1L) {
    return(data[[cols]])
  }
  rows <- itemise_rows(data, cols)
  map_vec(rows, \(row) collapse(drop_na(row), sep))
}

dissolve <- function(data, dict, callback, env = caller_env()) {
  iwalk(dict, \(value, key) {
    assign(key, callback(data, value), envir = env)
  })
}

extract_glue_exprs <- function(x) {
  string_extract_all(x, "(?<=\\{)[^}]+")
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
  drop_na(unique(x))
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
  if (.Platform$OS.type == "unix") "\n" else "\r\n"
}

plm_obj <- function(x, name, ...) {
  structure(x, name = name, class = c("plm", "character"), ...)
}

unstructure <- function(x) {
  attributes(x) <- NULL
  x
}

unnest_drop <- function(x, cols) {
  x <- unnest(x, cols = all_of(cols))
  drop_na(x, all_of(cols))
}

add_group_ids <- function(x, cols) {
  for (col in cols) {
    x[predot(col)] <- group_id(x[[col]])
  }
  x
}

set_suffixes <- function(x, cols, symbols) {
  .cols <- predot(cols)
  iwalk(symbols[names(cols)], \(value, key) {
    if (is.null(value)) {
      return()
    }
    if (key == "orcid") {
      x <<- set_orcid_icons(x, value)
    } else {
      x <<- set_symbols(x, .cols[key], value)
    }
  })
  x
}

set_symbols <- function(x, col, symbols) {
  if (is.null(symbols)) {
    return(x)
  }
  values <- x[[col]]
  symbols <- seq_symbols(symbols,  values)
  x[col] <- symbols[values]
  x
}

set_orcid_icons <- function(x, orcid) {
  x[predot(orcid)] <- make_orcid_link(x[[orcid]])
  x
}
