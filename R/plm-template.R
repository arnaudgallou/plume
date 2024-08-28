#' @title Create a table template for plume classes
#' @description This helper function allows you to generate an empty
#'   [`tibble`][tibble::tibble()] that you can use as a template to supply
#'   author data.
#' @param minimal If `TRUE`, returns an empty tibble with the following columns:
#'   `given_name`, `family_name`, `email`, `orcid`, `affiliation` and `note`.
#'   Otherwise the function returns a template with all columns that can be
#'   supplied to plume classes that are not `PlumeQuarto`-specific.
#' @param role_cols A vector of names defining role columns to create. If the
#'   vector contains key-value pairs, columns will be named after the keys.
#' @param credit_roles `r lifecycle::badge("deprecated")`
#'
#'   It is now recommended to use `role_cols = credit_roles()` to use the
#'   `r link("crt")`.
#' @returns An empty tibble.
#' @examples
#' plm_template()
#'
#' plm_template(role_cols = paste0("role_", 1:5))
#' @export
plm_template <- function(minimal = TRUE, role_cols = credit_roles(), credit_roles = FALSE) {
  check_args("bool", list(minimal, credit_roles))
  check_character(role_cols, allow_duplicates = FALSE)
  if (credit_roles) {
    print_deprecation("credit_roles", "plm_template", param = "role_cols")
    role_cols <- credit_roles()
  }
  vars <- get_template_vars(minimal, role_cols)
  tibble(!!!vars, .rows = 0L)
}

get_template_vars <- function(minimal, role_cols) {
  vars <- list_fetch_all(.names, "primaries", "orcid", squash = FALSE)
  vars <- c(vars, get_secondaries(minimal), get_nestables())
  vars <- recycle_to_names(NA_character_, vars)
  if (!is.null(role_cols)) {
    role_cols <- recycle_to_names(NA_real_, role_cols)
  }
  c(vars, role_cols)
}

get_secondaries <- function(minimal) {
  if (minimal) {
    return(list(email = "email"))
  }
  list_fetch(.names, "secondaries")
}

get_nestables <- function() {
  vars <- c(seq_names("affiliation", n = 2L), "note")
  as.list(set_names(vars))
}

seq_names <- function(..., n) {
  paste(rep(c(...), each = n), seq_len(n), sep = "_")
}
