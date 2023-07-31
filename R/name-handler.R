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

    get_names = function(..., use_keys = TRUE) {
      dots <- c(...)
      nms <- if (is.list(dots)) unlist(dots) else dots
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
