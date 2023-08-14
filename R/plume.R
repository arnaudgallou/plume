default_symbols <- list(
  affiliation = NULL,
  corresponding = "\\*",
  note = c("\u2020", "\u2021", "\u00a7", "\u00b6", "\u0023", "\\*\\*")
)

#' @title Plume class
#' @description Class that generates author lists and other author-related
#'   information as character strings.
#' @export
Plume <- R6Class(
  classname = "Plume",
  inherit = StatusSetter,
  public = list(
    #' @description Create a `Plume` object.
    #' @param data A data frame or tibble containing author-related data.
    #' @param names A vector of column names.
    #' @param symbols A list of keys and values defining the symbols used to
    #'   link authors to metadata. Valid keys are `"affiliation"`,
    #'   `"corresponding"` and `"note"`. By default, uses digits for
    #'   affiliations, `"*"` for corresponding authors and `"†"`, `"‡"`, `"§"`,
    #'   `"¶"`, `"#"`, `"**"` for notes. Set a key to `NULL` to use numerals.
    #' @param credit_roles Should the `r link("crt")` be used?
    #' @param initials_given_name Should the initials of given names be used?
    #' @param family_name_first Should literal names show family names first.
    #' @param interword_spacing Should literal names use spacing? This parameter
    #'   is only useful for people writing in languages that don't separate
    #'   words with a space such as Chinese or Japanese.
    #' @param orcid_icon The ORCID icon, as defined by [`orcid()`], to be used.
    #' @return A `Plume` object.
    initialize = function(
        data,
        names = NULL,
        symbols = NULL,
        credit_roles = FALSE,
        initials_given_name = FALSE,
        family_name_first = FALSE,
        interword_spacing = TRUE,
        orcid_icon = orcid()
    ) {
      super$initialize(
        data,
        names,
        credit_roles,
        initials_given_name,
        family_name_first,
        interword_spacing
      )
      check_list(symbols, force_names = TRUE)
      check_orcid_icon(orcid_icon)
      if (!is.null(symbols)) {
        private$symbols <- list_replace(private$symbols, symbols)
      }
      private$orcid_icon <- structure(orcid_icon, var = private$pick("orcid"))
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
        out <- authors
      } else {
        suffixes <- private$get_author_list_suffixes(format)
        out <- paste0(authors, suffixes)
      }
      as_plm(out)
    },

    #' @description Get authors' ORCID.
    #' @param compact Should links only display the 16-digit identifier?
    #' @param icon Should the ORCID icon be shown?
    #' @param sep Separator used to separate authors and their respective ORCID.
    #' @return Authors' name followed by their respective ORCID.
    get_orcids = function(compact = FALSE, icon = TRUE, sep = "") {
      check_args("bool", list(compact, icon))
      check_string(sep)
      vars <- private$pick("orcid", "literal_name", squash = FALSE)
      private$check_col(vars$orcid)
      out <- drop_na(private$plume, vars$orcid)
      if (icon) {
        out <- add_orcid_icons(out, private$orcid_icon)
      }
      out <- add_orcid_links(out, vars$orcid, compact)
      cols <- c(vars$literal_name, predot(vars$orcid))
      out <- collapse_cols(out, cols, sep)
      as_plm(out)
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
    #' @param email,phone,fax,url Arguments equal to `TRUE` are evaluated and
    #'   passed to the variable `details`. By default, only `email` is set to
    #'   `TRUE`.
    #' @param sep Separator used to separate `details` items.
    #' @return A character vector.
    get_contact_details = function(
        format = "{details} ({name})",
        email = TRUE,
        phone = FALSE,
        fax = FALSE,
        url = FALSE,
        sep = ", "
    ) {
      check_glue(format, allowed = c("name", "details"))
      check_args("bool", list(email, phone, fax, url))
      check_string(sep, allow_empty = FALSE)
      vars <- private$pick("corresponding", "literal_name", squash = FALSE)
      private$check_col(vars$corresponding, bullets = c(
        i = "Did you forget to assign corresponding authors?",
        i = "Use `set_corresponding_authors()` to set corresponding authors."
      ))
      args <- arg_names_true()
      if (is_empty(args)) {
        return()
      }
      cols <- private$pick(args)
      private$check_col(cols)
      out <- filter(
        private$plume,
        .data[[vars$corresponding]] & not_na_any(cols)
      )
      dict <- list(details = cols, name = vars$literal_name)
      dissolve(out, dict, partial(collapse_cols, sep = sep))
      as_plm(glue(format))
    },

    #' @description Get authors' contributions.
    #' @param roles_first If `TRUE`, displays roles first and authors second. If
    #'   `FALSE`, roles follow authors.
    #' @param by_author Should roles be grouped by author?
    #' @param alphabetical_order Should authors be listed in alphabetical order?
    #'   By default, lists authors in the order they are defined.
    #' @param dotted_initials Should initials be dot-separated?
    #' @param literal_names Should literal names be used?
    #' @param divider Separator used to separate roles and authors. Uses `": "`
    #'   by default.
    #' @param sep_last Separator used to separate the last two roles or authors
    #'   if more than one item is associated to a role or author.
    #' @return A character vector.
    get_contributions = function(
        roles_first = TRUE,
        by_author = FALSE,
        alphabetical_order = FALSE,
        dotted_initials = TRUE,
        literal_names = FALSE,
        divider = ": ",
        sep_last = " and "
    ) {
      role <- private$pick("role")
      private$check_col(role)
      check_args("bool", list(
        roles_first,
        by_author,
        alphabetical_order,
        dotted_initials,
        literal_names
      ))
      check_args("string", list(divider, sep_last))
      out <- unnest_drop(private$plume, role)
      if (is_empty(out)) {
        return()
      }
      pars <- private$contribution_pars(roles_first, by_author, literal_names)
      if (pars$has_initials && dotted_initials && !literal_names) {
        out <- mutate(out, !!pars$author := dot(.data[[pars$author]]))
      }
      out <- summarise(out, !!pars$var := enumerate(
        if (!by_author && alphabetical_order) {
          sort(.data[[pars$var]])
        } else {
          .data[[pars$var]]
        },
        last = sep_last
      ), .by = all_of(pars$grp_var))
      out <- collapse_cols(out, pars$format, sep = divider)
      as_plm(out)
    }
  ),

  private = list(
    symbols = default_symbols,
    orcid_icon = NULL,

    get_author_list_suffixes = function(format) {
      key_set <- get_key_set(format)
      vars <- unlist(private$pick(key_set, squash = FALSE))
      cols <- unname(vars)
      private$check_col(cols)
      out <- unnest(private$plume, cols = all_of(cols))
      out <- add_group_ids(out, vars)
      symbols <- list_assign(private$symbols, orcid = private$orcid_icon)
      out <- add_suffixes(out, vars, symbols)
      grp_vars <- private$pick("id", "literal_name")
      .cols <- predot(cols)
      out <- summarise(out, across(all_of(.cols), bind), .by = all_of(grp_vars))
      als_make(out, .cols, format)
    },

    get_footnotes = function(var, sep, superscript) {
      col <- private$pick(var)
      private$check_col(col)
      check_string(sep)
      check_bool(superscript)
      out <- unnest_drop(private$plume, col)
      if (is_empty(out)) {
        return()
      }
      out <- add_group_ids(out, col)
      .col <- predot(col)
      out <- add_symbols(out, .col, private$symbols[[var]])
      out <- distinct(out, .data[[col]], .data[[.col]])
      if (superscript) {
        out <- mutate(out, !!.col := wrap(.data[[.col]], "^"))
      }
      out <- collapse_cols(out, c(.col, col), sep)
      as_plm(out)
    },

    contribution_pars = function(roles_first, by_author, literal_names) {
      vars <- private$pick(
        "initials", "literal_name", "role", "id",
        squash = FALSE
      )
      has_initials <- private$has_col(vars$initials)
      if (!has_initials || literal_names) {
        author <- vars$literal_name
      } else {
        author <- vars$initials
      }
      format <- c(vars$role, author)
      if (!roles_first) {
        format <- rev(format)
      }
      if (by_author) {
        grp_var <- c(author, vars$id)
        var <- vars$role
      } else {
        grp_var <- vars$role
        var <- author
      }
      list(
        has_initials = has_initials,
        author = author,
        grp_var = grp_var,
        var = var,
        format = format
      )
    }
  )
)

get_key_set <- function(format) {
  set <- c(
    a = "affiliation",
    c = "corresponding",
    n = "note",
    o = "orcid"
  )
  keys <- als_extract_keys(format)
  set[keys]
}
