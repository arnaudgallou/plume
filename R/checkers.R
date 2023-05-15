has_uppercase <- function(x) {
  string_detect(x, "\\p{Lu}")
}

detect_name <- function(x, name) {
  string_detect(names(x), name)
}

has_name <- function(x, name) {
  UseMethod("has_name", object = name)
}

has_name.default <- function(x, name) {
  name %in% names(x)
}

has_name.regex <- function(x, name) {
  any(detect_name(x, name))
}

has_metachr <- function(x) {
  string_detect(x, r"{[\\\[\](){}|?$^*+]}")
}

has_homonyms <- function(x) {
  vec_duplicate_any(names(x))
}

is_empty <- function(x) {
  UseMethod("is_empty")
}

is_empty.default <- function(x) {
  length(x) == 0L
}

is_empty.tbl_df <- function(x) {
  nrow(x) == 0L
}

is_empty.character <- function(x) {
  if (length(x) > 1L) {
    return(FALSE)
  }
  length(x) == 0L || x == ""
}

is_void <- function(x) {
  is.na(x) | is_blank(x)
}

is_nested <- function(x, item) {
  typeof(x[[item]]) == "list"
}

are_dots_all <- function(...) {
  dots_n(...) == 1L && is_string(expr(...)) && ... == "all"
}

search <- function(x, callback, na_rm = TRUE, n = 1) {
  if (na_rm) {
    x <- drop_na(x)
  }
  have_passed <- !callback(x)
  if (all(have_passed)) {
    return()
  }
  failed <- which(!have_passed)
  if (!is.null(n)) {
    failed <- failed[n]
  }
  set_names(x[failed], failed)
}

is_type <- function(x, type) {
  do.call(paste0("is.", type), list(x))
}

expr_to_string <- function(x, env = caller_env()) {
  as.character(substitute(x, env = env))[-1]
}

caller_user <- function() {
  caller_env(sys.parent())
}

message_body <- function(i) {
  switch(
    i,
    `1` = "must be",
    `2` = "must have",
    `3` = "must only contain",
    abort("index out of bounds.")
  )
}

message_error <- function(arg, body, what) {
  sprintf("`%s` %s %s.", arg, body, what)
}

abort_check <- function(
    what,
    msg = NULL,
    bullets = NULL,
    ...,
    msg_body = 1,
    arg,
    call = caller_user()
) {
  msg_body <- message_body(msg_body)
  msg <- msg %||% message_error(arg, msg_body, what)
  if (!is.null(bullets)) {
    msg <- c(msg, bullets)
  }
  abort(msg, ..., call = call)
}

check_named <- function(x, allow_homonyms = FALSE, ..., arg = caller_arg(x)) {
  if (is_named(x) && (allow_homonyms || !has_homonyms(x))) {
    return(invisible(NULL))
  }
  if (is_named(x) && !allow_homonyms && has_homonyms(x)) {
    msg <- "`{arg}` must have unique input names."
  } else {
    msg <- "All `{arg}` inputs must be named."
  }
  abort_check(msg = glue(msg), ..., arg = arg)
}

check_duplicates <- function(x, ..., arg = caller_arg(x)) {
  if (!vec_duplicate_any(x)) {
    return(invisible(NULL))
  }
  msg <- glue("`{arg}` must have unique input values.")
  abort_check(msg = msg, ..., arg = arg)
}

vector_types <- c(
  "character", "double", "integer",
  "logical", "complex", "raw", "list"
)

check_vector <- function(
    x,
    type = vector_types,
    force_names = FALSE,
    allow_duplicates = TRUE,
    allow_homonyms = FALSE,
    allow_null = TRUE,
    ...,
    arg = caller_arg(x)
) {
  type <- match.arg(type)
  if (!missing(x)) {
    if (allow_null && is.null(x)) {
      return(invisible(NULL))
    }
    if (is_type(x, type)) {
      if (force_names) {
        check_named(x, allow_homonyms = allow_homonyms, arg = arg)
      }
      if (!allow_duplicates) {
        check_duplicates(x, arg = arg)
      }
      return(invisible(NULL))
    }
  }
  if (type != "list") {
    type <- paste(type, "vector")
  }
  abort_check(paste("a", type), ..., arg = arg)
}

check_list <- partial(check_vector, type = "list")

check_character <- partial(check_vector, type = "character")

check_df <- function(x, ..., arg = caller_arg(x)) {
  if (!missing(x) && inherits(x, c("data.frame", "tbl_df"))) {
    return(invisible(NULL))
  }
  abort_check("a data frame or tibble", ..., arg = arg)
}

