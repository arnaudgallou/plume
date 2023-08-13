.names_quarto <- list_modify(.names, public = list(
  internals = list(
    deceased = "deceased",
    equal_contributor = "equal_contributor"
  ),
  secondaries = list(
    number = "number",
    dropping_particle = "dropping_particle",
    acknowledgements = "acknowledgements"
  )
))

#' @title PlumeQuarto class
#' @description Class that pushes or updates author metadata in a Quarto file.
#' @export
PlumeQuarto <- R6Class(
  classname = "PlumeQuarto",
  inherit = StatusSetterQuarto,
  public = list(
    #' @description Create a `PlumeQuarto` object.
    #' @param data A data frame or tibble containing author-related data.
    #' @param names A vector of column names.
    #' @param credit_roles Should the `r link("crt")` be used?
    #' @param initials_given_name Should the initials of given names be used?
    #' @param by A character string defining the default variable used to assign
    #'   authors' status in all `set_*` methods. By default, uses authors' id.
    #' @return A `PlumeQuarto` object.
    initialize = function(
        data,
        names = NULL,
        credit_roles = FALSE,
        initials_given_name = FALSE,
        by = NULL
    ) {
      super$initialize(data, names, credit_roles, initials_given_name, by)
    },

    #' @description Push or update author information in a YAML header. The
    #'   generated YAML complies with Quarto's author and affiliations
    #'   [schemas](https://quarto.org/docs/journals/authors.html).
    #' @param file A `.qmd` file.
    #' @details
    #' If missing, `to_yaml()` pushes author information into a YAML header. If
    #' already existing, the function replaces old `author` and `affiliations`
    #' values with the ones provided in the input data.
    #' @return The input `file` invisibly.
    to_yaml = function(file) {
      check_file(file, extension = "qmd")
      yaml_push(file, what = private$get_template())
    }
  ),

  private = list(
    plume_names = .names_quarto,
    meta_prefix = "meta-",

    mold = function(...) {
      super$mold(starts_with(private$meta_prefix), ...)
    },

    get_template = function() {
      list(
        author = private$author_tbl(),
        affiliations = private$affiliation_tbl()
      )
    },

    author_tbl = function() {
      tibble(
        id = paste0("aut", private$get("id")),
        number = private$get("number"),
        name = tibble(
          given = private$get("given_name"),
          family = private$get("family_name"),
          `dropping-particle` = private$get("dropping_particle")
        ),
        orcid = private$get("orcid"),
        email = private$get("email"),
        phone = private$get("phone"),
        fax = private$get("fax"),
        url = private$get("url"),
        roles = private$author_roles(),
        note = private$author_notes(),
        acknowledgements = private$get("acknowledgements"),
        attributes = private$author_attributes(),
        affiliations = private$author_affiliations(),
        metadata = private$author_metadata()
      )
    },

    author_roles = function() {
      col <- private$pick("role")
      if (!private$has_col(col)) {
        return()
      }
      out <- unnest_drop(private$plume, cols = all_of(col))
      out <- summarise(
        out,
        `_` = list(tolower(.data[[col]])),
        .by = all_of(private$pick("id"))
      )
      out[["_"]]
    },

    author_notes = function() {
      col <- private$pick("note")
      if (!private$has_col(col)) {
        return()
      }
      if (!is_nested(private$plume, col)) {
        return(private$get("note"))
      }
      out <- unnest(private$plume, cols = all_of(col))
      out <- summarise(out, `_` = if_not_na(
        .data[[col]],
        bind(.data[[col]], sep = ", ", arrange = FALSE),
        all = TRUE
      ), .by = all_of(private$pick("id")))
      out[["_"]]
    },

    author_attributes = function() {
      out <- tibble(
        corresponding = private$get("corresponding"),
        deceased = private$get("deceased"),
        `equal-contributor` = private$get("equal_contributor")
      )
      if (!is_empty(out)) {
        out
      }
    },

    author_affiliations = function() {
      col <- private$pick("affiliation")
      if (!private$has_col(col)) {
        return()
      }
      .col <- predot(col)
      out <- unnest(private$plume, cols = all_of(col))
      out <- add_group_ids(out, col)
      out <- mutate(out, !!.col := if_not_na(
        .data[[.col]],
        paste0("aff", .data[[.col]])
      ))
      out <- summarise(out, `_` = list(
        tibble(ref = sort(!!sym(.col)))
      ), .by = all_of(private$pick("id")))
      out[["_"]]
    },

    author_metadata = function() {
      if (private$has_col(paste0("^", private$meta_prefix))) {
        select(private$plume, starts_with(private$meta_prefix))
      }
    },

    affiliation_tbl = function() {
      affiliations <- private$get("affiliation")
      if (is.null(affiliations)) {
        return()
      }
      affiliations <- condense(affiliations)
      if (!any(has_affiliation_sep(affiliations))) {
        ids <- make_affiliation_id(affiliations)
        return(tibble(id = ids, name = affiliations))
      }
      out <- map(affiliations, \(affiliation) {
        as_tibble_row(parse_affiliation(affiliation))
      })
      out <- list_rbind(out, names_to = "id")
      out <- mutate(out, id = make_affiliation_id(id))
      if (!is_empty(out)) {
        out
      }
    }
  )
)

affiliation_keys <- c(
    "number", "name", "department", "address", "city", "region",
    "country", "postal-code", "url", "isni", "ringgold", "ror"
  )

parse_affiliation <- function(x) {
  if (!has_affiliation_sep(x)) {
    return(set_names(x, "name"))
  }
  keys <- collapse(affiliation_keys, sep = "|")
  keys_regex <- paste0("\\b(?:", keys, ")")
  nms <- string_extract_all(x, paste0(keys_regex, "(?==)"))
  els <- string_split(x, paste0(keys_regex, "="))[-1]
  set_names(string_trim(els), tolower(nms))
}

make_affiliation_id <- function(x) {
  paste0("aff", seq_along(x))
}

has_affiliation_sep <- function(x) {
  string_contain(x, "=")
}