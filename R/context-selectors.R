#' @title Select all authors or exclude some from a selection
#' @description Selection helpers to use in conjonction with status setter
#'   methods (i.e. methods that assign a status to authors with either `TRUE`
#'   or `FALSE`):
#'   * [`everyone()`] select all authors.
#'   * [`everyone_but()`] `r lifecycle::badge("deprecated")` this function was
#'   deprecated as I believe it is not necessary since not more than a couple of
#'   authors should normally be given a particular status.
#' @examples
#' aut <- Plume$new(encyclopedists)
#'
#' aut$set_corresponding_authors(everyone())
#' aut$get_plume() |> dplyr::select(1:3, corresponding)
#' @export
everyone <- function() {
  binder$pull()
}

#' @rdname everyone
#' @keywords internal
#' @param ... One or more unquoted expressions separated by commas. Expressions
#'   matching values in the column defined by the `by`/`.by` parameters of
#'   `set_*()` methods are used to set a given status to authors. Matching of
#'   values is case-insensitive.
#' @export
everyone_but <- function(...) {
  lifecycle::deprecate_warn("0.2.0", "everyone_but()")
  out <- binder$pull()
  discard(out, enexprs(...))
}
