#' @title NameHandler class
#' @description Internal class that handles the names of a `plume` object.
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

    pick = function(..., use_keys = FALSE) {
      list_fetch_all(private$names, ..., use_keys = use_keys)
    },

    set_names = function(x) {
      if (any(lengths(x)) > 1L) {
        x <- map(x, 1L)
      }
      private$names <- list_replace(private$names, x)
    }
  )
)
