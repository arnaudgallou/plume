#' @title CRediT roles
#' @description Helper function returning the 14 contributor roles of the
#'   `r link("crt")` (CRediT). This function is the default argument of the
#'   `roles` and `role_cols` parameters in plume classes and [`plm_template()`],
#'   respectively.
#' @param oxford_spelling Should the suffix -ize/-ization be used?
#' @returns A named vector.
#' @examples
#' credit_roles()
#' @export
credit_roles <- function(oxford_spelling = TRUE) {
  check_bool(oxford_spelling)
  out <- unlist(list_fetch(.names, "crt"))
  if (oxford_spelling) {
    return(out)
  }
  full_rename(out, "ization", "isation")
}

full_rename <- function(x, pattern, replacement) {
  names(x) <- str_replace(names(x), pattern, replacement)
  x[] <- str_replace(x, pattern, replacement)
  x
}
