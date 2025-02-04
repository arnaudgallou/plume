#' @title Print vector elements on multiple lines
#' @description Thin wrapper around [`cat()`] to display vector elements on
#'   multiple lines when rendering an R Markdown or Quarto document. This is
#'   primarily intended to be used with [`Plume`]'s methods to output each
#'   returned element on its own line.
#' @param ... Objects to print.
#' @returns `NULL` invisibly.
#' @examples
#' aut <- Plume$new(encyclopedists)
#' as_lines(aut$get_affiliations())
#' @export
as_lines <- function(...) {
  cat(c(...), sep = strrep(eol(), 2L))
}
