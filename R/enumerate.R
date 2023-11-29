#' @title Enumerate vector elements
#' @description Wrapper around [`glue_collapse()`][glue::glue_collapse()] using
#'   `sep = ", "` and `last = " and "` as default arguments.
#' @param x A character vector.
#' @param sep Separator used to separate the terms.
#' @param last Separator used to separate the last two items if `x` has at least
#'   2 items.
#' @returns A character string with the same class as `x`.
#' @examples
#' aut <- Plume$new(encyclopedists)
#' aut$get_author_list() |> enumerate()
#' @export
enumerate <- function(x, sep = ", ", last = " and ") {
  out <- glue_collapse(x, sep = sep, last = last)
  vec_restore(out, x)
}
