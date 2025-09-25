#' @title Print vector elements on distinct lines
#' @description
#' Thin wrapper around `cat()` to display vector elements on distinct lines when
#' rendering an R Markdown or Quarto document.
#' @param ... Objects to print.
#' @returns `NULL`, invisibly.
#' @examples
#' aut <- Plume$new(encyclopedists)
#' as_lines(aut$get_affiliations())
#' @export
as_lines <- function(...) {
  check_atomic(c(...), arg = "...")
  cat(..., sep = strrep(eol(), 2L))
}
