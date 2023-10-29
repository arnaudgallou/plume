#' @title CRediT roles
#' @description Helper function returning the 14 contributor roles of the
#'   `r link("crt")` (CRediT). This function is the default argument of the
#'   `roles` parameter in plume classes and [`plm_template()`].
#' @returns A named vector.
#' @examples
#' credit_roles()
#' @export
credit_roles <- function() {
  unlist(list_fetch(.names, "crt"))
}
