#' @title Enumerate vector elements
#' @description Wrapper around [`glue_collapse()`][glue::glue_collapse()] using
#'   `sep = ", "` and `last = " and "` as default arguments.
#' @param x A character vector.
#' @param sep Separator used to separate the terms.
#' @param last Separator used to separate the last two items if `x` has at least
#'   2 items.
#' @export
enumerate <- function(x, sep = ", ", last = " and ") {
  glue_collapse(x, sep = sep, last = last)
}
