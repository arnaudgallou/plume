#' @title NameHandler class
#' @description Internal class that handles the names of a `plume` object.
NameHandler <- R6Class(
  classname = "NameHandler",
  public = list(
    initialize = function(names) {
      check_list(names, allow_duplicates = FALSE)
      private$keys <- map(names, base::names)
      private$names <- flatten(names)
    }
  ),

  private = list(
    keys = NULL,
    names = NULL,

    get_names = function(..., use_keys = FALSE) {
      dots <- c(...)
      if (length(dots) == 1L && dots %in% names(private$keys)) {
        nms <- private$keys[[dots]]
      } else {
        nms <- dots
      }
      unlist(private$names[nms], use.names = use_keys)
    },

    set_names = function(x) {
      if (any(lengths(x)) > 1L) {
        x <- map(x, 1L)
      }
      if (!all(x %in% private$names)) {
        private$names <- supplant(private$names, x)
      }
    }
  )
)
