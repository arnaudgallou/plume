#' @title Set new default names to a plume subclass
#' @description This helper function allows you to set new default names to a
#'   plume subclass, e.g. to set default names to a language other than English.
#' @param ... Key-value pairs where keys are default names and values their
#'   respective replacements.
#' @param .plume_quarto Are you setting new names for [`PlumeQuarto`]?
#' @details
#' Available names are:
#'
#' `r wrap(squash(.names_plume), "\x60")`.
#'
#' Using `.plume_quarto = TRUE` adds `deceased`, `equal_contributor`, `number`,
#' `dropping_particle` and `acknowledgements`.
#' @returns A named list.
#' @examples
#' # Extending `Plume` with default names in French
#' PlumeFr <- R6::R6Class(
#'   classname = "PlumeFr",
#'   inherit = Plume,
#'   private = list(
#'     names = set_default_names(
#'       initials = "initiales",
#'       literal_name = "nom_complet",
#'       corresponding = "correspondant",
#'       given_name = "prénom",
#'       family_name = "nom",
#'       email = "courriel",
#'       phone = "téléphone"
#'     )
#'   )
#' )
#'
#' PlumeFr$new(encyclopedists_fr)
#' @export
set_default_names <- function(..., .plume_quarto = FALSE) {
  check_dots_not_empty()
  dots <- c(...)
  check_character(dots, arg = "...")
  check_bool(.plume_quarto)
  nms <- if (.plume_quarto) .names_quarto else .names_plume
  list_replace(nms, dots)
}
