has_uppercase <- function(x) {
  str_detect(x, "\\p{Lu}")
}

detect_name <- function(x, name) {
  str_detect(names(x), name)
}

has_name <- function(x, name) {
  UseMethod("has_name", object = name)
}

has_name.default <- function(x, name) {
  name %in% names(x)
}

has_name.stringr_regex <- function(x, name) {
  any(detect_name(x, name))
}

has_metachr <- function(x) {
  str_detect(x, r"{[\\\[\](){}|?$^*+]}")
}

has_homonyms <- function(x) {
  vec_duplicate_any(names(x))
}

any_is_named <- function(x) {
  any(rlang::have_name(x))
}

has_overflowing_ws <- function(x) {
  str_detect(x, "^\\s|\\s$")
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
  length(x) == 0L || all(x == "")
}

is_void <- function(x) {
  is.na(x) | is_blank(x)
}

is_nested <- function(x, item) {
  is.list(x[[item]])
}

is_blank <- function(x) {
  str_detect(x, "^\\s*$")
}

is_not_na <- Negate(is.na)

are_credit_roles <- function(x) {
  all(x %in% credit_roles()) || all(x %in% credit_roles(FALSE))
}

are_calls <- function(...) {
  all(map_vec(enexprs(...), is.call))
}

search_ <- function(x, callback, n = 1) {
  x <- vec_drop_na(x)
  have_passed <- if (missing(callback)) !x else !callback(x)
  if (all(have_passed)) {
    return()
  }
  failed <- which(!have_passed)
  if (!is.null(n)) {
    failed <- failed[n]
  }
  nms <- if (is_named(failed)) names(failed) else failed
  set_names(x[failed], nms)
}

without_indexed_error <- function(expr, ...) {
  withCallingHandlers(expr, purrr_error_indexed = \(e) {
    rlang::cnd_signal(e$parent)
  }, ...)
}

is_type <- function(x, type) {
  do.call(paste0("is.", type), list(x))
}

caller_user <- function() {
  caller_env(sys.parent())
}

message_body <- function(i) {
  switch(
    i,
    `1` = "must be",
    `2` = "must have",
    `3` = "must only contain"
  )
}

message_error <- function(param, body, what) {
  sprintf("`%s` %s %s.", param, body, what)
}

abort_check <- function(
    what,
    msg = NULL,
    bullets = NULL,
    ...,
    msg_body = 1,
    param,
    call = caller_user()
) {
  msg_body <- message_body(msg_body)
  msg <- msg %||% message_error(param, msg_body, what)
  if (!is.null(bullets)) {
    msg <- c(msg, bullets)
  }
  abort(msg, ..., call = call)
}

check_dots_not_empty <- function() {
  dots <- substitute(...(), caller_env())
  if (!is.null(dots)) {
    return(invisible(NULL))
  }
  abort_check(msg = "`...` must not be empty.")
}

check_named <- function(x, allow_homonyms = FALSE, ..., param = caller_arg(x)) {
  if (is_named(x) && (allow_homonyms || !has_homonyms(x))) {
    return(invisible(NULL))
  }
  if (is_named(x) && !allow_homonyms && has_homonyms(x)) {
    msg <- "`{param}` must have unique input names."
  } else {
    msg <- "All `{param}` inputs must be named."
  }
  abort_check(msg = glue(msg), ..., param = param)
}

check_duplicates <- function(x, ..., param = caller_arg(x)) {
  if (!vec_duplicate_any(x)) {
    return(invisible(NULL))
  }
  msg <- glue("`{param}` must have unique input values.")
  abort_check(msg = msg, ..., param = param)
}

check_vector <- function(
    x,
    type,
    force_names = FALSE,
    allow_duplicates = TRUE,
    allow_homonyms = FALSE,
    allow_null = TRUE,
    ...,
    param = caller_arg(x)
) {
  if (!missing(x)) {
    if (allow_null && is.null(x)) {
      return(invisible(NULL))
    }
    if (is_type(x, type)) {
      if (force_names) {
        check_named(x, allow_homonyms = allow_homonyms, param = param)
      }
      if (!allow_duplicates) {
        check_duplicates(x, param = param)
      }
      return(invisible(NULL))
    }
  }
  if (type != "list") {
    type <- paste(type, "vector")
  }
  abort_check(paste("a", type), ..., param = param)
}

check_list <- partial(check_vector, type = "list")

check_character <- partial(check_vector, type = "character")

