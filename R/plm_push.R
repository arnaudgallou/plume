#' @title Push plume objects into a Quarto document
#' @description `plm_push()` inserts author information not handled by Quarto's
#'   author schema into a Quarto document. This function should only be used with
#'   [`PlumeQuarto`] to inject author data from a separate script that are not
#'   passed via [`PlumeQuarto$to_yaml()`][PlumeQuarto]. It's handy to avoid
#'   instantiating the class both in the R script and Quarto file.
#' @param x A plume object.
#' @param file A `.qmd` file.
#' @param where Line of text present in `file` after which data should appear.
#'   This parameter is ignored if an anchor for the specific data to insert already
#'   exits in the file.
#' @param sep Separator used to separate items passed to `x`.
#' @return The input `file` invisibly.
#' @examples
#' \dontrun{
#' tmp_file <- withr::local_tempfile(
#'   lines = "# Foo\n\n# Bar",
#'   fileext = ".qmd"
#' )
#'
#' readr::read_file(tmp_file) |> cat()
#'
#' o <- PlumeQuarto$new(
#'   encyclopedists,
#'   names = c(contribution = "contribution_n")
#' )
#' o$get_contributions() |> plm_push(tmp_file, where = "# Foo")
#'
#' readr::read_file(tmp_file) |> cat()
#' }
#' @export
plm_push <- function(x, file, where = NULL, sep = "; ") {
  check_plm(x)
  check_file(file, extension = "qmd")
  check_string(where, allow_empty = FALSE, allow_null = TRUE)
  check_string(sep, allow_empty = FALSE)
  anch_push(x, file, where, sep)
}

#' @export
print.plm <- function(x, ...) {
  print(unstructure(x))
}

anch_make <- function(name) {
  out <- map(c(start = "start", end = "end"), \(item) {
    sprintf("<!-- plume %s: %s -->", name, item)
  })
  list(elts = out, pattern = collapse(out, "(?s).*"))
}

anch_wrap <- function(input, anchor, eol) {
  paste0(anchor$start, wrap(input, eol), anchor$end)
}

anch_add <- function(string, input, where, eol) {
  input <- paste0(eol, input)
  where_regex <- paste0(where, "\\K")
  string_replace(string, where_regex, input)
}

anch_insert <- function(string, anchor, input, where, eol) {
  if (string_detect(string, anchor)) {
    return(string_replace(string, anchor, input))
  }
  anch_add(string, input, where, eol)
}

has_line <- function(x, line) {
  string_detect(x, paste0("(?m)^", line, "\\s*$"))
}

check_anchor <- function(x, where, anchor) {
  if (string_detect(x, anchor) || has_line(x, where)) {
    return()
  }
  abort_check(msg = glue("Can't find line `{where}`."))
}

anch_push <- function(what, file, where, sep) {
  text <- read_file(file)
  anchor <- anch_make(attr(what, "name"))
  check_anchor(text, where, anchor$pattern)
  eol <- strrep(get_eol(), 2)
  input <- anch_wrap(collapse(what, sep), anchor$elts, eol)
  out <- anch_insert(text, anchor$pattern, input, where, eol)
  write_lines(out, file, sep = "")
}
