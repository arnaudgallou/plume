#' @title Select all authors or exclude some from a selection
#' @description Selection helpers to use in conjonction with `set_*()` methods:
#'   * [`everyone()`] select all authors.
#'   * [`everyone_but()`] select all but specific authors.
#' @examples
#' aut <- Plume$new(encyclopedists)
#'
#' aut$set_corresponding_authors(everyone())
#' aut$get_plume() |> dplyr::select(1:3, corresponding)
#'
#' aut$set_corresponding_authors(
#'   everyone_but(jean),
#'   .by = "given_name"
#' )
#' aut$get_plume() |> dplyr::select(1:3, corresponding)
#' @export
everyone <- function() {
  binder$pull()
}

#' @rdname everyone
#' @param ... One or more unquoted expressions separated by commas. Expressions
#'   matching values in the column defined by the `by` parameter of `set_*()`
#'   methods are used to set a given status to authors. Matching of values is
#'   case-insensitive.
#' @export
everyone_but <- function(...) {
  out <- binder$pull()
  discard(out, enexprs(...))
}
