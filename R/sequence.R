#' @title Control sequencing behaviour of vectors
#' @description Modifier function used to generate logical sequences of characters.
#' @param x A character vector.
#' @examples
#' aut <- Plume$new(
#'   tibble::tibble(given_name = "X", family_name = "Y", affiliation = 1:60),
#'   symbols = list(affiliation = sequential(letters))
#' )
#'
#' aut$get_affiliations(sep = ": ", superscript = FALSE) |> cat(sep = "\n")
#' @export
sequential <- function(x) {
  check_character(x, allow_duplicates = FALSE, allow_null = FALSE)
  structure(x, class = c("sequential", "character"))
}

is_sequential <- function(x) {
  inherits(x, "sequential")
}

seq_symbols <- function(x, i) {
  i <- length(i)
  n_elements <- length(x)
  if (is_sequential(x)) {
    n_rep <- log(i, base = n_elements)
  } else {
    n_rep <- i / n_elements
  }
  n_rep <- ceiling(n_rep)
  seq_vector(x, n_rep)
}

seq_vector <- function(x, n) {
  if (n <= 1L) {
    return(x)
  }
  UseMethod("seq_vector")
}

seq_vector.default <- function(x, n) {
  out <- map(seq(n), \(i) strrep(x, i))
  unlist(out)
}

seq_vector.sequential <- function(x, n) {
  out <- map(seq(n - 1), \(i) c("", x))
  out <- c(out, list(x))
  out <- reduce(out, expand_grid)
  out <- reduce(out, paste0)
  unique(out)
}
