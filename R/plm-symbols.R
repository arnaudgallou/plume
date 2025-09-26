#' @title Set symbols for `Plume`
#' @description
#' Set the symbols used in a [`Plume`] object.
#' @param affiliation,corresponding,note Character vectors of symbols to use,
#'   or `NULL` to use numerals.
#' @returns A named list.
#' @examples
#' aut <- Plume$new(
#'   encyclopedists,
#'   symbols = plm_symbols(affiliation = letters)
#' )
#' aut$get_author_list("^a^")
#' @export
plm_symbols <- function(
  affiliation = NULL,
  corresponding = "*",
  note = c("\u2020", "\u2021", "\u00a7", "\u00b6", "#", "**")
) {
  check_args(
    "character",
    quos(affiliation, corresponding, note),
    allow("null", "unnamed")
  )
  add_class(cls = "plm_list", list(
    affiliation = affiliation,
    corresponding = corresponding,
    note = note
  ))
}
