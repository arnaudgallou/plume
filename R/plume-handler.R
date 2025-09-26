#' @title PlumeHandler class
#' @description
#' Internal class processing and shaping tabular data into a plume object.
#' @keywords internal
PlumeHandler <- R6Class(
  classname = "PlumeHandler",
  inherit = NameHandler,
  public = list(
    initialize = function(
      data,
      names,
      roles,
      credit_roles,
      initials_given_name,
      dotted_initials,
      family_name_first = FALSE,
      distinct_initials = FALSE,
      interword_spacing = TRUE
    ) {
      check_df(data)
      check_args("character", quos(names, roles), allow("null"))
      check_args("bool", quos(
        credit_roles,
        initials_given_name,
        family_name_first,
        distinct_initials,
        dotted_initials,
        interword_spacing
      ))
      super$initialize(private$names)
      private$plume <- tibble::as_tibble(data)
      private$initials_given_name <- initials_given_name
      private$family_name_first <- family_name_first
      private$distinct_initials <- distinct_initials
      private$dotted_initials <- dotted_initials
      if (!interword_spacing) {
        private$interword_spacing <- ""
      }
      if (credit_roles) {
        lifecycle::deprecate_stop(
          "0.2.0",
          "new(credit_roles)",
          I("`roles = credit_roles()`")
        )
      }
      private$.roles <- roles
      private$check_role_system()
      if (!is.null(names)) {
        private$set_names(names)
      }
      private$check_col(private$pick("primaries"))
      private$check_authors()
      private$mount()
    },

    print = function() {
      print(private$plume)
    },

    #' @description Get the data of a plume object.
    #' @return A tibble.
    data = function() {
      private$plume
    },

    #' @description `r lifecycle::badge("deprecated")`
    #'
    #' Please use `$data()` instead.
    #' @return A tibble.
    get_plume = function() {
      lifecycle::deprecate_warn("0.3.0", "get_plume()", "data()")
      private$plume
    },

    #' @description Get the roles used in a plume object.
    #' @return A character vector.
    roles = function() {
      private$.roles
    },

    #' @description `r lifecycle::badge("deprecated")`
    #'
    #' Please use `$roles()` instead.
    #' @return A character vector.
    get_roles = function() {
      lifecycle::deprecate_warn("0.3.0", "get_roles()", "roles()")
      private$.roles
    }
  ),

  private = list(
    plume = NULL,
    names = .names,
    initials_given_name = NULL,
    family_name_first = NULL,
    distinct_initials = NULL,
    dotted_initials = NULL,
    .roles = NULL,
    interword_spacing = " ",

    mount = function() {
      private$build()
      for (var in private$pick("nestables", "role")) {
        if (private$is_nestable(var)) {
          private$nest(var)
        }
      }
    },

    build = function() {
      private$mold()
      private$sanitise()
      private$add_author_names()
      if (!is.null(private$.roles)) {
        private$process_roles()
      }
      private$add_ids()
    },

    mold = function(...) {
      private$plume <- select(
        private$plume,
        all_of(private$pick("primaries")),
        any_of(c(private$pick("secondaries"), names(private$.roles))),
        starts_with(private$pick("nestables")),
        ...
      )
    },

    nest = function(col) {
      out <- tidyr::pivot_longer(
        private$plume,
        cols = starts_with(col),
        values_to = col,
        names_to = NULL
      )
      private$plume <- nest(out, !!col := all_of(col))
    },

    process_roles = function() {
      roles <- private$.roles
      roles <- roles[names(roles) %in% names(private$plume)]
      out <- assign_roles(private$plume, roles)
      private$plume <- rename_roles(out, roles, key = private$pick("role"))
    },

    add_author_names = function() {
      private$add_initials()
      private$add_literal_names()
    },

    add_literal_names = function() {
      nominals <- private$pick("primaries")
      if (private$family_name_first) {
        nominals <- rev(nominals)
      }
      vars <- private$pick("literal_name", "family_name", squash = FALSE)
      private$plume <- mutate(private$plume, !!vars$literal_name := paste(
        !!!syms(nominals),
        sep = private$interword_spacing
      ), .after = all_of(vars$family_name))
    },

    add_initials = function() {
      vars <- private$pick("primaries", squash = FALSE)
      if (!private$has_uppercase(vars$family_name)) {
        return()
      }
      private$plume <- mutate(
        private$plume,
        private$make_initials(vars),
        .after = all_of(vars$family_name)
      )
    },

    make_initials = function(vars) {
      cols <- squash(vars)
      out <- select(private$plume, all_of(cols))
      out <- mutate(out, across(
        all_of(cols),
        \(col) make_initials(col, private$dotted_initials)
      ))
      if (private$distinct_initials) {
        out <- add_long_initials(
          out,
          vars$family_name,
          private$pull("family_name")
        )
      }
      out <- mutate(out, !!private$pick("initials") := do.call(paste0, out))
      to_drop <- if (private$initials_given_name) vars$family_name else cols
      select(out, -any_of(to_drop))
    },

    add_ids = function() {
      private$plume <- rowid_to_column(private$plume, var = private$pick("id"))
    },

    sanitise = function() {
      private$plume <- mutate(
        private$plume,
        across(\(x) any(is_blank(x)), blank_to_na),
        across(\(x) any(has_overflowing_ws(x)), trimws)
      )
    },

    pull = function(col) {
      private$plume[[private$pick(col)]]
    },

    is_nestable = function(var) {
      var <- begins_with(var)
      private$has_col(var) && col_count(private$plume, var) > 1L
    },

    has_uppercase = function(var) {
      any(has_uppercase(private$plume[[var]]))
    },

    has_col = function(col) {
      if (any(has_metachr(col))) {
        col <- stringr::regex(col)
      }
      has_name(private$plume, col)
    },

    check_col = function(x) {
      missing_col <- seek(x, Negate(private$has_col))
      if (is.null(missing_col)) {
        return()
      }
      bullets <- .col_bullets[[names(missing_col)]]
      abort(glue("Column `{missing_col}` doesn't exist."), footer = bullets)
    },

    check_authors = function() {
      nominal <- private$pick("primaries")
      authors <- select(private$plume, all_of(nominal))
      missing_name <- reduce(authors, \(x, y) is_void(x) | is_void(y))
      missing_name <- seek(missing_name)
      if (is.null(missing_name)) {
        return()
      }
      abort(c(
        glue("Missing author name found in position {names(missing_name)}."),
        i = "All authors must have a given and family name."
      ))
    }
  )
)

PlumeHandler$set("private", "check_role_system", function() {
  var <- private$pick("role")
  if (!private$has_col(begins_with(var))) {
    return()
  }
  roles <- select(private$plume, starts_with(var))
  have_explicit_roles <- map_vec(roles, \(role) any(str_detect(role, "\\D")))
  if (!all(have_explicit_roles)) {
    return()
  }
  lifecycle::deprecate_stop(
    "0.2.0",
    what = I("Defining explicit roles in the input data"),
    with = "new(roles)",
    details = paste0(
      "See <",
      "https://arnaudgallou.github.io/plume/articles/plume.html",
      "#defining-roles-and-contributors",
      ">."
    )
  )
})
