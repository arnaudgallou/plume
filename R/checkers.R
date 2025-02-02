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

is_selector <- function(expr) {
  nms <- c("everyone", "everyone_but")
  is_call(expr, nms, ns = c("plume", ""))
}

are_credit_roles <- function(x) {
  all(x %in% credit_roles()) || all(x %in% credit_roles(FALSE))
}

seek <- function(x, callback) {
  x <- vec_drop_na(x)
  have_passed <- if (missing(callback)) !x else !callback(x)
  if (all(have_passed)) {
    return()
  }
  failed <- which(!have_passed)[[1]]
  out <- x[failed]
  if (!is_named(x)) {
    out <- set_names(out, failed)
  }
  out
}

without_indexed_error <- function(expr, ...) {
  withCallingHandlers(expr, purrr_error_indexed = \(e) {
    rlang::cnd_signal(e$parent)
  }, ...)
}

caller_user <- function() {
  caller_env(sys.parent())
}

abort <- function(msg, call = caller_user(), env = caller_env()) {
  if (length(msg) == 1L) {
    msg <- glue(msg, .null = "", .envir = env)
  }
  rlang::abort(msg, call = call)
}

check_dots_not_empty <- function() {
  dots <- substitute(...(), caller_env())
  if (!is.null(dots)) {
    return(invisible())
  }
  abort("`...` must not be empty.")
}

check_named <- function(x, arg = caller_arg(x), ...) {
  if (is_named(x) && !has_homonyms(x)) {
    return(invisible())
  }
  check_unique_names(x, arg, ...)
  abort("All `{arg}` inputs must be named.", ...)
}

check_unique_names <- function(x, arg, ...) {
  if (has_homonyms(x)) {
    abort("`{arg}` must have unique input names.", ...)
  }
}

check_unique_values <- function(x, what = "input values", arg, ...) {
  if (vec_duplicate_any(x)) {
    abort("`{arg}` must have unique {what}.", ...)
  }
}

check_type <- function(x, asserter, expected, arg, ...) {
  if (!asserter(x)) {
    abort("`{arg}` must be {expected}.", ...)
  }
}

is_type <- function(x, type) {
  do.call(paste0("is.", type), list(x))
}

check_vec <- function(x, type, expected, let, arg, ...) {
  if (let$null && is.null(x)) {
    return(invisible())
  }
  check_type(x, \(x) is_type(x, type), expected, arg, ...)
  if (!let$unnamed) {
    check_named(x, arg = arg)
  }
  if (!let$duplicates) {
    check_unique_values(x, arg = arg)
  }
}

.allowed_default <- list(
  null = FALSE,
  empty = FALSE,
  duplicates = FALSE,
  unnamed = FALSE
)

allow <- function(...) {
  nms <- c(...)
  if (is_empty(nms)) {
    return(.allowed_default)
  }
  allowed <- recycle_to_names(TRUE, nms)
  list_replace(.allowed_default, allowed)
}

check_list <- function(x, let = allow(), arg = caller_arg(x), ...) {
  check_vec(x, "list", "a list", let, arg, ...)
}

check_character <- function(x, let = allow(), arg = caller_arg(x), ...) {
  check_vec(x, "character", "a character vector", let, arg, ...)
}

check_num <- function(x, let = allow("unnamed"), arg = caller_arg(x), ...) {
  check_vec(x, "numeric", "a numeric vector", let, arg, ...)
}

is_df <- function(x) {
  inherits(x, c("data.frame", "tbl_df"))
}

check_df <- function(x, arg = caller_arg(x), ...) {
  check_type(x, is_df, "a data frame or tibble", arg, ...)
}

check_bool <- function(x, arg = caller_arg(x), ...) {
  check_type(x, is_bool, "`TRUE` or `FALSE`", arg, ...)
}

is_stringish <- function(x, allow_empty) {
  if (is_string(x) && (allow_empty || !is_string(x, ""))) {
    return(TRUE)
  }
  FALSE
}

check_string <- function(x, let = allow(), arg = caller_arg(x), ...) {
  asserter <- \(x) is_stringish(x, let$empty) || let$null && is.null(x)
  type <- if (is_string(x)) "non-empty" else "character"
  check_type(x, asserter, glue("a {type} string"), arg, ...)
}

check_args <- function(type, quosures, ..., call = caller_user()) {
  fn <- paste0("check_", type)
  without_indexed_error(
    iwalk(quosures, \(value, key) {
      do.call(fn, list(rlang::eval_tidy(value), arg = key, call = call, ...))
    })
  )
}

check_suffix_format <- function(x, arg = caller_arg(x), ...) {
  check_string(x, allow("null", "empty"), arg, ...)
  if (is.null(x)) {
    return(invisible())
  }
  check_unique_values(als_extract_keys(x), what = "keys", arg, ...)
  check_set(split_chars(x), allowed = split_chars("acno^,"), arg, ...)
}

format_valid <- function(x, last = " or ") {
  enumerate(wrap(x, "`"), last = last)
}

check_set <- function(x, allowed, arg, ...) {
  if (any(!x %in% allowed)) {
    abort("`{arg}` must only contain any of {format_valid(allowed)}.", ...)
  }
}

path_is_relative <- function(x) {
  !str_detect(x, "^(/|[A-Za-z]:|\\\\|~)")
}

check_path <- function(x, ...) {
  if (file.exists(x)) {
    return(invisible())
  }
  where <- if (path_is_relative(x)) " in the current directory"
  abort("`{x}` doesn't exist{where}.", ...)
}

file_ext <- function(x) {
  str_extract(x, "(?<=\\.)[^.]+$")
}

check_file <- function(x, extensions, arg = caller_arg(x)) {
  check_string(x, arg = arg)
  asserter <- function(x) vec_in(x, extensions)
  valid_ext <- format_valid(predot(extensions))
  check_type(file_ext(x), asserter, glue("a {valid_ext} file"), arg)
  check_path(x)
}

is_glueish <- function(x) {
  is_string(x) && str_detect(x, "\\{[^}]+\\}")
}

check_glue <- function(x, allowed, arg = caller_arg(x), ...) {
  check_type(x, is_glueish, "a glue specification", arg, ...)
  check_glue_vars(x, allowed, ...)
}

check_glue_vars <- function(x, allowed, ...) {
  vars <- extract_glue_vars(x)
  if (all(vec_in(vars, allowed, ignore_case = FALSE))) {
    return(invisible())
  }
  invalid_var <- seek(vars, \(var) !var %in% allowed)
  allowed_vars <- format_valid(allowed, last = " and/or ")
  abort(c(
    glue("Invalid variable `{invalid_var}`."),
    i = glue("`format` must use variables {allowed_vars}.")
  ), ...)
}

is_orcid <- function(x) {
  str_detect(x, "^(?:\\d{4}-){3}\\d{3}(?:\\d|X)$")
}

check_orcid <- function(x, ...) {
  invalid_orcid <- seek(x, Negate(is_orcid))
  if (is.null(invalid_orcid)) {
    return(invisible())
  }
  abort(c(
    glue("Invalid ORCID identifier found: `{invalid_orcid}`."),
    i = paste("ORCID identifiers must have 16 digits,",
              "separated by a hyphen every 4 digits."),
    i = "The last character of the identifiers must be a digit or `X`."
  ), ...)
}

is_icon <- function(x) {
  inherits(x, "plm_icon")
}

check_orcid_icon <- function(x, arg = caller_arg(x), ...) {
  if (is_icon(x)) {
    return(invisible())
  }
  abort(c(
    glue("Invalid `{arg}` input."),
    i = "Use `orcid()` to set the ORCID icon."
  ), ...)
}
