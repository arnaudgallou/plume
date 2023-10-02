#' @title Create a table template for plume classes
#' @description This helper function allows you to generate an empty
#'   [`tibble`][tibble::tibble()] that you can use as a template to supply
#'   author data.
#' @param minimal If `TRUE`, returns an empty tibble with the following columns:
#'   `given_name`, `family_name`, `email`, `orcid`, `affiliation`, `role` and
#'   `note`. Otherwise the function returns a template with all columns that can
#'   be supplied to plume classes that are not `PlumeQuarto`-specific.
#' @param credit_roles Should the `r link("crt")` be used?
#' @returns An empty tibble.
#' @examples
#' plm_template()
#' @export
plm_template <- function(minimal = TRUE, credit_roles = FALSE) {
  check_args("bool", list(minimal, credit_roles))
  vars <- get_template_vars(minimal, credit_roles)
  tibble(!!!vars, .rows = 0)
}

get_template_vars <- function(minimal, credit_roles) {
  vars <- list_fetch_all(.names, "public", "orcid", squash = FALSE)
  vars <- list_assign(vars, nestables = get_nestables(credit_roles))
  to_ignore <- get_ignored_vars(vars, minimal)
  vars <- unlist(vars, use.names = FALSE)
  vars <- drop_from(vars, to_ignore)
  set_names(vars)
}

get_ignored_vars <- function(vars, minimal) {
  to_ignore <- vars$internals
  if (!minimal) {
    return(to_ignore)
  }
  c(to_ignore, drop_from(vars$secondaries, "email"))
}

get_nestables <- function(crt) {
  names_crt <- if (crt) names(.names$protected$crt)
  role <- if (!crt) "role"
  vars <- c(seq_names("affiliation", role, n = 2), names_crt, "note")
  as.list(set_names(vars))
}

seq_names <- function(..., n) {
  paste(rep(c(...), each = n), seq(n), sep = "_")
}
