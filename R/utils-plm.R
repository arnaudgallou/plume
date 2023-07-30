#' @export
print.plm <- function(x, ...) {
  if (length(x) > 0L) {
    cat(x, ..., sep = "\n")
  }
  invisible(x)
}

new_plm <- function(x, ..., class = character()) {
  structure(x, ..., class = c(class, "plm", "character"))
}

compare_proxy.plm <- function(x, path = "x") {
  x <- unstructure(x)
  NextMethod()
}
