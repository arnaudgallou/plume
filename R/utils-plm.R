#' @export
print.plm <- function(x, ...,  sep = "\n") {
  if (length(x) > 0L) {
    cat(x, ..., sep = sep)
  }
  invisible(x)
}

as_plm <- function(x) {
  structure(x, class = c("plm", "character"))
}

compare_proxy.plm <- function(x, path = "x") {
  x <- unstructure(x)
  NextMethod()
}
