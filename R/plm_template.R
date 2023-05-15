#' @title Create a table template for plume classes
#' @description This helper function allows you to generate an empty
#'   [`tibble`][tibble::tibble()] that you can use as a template to supply author
#'   data.
#' @param minimal If `TRUE`, returns an empty tibble with the following columns:
#'   `given_name`, `family_name`, `email`, `orcid`, `affiliation`, `contribution`
#'   and `note`. Otherwise the function returns a template with all columns that
#'   can be supplied to plume classes.
#' @return An empty tibble.
#' @export
plm_template <- function(minimal = TRUE) {
  check_bool(minimal)
  nestables <- c(seq_names("affiliation", "contribution", n = 2), "note")
  vars <- list_assign(
    default_names,
    nestable = set_names(dots_list(!!!nestables), nestables)
  )
  to_ignore <- vars$internal
  if (minimal) {
    to_ignore <- c(to_ignore, "number", "fax", "url", "dropping_particle")
  }
  vars <- flatten(vars)
  vars <- vars[!vars %in% to_ignore]
  tibble(!!!vars, .rows = 0)
}

seq_names <- function(..., n) {
  paste(rep(c(...), each = n), seq(n), sep = "_")
}
