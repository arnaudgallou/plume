.names_plume <- list_modify(
  .names,
  internals = list(contributor_rank = "contributor_rank")
)

.symbols <- list(
  affiliation = NULL,
  corresponding = "\\*",
  note = c("\u2020", "\u2021", "\u00a7", "\u00b6", "\u0023", "\\*\\*")
)

#' @title Plume class
#' @description Class that generates author lists and other author-related
#'   information as character strings.
#' @examples
#' # Create a Plume instance
#' aut <- Plume$new(encyclopedists)
#'
#' # Set the desired corresponding authors, using
#' # authors' id by default
#' aut$set_corresponding_authors(1, 4)
#'
#' # Getting authors suffixed by affiliation ids
#' # and the corresponding author mark:
#' aut$get_author_list("^a,c^")
#'
#' # Or maybe with the corresponding author mark
#' # coming before affiliation ids:
#' aut$get_author_list("^c,a^")
#'
#' # Getting more author metadata
#' aut$get_affiliations()
#'
#' aut$get_contributions()
#'
#' # Use `symbols` to change the default symbols.
#' # E.g. to use letters as affiliation ids:
#' aut <- Plume$new(
#'   encyclopedists,
#'   symbols = list(affiliation = letters)
#' )
#'
#' aut$get_author_list("^a^")
#'
#' aut$get_affiliations()
#'
#' # It is also possible to output contributions in the
#' # active voice
#' aut <- Plume$new(encyclopedists, roles = c(
#'   supervision = "supervised the project",
#'   writing = "contributed to the Encyclopédie"
#' ))
#' aut$get_contributions(roles_first = FALSE, divider = " ")
#' @export
Plume <- R6Class(
  classname = "Plume",
  inherit = StatusSetterPlume,
  public = list(
    #' @description Create a `Plume` object.
    #' @param data A data frame containing author-related data.
    #' @param names A vector of key-value pairs specifying custom names to use,
    #'   where keys are default names and values their respective replacements.
    #' @param symbols A list of key-value pairs defining the symbols to use to
    #'   link authors and their metadata. Valid keys are `"affiliation"`,
    #'   `"corresponding"` and `"note"`. By default, uses digits for
    #'   affiliations, `"*"` for corresponding authors and `"†"`, `"‡"`, `"§"`,
    #'   `"¶"`, `"#"`, `"**"` for notes. Set a key to `NULL` to use numerals.
    #' @param roles A vector of key-value pairs defining roles where keys
    #'   identify role columns and values describe the actual roles to use.
    #' @param credit_roles `r lifecycle::badge("deprecated")`
    #'
    #'   It is now recommended to use `roles = credit_roles()` to use the
    #'   `r link("crt")`.
    #' @param initials_given_name Should the initials of given names be used?
    #' @param dotted_initials Should initials be dot-separated?
    #' @param family_name_first Should literal names show family names first?
    #' @param distinct_initials If `TRUE`, will expand identical initials with
    #'   additional letters from their respective family name until initials are
    #'   unique. Initials of authors sharing the exact same name will remain in
    #'   the short form.
    #' @param interword_spacing Should literal names use spacing? This parameter
    #'   is only useful for people writing in languages that don't separate
    #'   words with a space such as Chinese or Japanese.
    #' @param orcid_icon The ORCID icon, as defined by [`icn_orcid()`], to be used.
    #' @param by A character string defining the default variable used to assign
    #'   specific metadata to authors in all `set_*()` methods. By default, uses
    #'   authors' id.
    #' @return A `Plume` object.
    initialize = function(
      data,
      names = NULL,
      symbols = NULL,
      roles = credit_roles(),
      credit_roles = FALSE,
      initials_given_name = FALSE,
      dotted_initials = TRUE,
      family_name_first = FALSE,
      distinct_initials = FALSE,
      interword_spacing = TRUE,
      orcid_icon = icn_orcid(),
      by = NULL
    ) {
      super$initialize(
        data,
        names,
        roles,
        credit_roles,
        initials_given_name,
        dotted_initials,
        family_name_first,
        distinct_initials,
        interword_spacing,
        by = by
      )
      check_list(symbols, allow("null"))
      check_orcid_icon(orcid_icon)
      if (!is.null(symbols)) {
        private$symbols <- list_replace(private$symbols, symbols)
      }
      private$orcid_icon <- orcid_icon
    },

    #' @description Get author list.
    #' @param suffix A character string defining the format of symbols suffixing
    #'   author names. See details.
    #' @param format `r lifecycle::badge("deprecated")`
    #'
    #'   Please use the parameter `suffix` instead.
    #' @details
    #' `suffix` lets you choose which symbol categories to suffix authors with,
    #' using the following keys:
    #' * `a` for affiliations
    #' * `c` for corresponding authors
    #' * `n` for notes
    #' * `o` for ORCIDs
    #'
    #' The order of the keys determines the order of symbol types. E.g. `"ac"`
    #' shows affiliation ids first and corresponding author mark second, when
    #' `"ca"` shows corresponding author mark first and affiliation ids second.
    #' Use `","` to separate and `"^"` to superscript symbols.
    #' Use `NULL` or an empty string to list author names without suffixes.
    #' @return A character vector.
    get_author_list = function(suffix = NULL, format = deprecated()) {
      if (lifecycle::is_present(format)) {
        lifecycle::deprecate_stop(
          "0.2.1",
          "get_author_list(format)",
          "get_author_list(suffix)"
        )
      }
      authors <- private$pull("literal_name")
      if (is_empty(suffix)) {
        out <- authors
      } else {
        suffixes <- private$get_author_list_suffixes(suffix)
        out <- paste0(authors, suffixes)
      }
      as_plm(out)
    },

    #' @description Get authors' affiliations.
    #' @param superscript Should affiliation ids be superscripted?
    #' @param sep Separator used to separate affiliation ids and affiliations.
    #' @return A character vector.
    get_affiliations = function(superscript = TRUE, sep = "") {
      private$get_footnotes("affiliation", superscript, sep)
    },

    #' @description Get authors' notes.
    #' @param superscript Should note ids be superscripted?
    #' @param sep Separator used to separate note ids and notes.
    #' @return A character vector.
    get_notes = function(superscript = TRUE, sep = "") {
      private$get_footnotes("note", superscript, sep)
    },

    #' @description Get authors' ORCID.
    #' @param compact Should links only display the 16-digit identifier?
    #' @param icon Should the ORCID icon be shown?
    #' @param sep Separator used to separate authors and their respective ORCID.
    #' @return A character vector.
    get_orcids = function(compact = FALSE, icon = TRUE, sep = "") {
      check_args("bool", quos(compact, icon))
      check_string(sep, allow("empty"))
      col <- private$pick("orcid")
      private$check_col(col)
      out <- drop_na(private$plume, all_of(col))
      if (icon) {
        out <- add_orcid_icons(out, col, private$orcid_icon)
      }
      out <- add_orcid_links(out, col, compact)
      cols <- c(private$pick("literal_name"), predot(col))
      out <- collapse_cols(out, cols, sep)
      as_plm(out)
    },

    #' @description Get the contact details of corresponding authors.
    #' @param template A [`glue`][glue::glue()] specification that uses the
    #'   variables `name` and/or `details`.
    #' @param format `r lifecycle::badge("deprecated")`
    #'
    #' Please use the parameter `template` instead.
    #' @param email,phone,fax,url Arguments equal to `TRUE` are evaluated and
    #'   passed to the variable `details`. By default, only `email` is set to
    #'   `TRUE`.
    #' @param sep Separator used to separate `details` items.
    #' @return A character vector.
    get_contact_details = function(
      template = "{details} ({name})",
      email = TRUE,
      phone = FALSE,
      fax = FALSE,
      url = FALSE,
      sep = ", ",
      format = deprecated()
    ) {
      if (lifecycle::is_present(format)) {
        lifecycle::deprecate_warn(
          "0.2.6",
          "get_contact_details(format)",
          "get_contact_details(template)"
        )
        template <- format
      }
      check_glue(template, vars = c("name", "details"))
      check_args("bool", quos(email, phone, fax, url))
      check_string(sep)
      vars <- private$pick("corresponding", "literal_name", squash = FALSE)
      private$check_col(vars["corresponding"])
      details <- get_detail_vars()
      if (is_empty(details)) {
        return()
      }
      cols <- private$pick(details)
      private$check_col(cols)
      data <- filter(private$plume, .data[[vars$corresponding]] & !all_na(cols))
      dict <- list(details = cols, name = vars$literal_name)
      items <- map(dict, \(item) collapse_cols(data, item, sep))
      as_plm(glue::glue_data(items, template))
    },

    #' @description Get authors' contributions.
    #' @param roles_first If `TRUE`, displays roles first and authors second. If
    #'   `FALSE`, roles follow authors.
    #' @param by_author Should roles be grouped by author?
    #' @param alphabetical_order Should authors be listed in alphabetical order?
    #'   By default, lists authors in the order they are defined in the data.
    #' @param dotted_initials `r lifecycle::badge("deprecated")`
    #'
    #' Please use the `dotted_initials` parameter of `Plume$new()` instead.
    #' @param literal_names Should literal names be used?
    #' @param divider Separator used to separate roles from authors.
    #' @param sep Separator used to separate roles or authors.
    #' @param sep_last Separator used to separate the last two roles or authors
    #'   if more than one item is associated to a role or author.
    #' @return A character vector.
    get_contributions = function(
      roles_first = TRUE,
      by_author = FALSE,
      alphabetical_order = FALSE,
      literal_names = FALSE,
      divider = ": ",
      sep = ", ",
      sep_last = " and ",
      dotted_initials = deprecated()
    ) {
      if (lifecycle::is_present(dotted_initials)) {
        lifecycle::deprecate_warn(
          "0.3.0",
          "get_contributions(dotted_initials)",
          "Plume$new(dotted_initials)"
        )
      }
      role <- private$pick("role")
      private$check_col(role)
      check_args("bool", quos(
        roles_first,
        by_author,
        alphabetical_order,
        literal_names
      ))
      check_args(
        "string",
        quos(divider, sep, sep_last),
        allow("empty", "unnamed")
      )
      out <- unnest_drop_na(private$plume, role)
      if (is_empty(out)) {
        return()
      }
      pars <- private$contribution_pars(roles_first, by_author, literal_names)
      out <- summarise(out, !!pars$var := enumerate(
        contribution_items(pars, by_author, alphabetical_order),
        sep = sep,
        last = sep_last
      ), .by = all_of(pars$grp_var))
      if (are_credit_roles(private$.roles) && !by_author) {
        out <- arrange(out, role)
      }
      out <- collapse_cols(out, pars$format, sep = divider)
      as_plm(out)
    }
  ),

  private = list(
    names = .names_plume,
    symbols = .symbols,
    orcid_icon = NULL,

    get_author_list_suffixes = function(template) {
      check_als_template(template, arg = "suffix")
      key_set <- als_key_set(template)
      vars <- private$pick(key_set, squash = FALSE)
      private$check_col(vars)
      cols <- squash(vars)
      out <- unnest(private$plume, cols = all_of(cols))
      out <- add_group_ids(out, vars)
      symbols <- list_assign(private$symbols, orcid = private$orcid_icon)
      out <- add_suffixes(out, vars, symbols)
      grp_vars <- private$pick("id", "literal_name")
      .cols <- predot(cols)
      out <- summarise(out, across(all_of(.cols), bind), .by = all_of(grp_vars))
      als_make(out, .cols, template)
    },

    get_footnotes = function(var, superscript, sep) {
      col <- private$pick(var)
      private$check_col(col)
      check_bool(superscript)
      check_string(sep, allow("null", "empty"))
      out <- unnest_drop_na(private$plume, col)
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
        "initials", "literal_name", "role", "id", "contributor_rank",
        squash = FALSE
      )
      if (!private$has_col(vars$initials) || literal_names) {
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
        grp_var = grp_var,
        rank = vars$contributor_rank,
        var = var,
        format = format
      )
    }
  )
)

contribution_items <- function(pars, by_author, alphabetical_order) {
  data <- dplyr::pick(any_of(c(pars$var, pars$rank)))
  cols <- c(
    if (has_name(data, pars$rank)) pars$rank,
    if (alphabetical_order) pars$var
  )
  if (!is.null(cols) && !by_author) {
    data <- arrange(data, across(any_of(cols)))
  }
  data[[pars$var]]
}
