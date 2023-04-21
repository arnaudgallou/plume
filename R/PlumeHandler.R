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
      given_name <- self$names$given_name
      family_name <- self$names$family_name
      nominal <- c(given_name, family_name)
      if (private$family_name_first) {
        nominal <- rev(nominal)
      }
      out <- drop_na(self$plume, all_of(nominal))
      if (private$initials_given_name) {
        out <- mutate(out, !!given_name := make_initials(
          .data[[given_name]],
          dot = TRUE
        ))
      }
      out <- mutate(out, !!self$names$literal_name := paste(
        !!!syms(nominal),
        sep = private$interword_spacing
      ), .after = all_of(family_name))
      self$plume <- rowid_to_column(out, var = self$names$id)
      if (any(has_uppercase(private$get("literal_name")))) {
        private$add_initials()
      }
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

    sanitise = function() {
      vars <- private$plume_keys[c("secondary", "nestable")]
      self$plume <- mutate(self$plume, across(
        starts_with(private$get_names(vars)),
        blank_to_na
      ))
    },

    get = function(col) {
      col <- self$names[[col]]
      self$plume[[col]]
    },

    add_initials = function() {
      literal_name <- self$names$literal_name
      self$plume <- mutate(
        self$plume,
        !!self$names$initials := make_initials(.data[[literal_name]]),
        .after = all_of(literal_name)
      )
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
      missing_col <- search_failing(x, private$has_col)
      if (is.null(missing_col)) {
        return()
      }
      msg <- glue("Column `{missing_col}` doesn't exist.")
      abort_input_check(msg = msg, ...)
    }
  )
)