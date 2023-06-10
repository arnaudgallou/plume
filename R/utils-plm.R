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

new_plm_agt <- function(x, name) {
  new_plm(x, name = name, class = "plm_agt")
}
