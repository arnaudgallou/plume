#' @title NameHandler class
#' @description Internal class that handles the names of a `plume` object.
#' @keywords internal
#' @noRd
NameHandler <- R6Class(
  classname = "NameHandler",
  public = list(
    initialize = function(names) {
      check_list(names, allow_duplicates = FALSE)
      private$names <- names
    }
  ),

  private = list(
    names = NULL,

    pick = function(..., squash = TRUE) {
      list_fetch_all(private$names, ..., squash = squash)
    },

    set_names = function(x) {
      private$names <- list_replace(private$names, x)
    }
  )
)
