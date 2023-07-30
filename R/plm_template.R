#' @title Create a table template for plume classes
#' @description This helper function allows you to generate an empty
#'   [`tibble`][tibble::tibble()] that you can use as a template to supply author
#'   data.
#' @param minimal If `TRUE`, returns an empty tibble with the following columns:
#'   `given_name`, `family_name`, `email`, `orcid`, `affiliation`, `role` and
#'   `note`. Otherwise the function returns a template with all columns that can
#'   be supplied to plume classes.
#' @param credit_roles Should `r link("crt")` be used?
#' @return An empty tibble.
#' @export
plm_template <- function(minimal = TRUE, credit_roles = FALSE) {
  check_args("bool", list(minimal, credit_roles))
  vars <- list_assign(default_names, nestable = get_nestables(credit_roles))
  to_ignore <- vars$internal
  if (minimal) {
    to_ignore <- c(to_ignore, "phone", "fax", "url", "dropping_particle", "number")
  }
  vars <- flatten(vars)
  vars <- vars[!vars %in% to_ignore]
  tibble(!!!vars, .rows = 0)
}

get_nestables <- function(crt) {
  names_crt <- if (crt) names(.names$protected$crt)
  role <- if (!crt) "role"
  vars <- c(seq_names("affiliation", role, n = 2), names_crt, "note")
  set_names(as.list(vars), vars)
}

seq_names <- function(..., n) {
  paste(rep(c(...), each = n), seq(n), sep = "_")
}
