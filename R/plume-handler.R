default_names <- list(
  internal = list(
    id = "id",
    initials = "initials",
    literal_name = "literal_name",
    corresponding = "corresponding",
    deceased = "deceased",
    equal_contributor = "equal_contributor"
  ),
  primary = list(
    given_name = "given_name",
    family_name = "family_name"
  ),
  secondary = list(
    number = "number",
    dropping_particle = "dropping_particle",
    email = "email",
    orcid = "orcid",
    phone = "phone",
    fax = "fax",
    url = "url"
  ),
  nestable = list(
    affiliation = "affiliation",
    role = "role",
    note = "note"
  )
)

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
        credit_roles,
        initials_given_name,
        family_name_first = FALSE,
        interword_spacing = TRUE
    ) {
      check_df(data)
      check_character(names, force_names = TRUE, allow_duplicates = FALSE)
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
      if (!is.null(names)) {
        private$set_names(names)
      }
      private$check_col(private$get_names("primary"))
      private$check_authors()
      private$mount()
    },

    print = function() {
      print(private$plume)
    },

    get_plume = function() {
      private$plume
    }
  ),

  private = list(
    plume = NULL,
    plume_names = default_names,
    initials_given_name = NULL,
    family_name_first = NULL,
    crt = NULL,
    interword_spacing = " ",

    mount = function() {
      private$build()
      private$sanitise()
      for (col in private$get_names("nestable")) {
        if (private$is_nestable(paste0("^", col))) {
          private$nest(col)
        }
      }
    },

    build = function() {
      private$mold()
      private$make_author_names()
      if (private$crt) {
        private$crt_process()
      }
      private$plume <- rowid_to_column(private$plume, var = private$names$id)
    },

    mold = function(...) {
      vars <- private$get_vars()
      private$plume <- select(
        private$plume,
        all_of(vars$primary),
        any_of(vars$secondary),
        starts_with(vars$nestable),
        if (private$crt) any_of(names(.names$protected$crt)),
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
      nestables <- private$get_names("nestable", use_keys = TRUE)
      if (private$crt) {
        nestables <- nestables[names(nestables) != "role"]
      }
      list(
        primary = private$get_names("primary"),
        secondary = private$get_names("secondary"),
        nestable = nestables
      )
    },

    crt_process = function() {
      out <- crt_assign(private$plume)
      private$plume <- crt_rename(out, prefix = private$names$role)
    },

    make_author_names = function() {
      if (private$initials_given_name) {
        given_name <- private$names$given_name
        private$plume <- mutate(
          private$plume,
          !!given_name := make_initials(.data[[given_name]], dot = TRUE)
        )
      }
      private$make_literals()
      if (any(has_uppercase(private$get("literal_name")))) {
        private$make_initials()
      }
    },

    make_literals = function() {
      nominal <- private$get_names("primary")
      if (private$family_name_first) {
        nominal <- rev(nominal)
      }
      private$plume <- mutate(
        private$plume, !!private$names$literal_name := paste(
          !!!syms(nominal),
          sep = private$interword_spacing
        ), .after = all_of(private$names$family_name)
      )
    },

    make_initials = function() {
      private$plume <- mutate(
        private$plume,
        !!private$names$initials := make_initials(
          .data[[private$names$literal_name]]
        ),
        .after = all_of(private$names$literal_name)
      )
    },

    sanitise = function() {
      private$plume <- mutate(private$plume, across(
        \(x) any(is_blank(x)),
        blank_to_na
      ))
    },

    get = function(col) {
      col <- private$names[[col]]
      private$plume[[col]]
    },

    is_nestable = function(col) {
      private$has_col(col) && col_count(private$plume, col) > 1L
    },

    has_col = function(col) {
      if (any(has_metachr(col))) {
        col <- regex(col)
      }
      has_name(private$plume, col)
    },

    check_col = function(x, ...) {
      missing_col <- search(x, Negate(private$has_col))
      if (is.null(missing_col)) {
        return()
      }
      msg <- glue("Column `{missing_col}` doesn't exist.")
      abort_check(msg = msg, ...)
    },

    check_authors = function() {
      nominal <- private$get_names("primary")
      authors <- select(private$plume, all_of(nominal))
      authors <- reduce(authors, \(x, y) {
        if_else(is_void(x) | is_void(y), NA, 1L)
      })
      missing_author <- search(authors, is.na, na_rm = FALSE)
      if (is.null(missing_author)) {
        return()
      }
      abort_check(msg = c(
        glue("Missing author name found in position {names(missing_author)}."),
        i = "You must supply a given and family names."
      ))
    }
  )
)
