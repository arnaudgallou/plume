#' @title Set new default names to a plume subclass
#' @description This helper function allows you to set new default names to a plume
#'   subclass, e.g. to set default names to a language other than English. See
#'   `vignette("working-in-other-languages")` for more details.
#' @param ... Key-value pairs where keys are old names and values their respective
#'   replacements.
#' @details
#' Available names are:
#'
#' `r wrap(unlist(map(default_names, names)), "\x60")`
#' @return A named list.
#' @export
set_default_names <- function(...) {
  dots <- c(...)
  check_character(
    dots,
    force_names = TRUE,
    allow_duplicates = FALSE,
    msg = "`...` inputs must be character vectors.",
    arg = "..."
  )
  nms <- default_names
  for (i in seq_along(nms)) {
    nms[[i]] <- supplant(nms[[i]], dots)
  }
  nms
}
