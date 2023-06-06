#' @title Plume class
#' @description Class generating author lists and other author-related information.
#' @export
Plume <- R6Class(
  classname = "Plume",
  inherit = PlumeHandler,
  public = list(
    #' @field by Default variable used to assign status to authors.
    by = "id",

    #' @field symbols Symbols suffixing author names used to link authors to
    #'   affiliations, notes and other metadata.
    symbols = list(
      affiliation = NULL,
      corresponding = "\\*",
      note = c("\u2020", "\u2021", "\u00a7", "\u00b6", "\u0023", "\\*\\*")
    ),

    #' @description Create a `Plume` object.
    #' @param data A data frame or tibble containing author-related data.
    #' @param names A vector of column names.
    #' @param symbols A list of keys and values defining the symbols used to link
    #'   authors to metadata. Valid keys are `"affiliation"`,
    #'   `"corresponding"` and `"note"`. By default, uses digits for affiliations,
    #'   `"*"` for corresponding authors and `"†"`, `"‡"`, `"§"`, `"¶"`, `"#"`,
    #'   `"**"` for notes. Set a key to `NULL` to use numerals.
    #' @param by A character string defining the default variable used to assign
    #'   authors' status in all methods. By default, uses authors' ids.
    #' @param initials_given_name Should the initials of given names be used?
    #' @param family_name_first Should literal names show family names first.
    #' @param interword_spacing Should literal names use spacing? This parameter
    #'   is only useful for people writing in languages that don't separate words
    #'   with a space such as Chinese or Japanese.
    #' @return A `Plume` object.
    initialize = function(
        data,
        names = NULL,
        symbols = NULL,
        by = NULL,
        initials_given_name = FALSE,
        family_name_first = FALSE,
        interword_spacing = TRUE
    ) {
      super$initialize(
        data,
        names,
        initials_given_name,
        family_name_first,
        interword_spacing
      )
      check_list(symbols, force_names = TRUE)
      check_string(by, allow_empty = FALSE, allow_null = TRUE)
      if (!is.null(by)) {
        private$check_col(by)
        self$by <- self$names[[by]]
      }
      if (!is.null(symbols)) {
        self$symbols <- supplant(self$symbols, symbols)
      }
    },

    #' @description Set corresponding authors.
    #' @param ... Values in the column defined by `by` used to specify corresponding
    #'   authors. Matching of values is case-insensitive. Use `"all"` to assign
    #'   `TRUE` to all authors.
    #' @param by Variable used to set corresponding authors. By default, uses
    #'   authors' ids.
    #' @return The class instance.
    set_corresponding_authors = function(..., by) {
      private$set_status("corresponding", ..., by = by)
    },

    #' @description Get author list.
    #' @param format A character string defining the format of symbols suffixing
    #'   author names. See details.
    #' @details
    #' `format` lets you choose which symbol categories to suffix authors with,
    #' using the following keys:
    #' - `a` for affiliations
    #' - `c` for corresponding authors
    #' - `n` for notes
    #' - `o` for ORCIDs
    #'
    #' The order of the keys determines the order of symbol types. E.g. `"ac"`
    #' shows affiliation ids first and corresponding author mark second, when
    #' `"ca"` shows corresponding author mark first and affiliation ids second.
    #' Use `","` to separate and `"^"` to superscript symbols.
    #' `format = NULL` lists author names without suffixes.
    #' @return A character vector.
    get_author_list = function(format = NULL) {
      check_suffix_format(format, allowed = c("a", "c", "n", "o", "^", ","))
      authors <- private$get("literal_name")
      if (is_empty(format)) {
        return(authors)
      }
      suffixes <- private$get_author_list_suffixes(format)
      paste0(authors, suffixes)
    },

    #' @description Get authors' affiliations.
    #' @param sep Separator used to separate affiliation ids and affiliations.
    #' @param superscript Should affiliation ids be superscripted?
    #' @return A character vector.
    get_affiliations = function(sep = "", superscript = TRUE) {
      private$get_footnotes("affiliation", sep, superscript)
    },

    #' @description Get authors' notes.
    #' @param sep Separator used to separate note ids and notes.
    #' @param superscript Should note ids be superscripted?
    #' @return A character vector.
    get_notes = function(sep = "", superscript = TRUE) {
      private$get_footnotes("note", sep, superscript)
    },

    #' @description Get the contact details of corresponding authors.
    #' @param format A [`glue`][glue::glue()] specification that uses the
    #'   variables `name` and `details`.
    #' @param email,number,fax,url Arguments equal to `TRUE` are evaluated and
    #'   passed to the variable `details`. By default, only `email` is set to
    #'   `TRUE`.
    #' @param sep Separator used to separate `details` items.
    #' @return A character vector.
    get_contact_details = function(
        format = "{name}: {details}",
        email = TRUE,
        number = FALSE,
        fax = FALSE,
        url = FALSE,
        sep = ", "
    ) {
      check_glue(format, allowed = c("name", "details"))
      check_args("bool", list(email, number, fax, url))
      check_string(sep, allow_empty = FALSE)
      corresponding <- self$names$corresponding
      private$check_col(corresponding, bullets = c(
        i = "Did you forget to assign corresponding authors?",
        i = "Use `set_corresponding_authors()` to set corresponding authors."
      ))
      args <- arg_names_true()
      if (is_empty(args)) {
        return()
      }
      cols <- private$get_names(args, use_keys = FALSE)
      private$check_col(cols)
      out <- filter(self$plume, corresponding & not_na_any(cols))
      dict <- list(details = cols, name = self$names$literal_name)
      dissolve(out, dict, partial(collapse_cols, sep = sep))
      glue(format)
    },

    #' @description Get authors' contributions.
    #' @param role_first If `TRUE`, displays contribution roles first and authors
    #'   second. If `FALSE`, roles follow authors.
    #' @param name_list Should all authors with the same role be listed together?
    #'   Only applies when `role_first = FALSE`.
    #' @param alphabetical_order Should authors be listed in alphabetical order?
    #'   By default, lists authors in the order they are defined.
    #' @param dotted_initials Should initials be dot-separated?
    #' @param literal_names Should literal names be used?
    #' @param divider Separator used to separate contribution items and authors
    #'   when `name_list = FALSE`. By default, uses `": "`.
    #' @param sep_last Separator used to separate the last two roles or authors
    #'   if more than one item is associated to a role or author.
    #' @return A character vector.
    get_contributions = function(
        role_first = TRUE,
        name_list = FALSE,
        alphabetical_order = FALSE,
        dotted_initials = TRUE,
        literal_names = FALSE,
        divider = NULL,
        sep_last = NULL
    ) {
      contribution <- self$names$contribution
      private$check_col(contribution)
      check_args("bool", list(
        role_first,
        name_list,
        alphabetical_order,
        dotted_initials,
        literal_names
      ))
      check_args("string", list(sep_last, divider), allow_null = TRUE)
      out <- unnest_drop(self$plume, contribution)
      if (is_empty(out)) {
        return()
      }
      initials <- self$names$initials
      has_initials <- private$has_col(initials)
      if (!has_initials || literal_names) {
        authors <- self$names$literal_name
      } else {
        authors <- initials
      }
      pars <- private$contribution_pars(role_first, name_list, authors, divider)
      if (has_initials && dotted_initials && !literal_names) {
        out <- mutate(out, !!authors := dot(.data[[authors]]))
      }
      if (alphabetical_order) {
        out <- arrange(out, .data[[pars$var]])
      }
      sep_last <- sep_last %||% " and "
      out <- summarise(out, !!pars$var := enumerate(
        .data[[pars$var]],
        last = sep_last
      ), .by = all_of(pars$grp_var))
      out <- collapse_cols(out, pars$format, sep = pars$divider)
      plm_obj(out, name = "contributions")
    }
  ),

  private = list(
    set_status = function(col, ..., by) {
      if (missing(by)) {
        by <- self$by
      } else {
        check_string(by, allow_empty = FALSE)
      }
      private$check_col(by)
      if (are_dots_all(...)) {
        value <- TRUE
      } else {
        value <- expr(true_if(includes(.data[[by]], exprs(...))))
      }
      self$plume <- mutate(self$plume, !!self$names[[col]] := !!value)
      invisible(self)
    },

    get_author_list_suffixes = function(format) {
      dict <- get_key_dict(format)
      vars <- private$get_names(dict)
      cols <- unname(vars)
      private$check_col(cols)
      out <- unnest(self$plume, cols = all_of(cols))
      out <- add_group_ids(out, vars)
      symbols <- list_assign(self$symbols, orcid = self$names$orcid)
      out <- set_suffixes(out, vars, symbols)
      grp_vars <- private$get_names("id", "literal_name", use_keys = FALSE)
      .cols <- predot(cols)
      out <- summarise(out, across(all_of(.cols), bind), .by = all_of(grp_vars))
      als_make(out, .cols, format)
    },

    get_footnotes = function(var, sep, superscript) {
      col <- self$names[[var]]
      private$check_col(col)
      check_string(sep)
      check_bool(superscript)
      out <- unnest_drop(self$plume, col)
      if (is_empty(out)) {
        return()
      }
      out <- add_group_ids(out, col)
      .col <- predot(col)
      out <- set_symbols(out, .col, self$symbols[[var]])
      out <- distinct(out, .data[[col]], .data[[.col]])
      if (superscript) {
        out <- mutate(out, !!.col := wrap(.data[[.col]], "^"))
      }
      collapse_cols(out, c(.col, col), sep)
    },

    contribution_pars = function(role_first, name_list, authors, divider) {
      if (!role_first && name_list) {
        divider <- " "
      } else {
        divider <- divider %||% ": "
      }
      contribution <- self$names$contribution
      format <- c(contribution, authors)
      if (!role_first) {
        format <- rev(format)
      }
      if (role_first || name_list) {
        grp_var <- contribution
        var <- authors
      } else {
        grp_var <- authors
        var <- contribution
      }
      list(divider = divider, grp_var = grp_var, var = var, format = format)
    }
  )
)


get_key_dict <- function(format) {
  dict <- list(
    a = "affiliation",
    c = "corresponding",
    n = "note",
    o = "orcid"
  )
  keys <- als_extract_keys(format)
  dict[keys]
}
