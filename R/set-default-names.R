#' @title Set new default names to a plume subclass
#' @description This helper function allows you to set new default names to a plume
#'   subclass, e.g. to set default names to a language other than English. See
#'   `vignette("working-in-other-languages")` for more details.
#' @param ... Key-value pairs where keys are old names and values their respective
#'   replacements.
#' @param .plume_quarto Are you setting new names for [`PlumeQuarto`]?
#' @details
#' Available names are:
#'
#' `r wrap(unlist(map(default_names, names)), "\x60")`.
#'
#' Using `.plume_quarto = TRUE` adds `deceased`, `equal_contributor`, `number`,
#' `dropping_particle` and `acknowledgements`.
#' @return A named list.
#' @export
set_default_names <- function(..., .plume_quarto = FALSE) {
  dots <- c(...)
  check_character(
    dots,
    force_names = TRUE,
    allow_duplicates = FALSE,
    msg = "`...` inputs must be character vectors.",
    arg = "..."
  )
  check_bool(.plume_quarto)
  nms <- if (.plume_quarto) default_names_quarto else default_names
  list_replace(nms, dots)
}
