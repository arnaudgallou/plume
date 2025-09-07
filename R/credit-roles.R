#' @title CRediT roles
#' @description
#' Helper function returning the 14 contributor roles of the `r link("crt")`
#' (CRediT). This function is the default argument of the `roles` and
#' `role_cols` parameters in plume classes and [`plm_template()`], respectively.
#' @param oxford_spelling Should the suffix -ize/-ization be used?
#' @returns A named vector.
#' @examples
#' credit_roles()
#' @export
credit_roles <- function(oxford_spelling = TRUE) {
  check_bool(oxford_spelling)
  if (oxford_spelling) {
    return(.credit_roles)
  }
  ise(.credit_roles)
}

ise <- function(x) {
  pattern <- "(?<=i)z(?=ation)"
  names(x) <- str_replace(names(x), pattern, "s")
  x[] <- str_replace(x, pattern, "s")
  x
}

.credit_roles <- c(
  conceptualization = "Conceptualization",
  data_curation = "Data curation",
  analysis = "Formal analysis",
  funding = "Funding acquisition",
  investigation = "Investigation",
  methodology = "Methodology",
  administration = "Project administration",
  resources = "Resources",
  software = "Software",
  supervision = "Supervision",
  validation = "Validation",
  visualization = "Visualization",
  writing = "Writing - original draft",
  editing = "Writing - review & editing"
)
