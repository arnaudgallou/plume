binder <- ContextBinder$new()

#' @title StatusSetter class
#' @description Internal class that manages authors' status.
#' @keywords internal
StatusSetter <- R6Class(
  classname = "StatusSetter",
  inherit = PlumeHandler,
  public = list(
    initialize = function(..., by) {
      super$initialize(...)
      check_string(by, allow("null"))
      if (is.null(by)) {
        private$by <- private$pick("id")
      } else {
        private$check_col(by)
        private$by <- by
      }
    },

    #' @description Set corresponding authors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by`/`.by`
    #'   determine corresponding authors. Matching of values is case-insensitive
    #'   and dot-agnostic.
    #' @param .by Variable used to set corresponding authors. By default, uses
    #'   authors' id.
    #' @param by `r lifecycle::badge("deprecated")`
    #'
    #'   Please use the `.by` parameter instead.
    #' @return The class instance.
    set_corresponding_authors = function(..., .by = NULL, by = deprecated()) {
      private$set_status("corresponding", ..., .by = .by, by = by)
    }
  ),

  private = list(
    by = NULL,

    set_status = function(col, ..., .by, by) {
      check_dots_not_empty()
      if (lifecycle::is_present(by)) {
        call <- if (col == "corresponding") "corresponding_author" else col
        call <- glue("set_{call}")
        lifecycle::deprecate_stop(
          "0.2.0",
          glue("{call}(by)"),
          glue("{call}(.by)")
        )
      }
      by <- private$process_by(.by)
      binder$bind(private$plume[[by]])
      dots <- collect_dots(...)
      private$plume <- mutate(
        private$plume,
        !!private$pick(col) := vec_in(.data[[by]], dots, ignore_dots = TRUE)
      )
      invisible(self)
    },

    process_by = function(by) {
      if (is.null(by)) {
        return(private$by)
      }
      check_string(by, allow("null"), arg = ".by")
      private$check_col(by)
      by
    }
  )
)

#' @title StatusSetterPlume class
#' @description Internal class extending `StatusSetter` for `Plume`.
#' @keywords internal
StatusSetterPlume <- R6Class(
  classname = "StatusSetterPlume",
  inherit = StatusSetter,
  public = list(
    #' @description Force one or more contributors' names to appear first in the
    #'   contribution list.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by`/`.by`
    #'   determine main contributors. Expressions can be named after any role to
    #'   set different main contributors to different roles at once, in which
    #'   case the `.roles` parameter only applies roles that are not already set
    #'   to unnamed expressions. Matching of values is case-insensitive and dot-
    #'   agnostic.
    #' @param .roles Roles to assign main contributors to. If `.roles` is a
    #'   named vector, only the names will be used.
    #' @param .by Variable used to specify which authors are main contributors.
    #'   By default, uses authors' id.
    #' @return The class instance.
    set_main_contributors = function(..., .roles = NULL, .by = NULL) {
      private$set_ranks(..., .roles = .roles, .by = .by)
    }
  ),

  private = list(
    set_ranks = function(..., .roles, .by) {
      check_dots_not_empty()
      check_character(.roles, allow("null", "unnamed"))
      by <- private$process_by(.by)
      vars <- private$pick("role", "contributor_rank", squash = FALSE)
      dots <- collect_dots(...)
      if (!(is.null(.roles) && is_named(dots))) {
        dots <- propagate_names(dots, nms = .roles)
      }
      out <- unnest(private$plume, col = all_of(vars$role))
      out <- add_contribution_ranks(out, dots, private$.roles, by, vars)
      private$plume <- nest(out, !!vars$role := squash(vars))
      invisible(self)
    }
  )
)

#' @title StatusSetterPlumeQuarto class
#' @description Internal class extending `StatusSetter` for `PlumeQuarto`.
#' @keywords internal
StatusSetterPlumeQuarto <- R6Class(
  classname = "StatusSetterPlumeQuarto",
  inherit = StatusSetter,
  public = list(
    #' @description Set co-first authors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by`/`.by`
    #'   determine co-first authors. Matching of values is case-insensitive and
    #'   dot-agnostic.
    #' @param .by Variable used to specify which authors contributed equally to
    #'   the work. By default, uses authors' id.
    #' @return The class instance.
    set_cofirst_authors = function(..., .by = NULL) {
      private$set_status("equal_contributor", ..., .by = .by)
    },

    #' @description `r lifecycle::badge("deprecated")`
    #'
    #'   This method has been deprecated in favour of `set_cofirst_authors()`.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by`/`.by`
    #'   determine equal contributors. Matching of values is case-insensitive.
    #' @param .by Variable used to specify which authors are equal contributors.
    #'   By default, uses authors' id.
    #' @param by `r lifecycle::badge("deprecated")`
    #'
    #'   Please use the `.by` parameter instead.
    #' @return The class instance.
    set_equal_contributor = function(..., .by = NULL, by = deprecated()) {
      lifecycle::deprecate_stop(
        "0.2.0",
        "set_equal_contributor()",
        "set_cofirst_authors()"
      )
    },

    #' @description Set deceased authors.
    #' @param ... One or more unquoted expressions separated by commas.
    #'   Expressions matching values in the column defined by `by`/`.by`
    #'   determine deceased authors. Matching of values is case-insensitive and
    #'   dot-agnostic.
    #' @param .by Variable used to specify whether an author is deceased or not.
    #'   By default, uses authors' id.
    #' @param by `r lifecycle::badge("deprecated")`
    #'
    #'   Please use the `.by` parameter instead.
    #' @return The class instance.
    set_deceased = function(..., .by = NULL, by = deprecated()) {
      private$set_status("deceased", ..., .by = .by, by = by)
    }
  )
)