check_string <- function(
    x,
    allow_empty = TRUE,
    allow_null = FALSE,
    ...,
    arg = caller_arg(x)
) {
  adj <- "character"
  if (!missing(x)) {
    if (is_stringish(x, allow_empty, allow_null)) {
      return(invisible(NULL))
    }
    if (is_string(x)) {
      adj <- "non-empty"
    }
  }
  abort_check(paste("a", adj, "string"), ..., arg = arg)
}

is_stringish <- function(x, allow_empty, allow_null) {
  if (is_string(x) && (allow_empty || !is_string(x, ""))) {
    return(TRUE)
  }
  if (allow_null && is.null(x)) {
    return(TRUE)
  }
  FALSE
}

check_bool <- function(x, allow_null = FALSE, ..., arg = caller_arg(x)) {
  if (!missing(x) && (is_bool(x) || allow_null && is.null(x))) {
    return(invisible(NULL))
  }
  abort_check("`TRUE` or `FALSE`", ..., arg = arg)
}

check_args <- function(type, x, ...) {
  # ensure that x is a list to preserve element types
  check_list(x)
  fn <- paste0("check_", type)
  dots <- dots_list(...)
  walk2(x, expr_to_string(x), \(item, arg) {
    do.call(fn, c(list(item, arg = arg, call = caller_user()), dots))
  })
}

check_suffix_format <- function(x, allowed, arg = caller_arg(x)) {
  check_string(x, allow_null = TRUE, arg = arg)
  if (is.null(x)) {
    return(invisible(NULL))
  }
  pattern <- to_chr_class(allowed, negate = TRUE)
  keys <- als_extract_keys(x)
  has_dup_keys <- vec_duplicate_any(keys)
  if (!(has_dup_keys || grepl(pattern, x))) {
    return(invisible(NULL))
  }
  if (has_dup_keys) {
    what <- "unique keys"
    msg_body <- 2
  } else {
    allowed <- wrap(allowed, "`")
    what <- paste("any of", enumerate(allowed, last = " or "))
    msg_body <- 3
  }
  abort_check(what, msg_body = msg_body, arg = arg)
}

file_ext <- function(x) {
  string_extract(x, "(?<=\\.)[^.]+$")
}

check_file <- function(
    x,
    extension,
    allow_sans_ext = FALSE,
    allow_null = FALSE,
    ...,
    arg = caller_arg(x)
) {
  check_string(x, allow_empty = FALSE, allow_null, arg = arg)
  if (allow_sans_ext || allow_null && is.null(x)) {
    return(invisible(NULL))
  }
  ext <- file_ext(x)
  if (is_not_na(ext) && includes(ext, extension)) {
    return(invisible(NULL))
  }
  extension <- wrap(predot(extension), "`")
  if (length(extension) > 1L) {
    extension <- enumerate(extension, last = " or ")
  }
  abort_check(paste("a", extension, "file"), ..., arg = arg)
}

is_glueish <- function(x) {
  is_string(x) && string_detect(x, "{[^}]+}")
}

check_glue <- function(x, allowed, ..., arg = caller_arg(x)) {
  msg <- NULL
  if (!missing(x) && is_glueish(x)) {
    if (missing(allowed)) {
      return(invisible(NULL))
    }
    exprs <- extract_glue_exprs(x)
    if (all(includes(exprs, allowed, ignore_case = FALSE))) {
      return(invisible(NULL))
    }
    invalid_expr <- search(exprs, \(expr) !expr %in% allowed)
    allowed_exprs <- wrap(allowed, "`")
    msg <- c(
      glue("Invalid variable `{invalid_expr}`."),
      i = glue("`format` must use variables {enumerate(allowed_exprs)}.")
    )
  }
  abort_check("a glue specification", msg = msg, ..., arg = arg)
}

is_orcid <- function(x) {
  string_detect(x, "^(?:\\d{4}-){3}\\d{3}(?:\\d|X)$")
}

check_orcid <- function(x, ..., arg = caller_arg(x)) {
  invalid_orcid <- search(x, Negate(is_orcid))
  if (is.null(invalid_orcid)) {
    return(invisible(NULL))
  }
  msg <- glue("Invalid ORCID identifier found: `{invalid_orcid}`.")
  abort_check(msg = msg, bullets = c(
    i = "ORCID identifiers must have 16 digits, separated by a hyphen every 4 digits.",
    i = "The last character of the identifier must be a digit or `X`."
  ), ..., arg = arg)
}
