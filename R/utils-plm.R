#' @export
print.plm <- function(x, ...) {
  if (length(x) > 0L) {
    cat(x, ..., sep = "\n")
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
