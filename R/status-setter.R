#' @title StatusSetter class
#' @description Internal class that manages authors' status.
StatusSetter <- R6Class(
  classname = "StatusSetter",
  inherit = PlumeHandler,
  public = list(
    #' @description Set corresponding authors.
    #' @param ... Values in the column defined by `by` used to specify
    #'   corresponding authors. Matching of values is case-insensitive. Use
    #'   `"all"` to assign `TRUE` to all authors.
    #' @param by Variable used to set corresponding authors. By default, uses
    #'   authors' id.
    #' @return The class instance.
    set_corresponding_authors = function(..., by) {
      private$set_status("corresponding", ..., by = by)
    }
  ),

  private = list(
    by = "id",

    set_status = function(col, ..., by) {
      if (missing(by)) {
        by <- private$by
      } else {
        check_string(by, allow_empty = FALSE)
      }
      private$check_col(by)
      private$plume <- mutate(private$plume, !!private$pick(col) := {
        if (dots_equal_all(...)) {
          TRUE
        } else {
          true_if(includes(.data[[by]], exprs(...)))
        }
      })
      invisible(self)
    }
  )
)

#' @title StatusSetterQuarto class
#' @description Internal class extending `StatusSetter` for `PlumeQuarto`.
StatusSetterQuarto <- R6Class(
  classname = "StatusSetterQuarto",
  inherit = StatusSetter,
  public = list(
    initialize = function(..., by) {
      super$initialize(...)
      check_string(by, allow_empty = FALSE, allow_null = TRUE)
      if (!is.null(by)) {
        private$check_col(by)
        private$by <- private$pick(by)
      }
    },

    #' @description Set equal contributors.
    #' @param ... Values in the column defined by `by` used to specify which
    #'   authors are equal contributors. Matching of values is case-insensitive.
    #'   Use `"all"` to assign equal contribution to all authors.
    #' @param by Variable used to specify which authors are equal contributors.
    #'   By default, uses authors' id.
    #' @return The class instance.
    set_equal_contributor = function(..., by) {
      private$set_status("equal_contributor", ..., by = by)
    },

    #' @description Set deceased authors.
    #' @param ... Values in the column defined by `by` used to specify whether
    #'   an author is deceased or not. Matching of values is case-insensitive.
    #' @param by Variable used to specify whether an author is deceased or not.
    #'   By default, uses authors' id.
    #' @return The class instance.
    set_deceased = function(..., by) {
      private$set_status("deceased", ..., by = by)
    }
  )
)