check_num <- partial(check_vector, type = "numeric")

check_df <- function(x, ..., param = caller_arg(x)) {
  if (!missing(x) && inherits(x, c("data.frame", "tbl_df"))) {
    return(invisible(NULL))
  }
  abort_check("a data frame or tibble", ..., param = param)
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

check_string <- function(
    x,
    allow_empty = TRUE,
    allow_null = FALSE,
    ...,
    param = caller_arg(x)
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
  abort_check(paste("a", adj, "string"), ..., param = param)
}

check_bool <- function(x, allow_null = FALSE, ..., param = caller_arg(x)) {
  if (!missing(x) && (is_bool(x) || allow_null && is.null(x))) {
    return(invisible(NULL))
  }
  abort_check("`TRUE` or `FALSE`", ..., param = param)
}

expr_to_chr <- function(x, env = caller_env()) {
  as.character(substitute(x, env = env))[-1]
}

check_args <- function(type, x, ..., call = caller_user()) {
  # ensure that x is a list to preserve element types
  check_list(x)
  f <- paste0("check_", type)
  dots <- list(...)
  without_indexed_error(
    iwalk(set_names(x, expr_to_chr(x)), \(arg, param) {
      do.call(f, c(list(arg, param = param, call = call), dots))
    })
  )
}

check_suffix_format <- function(x, param = caller_arg(x)) {
  check_string(x, allow_null = TRUE, param = param)
  if (is.null(x)) {
    return(invisible(NULL))
  }
  allowed <- c("a", "c", "n", "o", "^", ",")
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
  abort_check(what, msg_body = msg_body, param = param)
}

path_is_relative <- function(x) {
  !str_detect(x, "^(/|[A-Za-z]:|\\\\|~)")
}

check_path <- function(x, ..., param = caller_arg(x)) {
  if (file.exists(x)) {
    return(invisible(NULL))
  }
  if (path_is_relative(x)) {
    directory <- glue(" in the current directory `{getwd()}`")
  } else {
    directory <- ""
  }
  abort_check(msg = glue("`{x}` doesn't exist{directory}."))
}

file_ext <- function(x) {
  str_extract(x, "(?<=\\.)[^.]+$")
}

check_file <- function(x, extension, ..., param = caller_arg(x)) {
  check_string(x, allow_empty = FALSE, param = param)
  ext <- file_ext(x)
  if (is_not_na(ext) && vec_in(ext, extension)) {
    check_path(x, param = param)
    return(invisible(NULL))
  }
  extension <- wrap(predot(extension), "`")
  abort_check(paste("a", extension, "file"), ..., param = param)
}

is_glueish <- function(x) {
  is_string(x) && str_detect(x, "\\{[^}]+\\}")
}

check_glue <- function(x, allowed, ..., param = caller_arg(x)) {
  msg <- NULL
  if (!missing(x) && is_glueish(x)) {
    vars <- extract_glue_vars(x)
    if (all(vec_in(vars, allowed, ignore_case = FALSE))) {
      return(invisible(NULL))
    }
    invalid_var <- search_(vars, \(var) !var %in% allowed)
    allowed_vars <- enumerate(wrap(allowed, "`"), last = " and/or ")
    msg <- c(
      glue("Invalid variable `{invalid_var}`."),
      i = glue("`format` must use variables {allowed_vars}.")
    )
  }
  abort_check("a glue specification", msg = msg, ..., param = param)
}

is_orcid <- function(x) {
  str_detect(x, "^(?:\\d{4}-){3}\\d{3}(?:\\d|X)$")
}

check_orcid <- function(x, ..., param = caller_arg(x)) {
  invalid_orcid <- search_(x, Negate(is_orcid))
  if (is.null(invalid_orcid)) {
    return(invisible(NULL))
  }
  msg <- glue("Invalid ORCID identifier found: `{invalid_orcid}`.")
  abort_check(msg = msg, bullets = c(
    i = "ORCID identifiers must have 16 digits, separated by a hyphen every 4 digits.",
    i = "The last character of the identifiers must be a digit or `X`."
  ), ..., param = param)
}

is_icon <- function(x) {
  inherits(x, "plm_icon")
}

check_orcid_icon <- function(x, ..., param = caller_arg(x)) {
  if (!missing(x) && is_icon(x)) {
    return(invisible(NULL))
  }
  abort_check(..., msg = c(
    glue("Invalid `{param}` input."),
    i = "Use `orcid()` to set the ORCID icon."
  ))
}
