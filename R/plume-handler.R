#' @title PlumeHandler class
#' @description Internal class processing and shaping tabular data into a
#'   `plume` object.
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
        family_name_first = FALSE,
        interword_spacing = TRUE
    ) {
      check_df(data)
      check_args(
        "character",
        list(names, roles),
        force_names = TRUE,
        allow_duplicates = FALSE
      )
      check_args("bool", list(
        credit_roles,
        initials_given_name,
        family_name_first,
        interword_spacing
      ))
      super$initialize(private$plume_names)
      private$plume <- as_tibble(data)
      private$initials_given_name <- initials_given_name
      private$family_name_first <- family_name_first
      if (!interword_spacing) {
        private$interword_spacing <- ""
      }
      private$crt <- credit_roles
      private$check_param_credit_roles()
      private$roles <- roles
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

    get_plume = function() {
      private$plume
    },

    get_roles = function() {
      private$roles
    }
  ),

  private = list(
    plume = NULL,
    plume_names = .names,
    initials_given_name = NULL,
    family_name_first = NULL,
    crt = NULL,
    roles = NULL,
    interword_spacing = " ",

    mount = function() {
      private$build()
      for (col in private$pick("nestables")) {
        if (private$is_nestable(col)) {
          private$nest(col)
        }
      }
    },

    build = function() {
      private$mold()
      private$sanitise()
      private$check_roles()
      private$make_author_names()
      if (!is.null(private$roles) || private$crt) {
        private$process_roles()
      }
      private$plume <- rowid_to_column(private$plume, var = private$pick("id"))
    },

    mold = function(...) {
      vars <- private$get_vars()
      private$plume <- select(
        private$plume,
        all_of(vars$primaries),
        any_of(c(vars$secondaries, names(private$roles))),
        starts_with(vars$nestables),
        if (private$crt) any_of(names(list_fetch(.names, "crt"))),
        ...
      )
    },

    nest = function(col) {
      out <- pivot_longer(
        private$plume,
        cols = starts_with(col),
        values_to = col,
        names_to = NULL
      )
      private$plume <- nest(out, !!col := any_of(col))
    },

    get_vars = function() {
      nestables <- private$pick("affiliation", "note")
      if (!private$crt) {
        nestables <- c(nestables, private$pick("role"))
      }
      list(
        primaries = private$pick("primaries"),
        secondaries = private$pick("secondaries", "orcid"),
        nestables = nestables
      )
    },

    process_roles = function() {
      if (!is.null(private$roles)) {
        roles <- private$roles
      } else {
        roles <- list_fetch(.names, "crt")
      }
      roles <- roles[names(roles) %in% names(private$plume)]
      out <- assign_roles(private$plume, roles)
      private$plume <- rename_roles(out, roles, key = private$pick("role"))
    },

    make_author_names = function() {
      if (private$initials_given_name) {
        given_name <- private$pick("given_name")
        private$plume <- mutate(
          private$plume,
          !!given_name := make_initials(.data[[given_name]], dot = TRUE)
        )
      }
      private$make_literal_names()
      if (any(has_uppercase(private$get("literal_name")))) {
        private$make_initials()
      }
    },

    make_literal_names = function() {
      nominal <- private$pick("primaries")
      if (private$family_name_first) {
        nominal <- rev(nominal)
      }
      vars <- private$pick("literal_name", "family_name", squash = FALSE)
      private$plume <- mutate(private$plume, !!vars$literal_name := paste(
        !!!syms(nominal),
        sep = private$interword_spacing
      ), .after = all_of(vars$family_name))
    },

    make_initials = function() {
      vars <- private$pick("literal_name", "initials", squash = FALSE)
      private$plume <- mutate(
        private$plume,
        !!vars$initials := make_initials(.data[[vars$literal_name]]),
        .after = all_of(vars$literal_name)
      )
    },

    sanitise = function() {
      private$plume <- mutate(
        private$plume,
        across(\(x) any(is_blank(x)), blank_to_na),
        across(\(x) any(has_overflowing_ws(x)), trimws)
      )
    },

    get = function(col) {
      col <- private$pick(col)
      private$plume[[col]]
    },

    is_nestable = function(col) {
      col <- begins_with(col)
      private$has_col(col) && col_count(private$plume, col) > 1L
    },

    has_col = function(col) {
      if (any(has_metachr(col))) {
        col <- regex(col)
      }
      has_name(private$plume, col)
    },

    check_col = function(x, ...) {
      missing_col <- search_(x, Negate(private$has_col))
      if (is.null(missing_col)) {
        return()
      }
      msg <- glue("Column `{missing_col}` doesn't exist.")
      abort_check(msg = msg, ...)
    },

    check_authors = function() {
      nominal <- private$pick("primaries")
      authors <- select(private$plume, all_of(nominal))
      authors <- reduce(authors, \(x, y) {
        if_else(is_void(x) | is_void(y), NA, 1L)
      })
      missing_author <- search_(authors, is.na, na_rm = FALSE)
      if (is.null(missing_author)) {
        return()
      }
      abort_check(msg = c(
        glue("Missing author name found in position {names(missing_author)}."),
        i = "All authors must have a given and family name."
      ))
    },

    check_roles = function() {
      role <- private$pick("role")
      if (!private$has_col(begins_with(role))) {
        return()
      }
      roles <- select(private$plume, starts_with(role))
      roles <- map(roles, \(x) length(condense(x)))
      multiple_roles <- search_(roles, \(x) x > 1L)
      if (is.null(multiple_roles)) {
        return()
      }
      abort_check(msg = c(
        glue("Multiple roles found in column `{names(multiple_roles)}`."),
        i = "Roles must be unique within a column."
      ))
    }
  )
)

PlumeHandler$set("private", "check_param_credit_roles", function() {
  if (!private$crt) {
    return()
  }
  print_deprecation("credit_roles", caller = "new", param = "roles")
})

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
  print_deprecation("explicit_roles")
  private$plume <- select(private$plume, !any_of(names(private$roles)))
})
