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
    dropping_particle = "dropping_particle",
    email = "email",
    orcid = "orcid",
    number = "number",
    fax = "fax",
    url = "url"
  ),
  nestable = list(
    affiliation = "affiliation",
    contribution = "contribution",
    note = "note"
  )
)


#' @title PlumeHandler class
#' @description Internal class processing and shaping tabular data into a `plume`
#'   object.
PlumeHandler <- R6Class(
  classname = "PlumeHandler",
  inherit = NameHandler,
  public = list(
    plume = NULL,

    initialize = function(
        data,
        names,
        initials_given_name,
        family_name_first,
        interword_spacing
    ) {
      check_df(data)
      check_character(names, force_names = TRUE, allow_duplicates = FALSE)
      check_args("bool", list(
        initials_given_name,
        family_name_first,
        interword_spacing
      ))
      super$initialize(flatten(private$plume_names))
      self$plume <- as_tibble(data)
      private$initials_given_name <- initials_given_name
      private$family_name_first <- family_name_first
      if (!interword_spacing) {
        private$interword_spacing <- ""
      }
      if (!is.null(names)) {
        private$set_names(names)
      }
      private$check_col(private$get_names(private$plume_keys$primary))
      private$check_authors()
      private$mount()
    },

    print = function() {
      print(self$plume)
    }
  ),

  private = list(
    plume_names = default_names,
    plume_keys = map(default_names, names),
    initials_given_name = NULL,
    family_name_first = NULL,
    interword_spacing = " ",

    mount = function() {
      private$build()
      private$sanitise()
      for (col in private$get_names(private$plume_keys$nestable)) {
        if (private$is_nestable(paste0("^", col))) {
          private$nest(col)
        }
      }
    },

    build = function() {
      private$mold()
      private$make_author_names()
      self$plume <- rowid_to_column(self$plume, var = self$names$id)
    },

    mold = function(...) {
      keys <- private$plume_keys
      primary <- private$get_names(keys$primary, use_keys = FALSE)
      secondary <- private$get_names(keys$secondary, use_keys = FALSE)
      nestable <- private$get_names(keys$nestable)
      self$plume <- select(
        self$plume,
        all_of(primary),
        any_of(secondary),
        starts_with(nestable),
        ...
      )
    },

    nest = function(col) {
      out <- pivot_longer(
        self$plume,
        cols = starts_with(col),
        values_to = col,
        names_to = NULL
      )
      self$plume <- nest(out, !!col := any_of(col))
    },

    make_author_names = function() {
      if (private$initials_given_name) {
        self$plume <- mutate(self$plume, !!self$names$given_name := make_initials(
          .data[[self$names$given_name]],
          dot = TRUE
        ))
      }
      private$make_literals()
      if (any(has_uppercase(private$get("literal_name")))) {
        private$make_initials()
      }
    },

    make_literals = function() {
      nominal <- private$get_names("given_name", "family_name")
      if (private$family_name_first) {
        nominal <- rev(nominal)
      }
      self$plume <- mutate(self$plume, !!self$names$literal_name := paste(
        !!!syms(nominal),
        sep = private$interword_spacing
      ), .after = all_of(self$names$family_name))
    },

    make_initials = function() {
      self$plume <- mutate(
        self$plume,
        !!self$names$initials := make_initials(.data[[self$names$literal_name]]),
        .after = all_of(self$names$literal_name)
      )
    },

    sanitise = function() {
      self$plume <- mutate(self$plume, across(
        \(x) any(is_blank(x)),
        blank_to_na
      ))
    },

    get = function(col) {
      col <- self$names[[col]]
      self$plume[[col]]
    },

    is_nestable = function(col) {
      private$has_col(col) && col_count(self$plume, col) > 1L
    },

    has_col = function(col) {
      if (any(has_metachr(col))) {
        col <- regex(col)
      }
      has_name(self$plume, col)
    },

    check_col = function(x, ...) {
      missing_col <- search(x, Negate(private$has_col))
      if (is.null(missing_col)) {
        return()
      }
      msg <- glue("Column `{missing_col}` doesn't exist.")
      abort_input_check(msg = msg, ...)
    },

    check_authors = function() {
      nominal <- private$get_names("given_name", "family_name")
      authors <- select(self$plume, all_of(nominal))
      authors <- reduce(authors, \(x, y) {
        if_else(is_void(x) | is_void(y), NA, 1L)
      })
      missing_author <- search(authors, is_void, drop_na = FALSE)
      if (is.null(missing_author)) {
        return()
      }
      abort_input_check(msg = c(
        glue("Missing author name found in position {names(missing_author)}."),
        i = "You must supply a given and family names."
      ))
    }
  )
)
