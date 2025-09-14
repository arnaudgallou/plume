#' @export
print.plm <- function(x, ...,  sep = "\n") {
  if (length(x) > 0L) {
    cat(x, ..., sep = sep)
  }
  invisible(x)
}

as_plm <- function(x) {
  add_class(x, "plm")
}

compare_proxy.plm <- function(x, path = "x") {
  x <- unstructure(x)
  NextMethod()
}

#' @export
print.plm_list <- function(x, ...) {
  print(unclass(x))
  invisible(x)
}
