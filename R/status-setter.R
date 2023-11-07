binder <- ContextBinder$new()

#' @title StatusSetter class
#' @description Internal class that manages authors' status.
StatusSetter <- R6Class(
  classname = "StatusSetter",
  inherit = PlumeHandler,
  public = list(
    initialize = function(..., by) {
      super$initialize(...)
      check_string(by, allow_empty = FALSE, allow_null = TRUE)
      if (is.null(by)) {
        private$by <- private$pick("id")
      } else {
        private$check_col(by)
        private$by <- by
      }
    },

    #' @description Set corresponding authors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by` determine
    #'   corresponding authors. Matching of values is case-insensitive.
    #' @param by Variable used to set corresponding authors. By default, uses
    #'   authors' id.
    #' @return The class instance.
    set_corresponding_authors = function(..., by) {
      private$set_status("corresponding", ..., by = by)
    }
  ),

  private = list(
    by = NULL,

    set_status = function(col, ..., by) {
      by <- private$snatch_by()
      binder$bind(private$plume[[by]])
      private$plume <- mutate(
        private$plume,
        !!private$pick(col) := includes(.data[[by]], collect_dots(...))
      )
      invisible(self)
    },

    snatch_by = function() {
      by <- caller_env(2L)$by
      if (missing(by)) {
        by <- private$by
      } else {
        check_string(by, allow_empty = FALSE)
      }
      private$check_col(by)
      by
    }
  )
)

#' @title StatusSetterPlume class
#' @description Internal class extending `StatusSetter` for `Plume`.
StatusSetterPlume <- R6Class(
  classname = "StatusSetterPlume",
  inherit = StatusSetter,
  public = list(
    #' @description Set lead contributors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by` determine
    #'   lead contributors. Matching of values is case-insensitive.
    #' @param roles Character vector or roles
    #' @param by Variable used to specify which authors are equal contributors.
    #'   By default, uses authors' id.
    #' @return The class instance.
    set_lead_contributors = function(..., roles = NULL, by) {
      if (are_calls(...)) {
        dots <- c(...)
        for (key in names(dots)) {
          private$set_ranks(dots[[key]], roles = key, by = by)
        }
      } else {
        private$set_ranks(..., roles = roles, by = by)
      }
    }
  ),

  private = list(
    set_ranks = function(..., roles, by) {
      check_character(roles, allow_duplicates = FALSE)
      by <- private$snatch_by()
      vars <- private$pick("role", "contribution_degree", squash = FALSE)
      roles <- private$roles[roles]
      out <- unnest(private$plume, col = all_of(vars$role))
      out <- add_contribution_degrees(out, collect_dots(...), by, roles, vars)
      private$plume <- nest(out, role = unlist(vars, use.names = FALSE))
      invisible(self)
    }
  )
)

#' @title StatusSetterQuarto class
#' @description Internal class extending `StatusSetter` for `PlumeQuarto`.
StatusSetterPlumeQuarto <- R6Class(
  classname = "StatusSetterQuarto",
  inherit = StatusSetter,
  public = list(
    #' @description Set equal contributors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by` determine
    #'   equal contributors. Matching of values is case-insensitive.
    #' @param by Variable used to specify which authors are equal contributors.
    #'   By default, uses authors' id.
    #' @return The class instance.
    set_equal_contributor = function(..., by) {
      private$set_status("equal_contributor", ..., by = by)
    },

    #' @description Set deceased authors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by` determine
    #'   deceased authors. Matching of values is case-insensitive.
    #' @param by Variable used to specify whether an author is deceased or not.
    #'   By default, uses authors' id.
    #' @return The class instance.
    set_deceased = function(..., by) {
      private$set_status("deceased", ..., by = by)
    }
  )
)

#' @title Select all authors or exclude some from a selection
#' @description Selection helpers to use in conjonction with `set_*()` methods:
#'   * [`everyone()`] select all authors.
#'   * [`everyone_but()`] select all but specific authors.
#' @examples
#' aut <- Plume$new(encyclopedists)
#'
#' aut$set_corresponding_authors(everyone())
#' aut$get_plume() |> dplyr::select(1:3, corresponding)
#'
#' aut$set_corresponding_authors(
#'   everyone_but(jean),
#'   by = "given_name"
#' )
#' aut$get_plume() |> dplyr::select(1:3, corresponding)
#' @export
everyone <- function() {
  binder$pull(call = "everyone")
}

#' @rdname everyone
#' @param ... One or more unquoted expressions separated by commas. Expressions
#'   matching values in the column defined by the `by` parameter of `set_*()`
#'   methods are used to set a given status to authors. Matching of values is
#'   case-insensitive.
#' @export
everyone_but <- function(...) {
  binder$pull(call = "everyone_but", ignore = enexprs(...))
}
