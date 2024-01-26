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
#' @description Class that pushes author metadata in the YAML header
#'   of Quarto files.
#' @examples
#' # Create a simple temporary file with a YAML header
#' # containing a title
#' tmp_file <- tempfile(fileext = ".qmd")
#' readr::write_lines("---\ntitle: Encyclopédie\n---", tmp_file)
#'
#' # View the temporary file
#' cat(readr::read_file(tmp_file))
#'
#' # Create a PlumeQuarto instance using the temporary file
#' # you've just created
#' aut <- PlumeQuarto$new(
#'   encyclopedists,
#'   file = tmp_file
#' )
#'
#' # And push author data to the YAML header
#' aut$to_yaml()
#'
#' cat(readr::read_file(tmp_file))
#'
#' # Pushing again with new data updates the YAML
#' # header accordingly
#' aut <- PlumeQuarto$new(
#'   dplyr::slice(encyclopedists, 2),
#'   file = tmp_file
#' )
#' aut$to_yaml()
#'
#' cat(readr::read_file(tmp_file))
#'
#' # Clean up the temporary file
#' unlink(tmp_file)
#' @export
PlumeQuarto <- R6Class(
  classname = "PlumeQuarto",
  inherit = StatusSetterPlumeQuarto,
  public = list(
    #' @description Create a `PlumeQuarto` object.
    #' @param data A data frame containing author-related data.
    #' @param file A `.qmd` file to insert author data into.
    #' @param names A vector of key-value pairs specifying custom names to use,
    #'   where keys are default names and values their respective replacements.
    #' @param roles A vector of key-value pairs defining roles where keys
    #'   identify columns and values describe the actual roles to use.
    #' @param credit_roles `r lifecycle::badge("deprecated")`
    #'
    #'   It is now recommended to use `roles = credit_roles()` to use the
    #'   `r link("crt")`.
    #' @param initials_given_name Should the initials of given names be used?
    #' @param by A character string defining the default variable used to assign
    #'   specific metadata to authors in all `set_*()` methods. By default, uses
    #'   authors' id.
    #' @return A `PlumeQuarto` object.
    initialize = function(
        data,
        file,
        names = NULL,
        roles = credit_roles(),
        credit_roles = FALSE,
        initials_given_name = FALSE,
        by = NULL
    ) {
      check_file(file, extension = "qmd")
      super$initialize(data, names, roles, credit_roles, initials_given_name, by = by)
      private$file <- file
      private$id <- private$pick("id")
    },

    #' @description Push or update author information in a YAML header. The
    #'   generated YAML complies with Quarto's `r link("quarto_schemas")`.
    #' @details
    #' If missing, `to_yaml()` pushes author information into a YAML header. If
    #' already existing, the function replaces old `author` and `affiliations`
    #' values with the ones provided in the input data.
    #' @return The input `file` invisibly.
    to_yaml = function() {
      yaml_push(private$get_template(), file = private$file)
    }
  ),

  private = list(
    file = NULL,
    plume_names = .names_quarto,
    meta_prefix = "meta-",
    id = NULL,

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
        id = private$author_ids(),
        number = private$get("number"),
        name = tibble(
          given = private$get("given_name"),
          family = private$get("family_name"),
          `dropping-particle` = private$get("dropping_particle")
        ),
        url = private$get("url"),
        email = private$get("email"),
        phone = private$get("phone"),
        fax = private$get("fax"),
        orcid = private$author_orcid(),
        note = private$author_notes(),
        acknowledgements = private$get("acknowledgements"),
        attributes = private$author_attributes(),
        roles = private$author_roles(),
        metadata = private$author_metadata(),
        affiliations = private$author_affiliations()
      )
    },

    author_ids = function() {
      ids <- private$get("id")
      if (length(ids) == 1L) {
        return()
      }
      paste0("aut", ids)
    },

    author_orcid = function() {
      out <- private$get("orcid")
      if (!is.null(out)) {
        check_orcid(out)
      }
      out
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
        .by = all_of(private$id)
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
      ), .by = all_of(private$id))
      out[["_"]]
    },

    author_attributes = function() {
      out <- tibble(
        corresponding = private$get("corresponding"),
        deceased = private$get("deceased"),
        `equal-contributor` = private$get("equal_contributor")
      )
      if (is_empty(out)) {
        return()
      }
      out
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
      ), .by = all_of(private$id))
      out[["_"]]
    },

    author_metadata = function() {
      if (!private$has_col(begins_with(private$meta_prefix))) {
        return()
      }
      select(private$plume, starts_with(private$meta_prefix))
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
      if (is_empty(out)) {
        return()
      }
      out
    }
  )
)

affiliation_keys <- c(
  "number", "name", "department", "address", "city", "region", "state",
  "country", "postal-code", "url", "isni", "ringgold", "ror"
)

parse_affiliation <- function(x) {
  if (!has_affiliation_sep(x)) {
    return(set_names(x, "name"))
  }
  keys <- collapse(affiliation_keys, sep = "|")
  keys_regex <- paste0("\\b(?i:", keys, ")")
  nms <- str_extract_all(x, sprintf("%s(?==)", keys_regex), simplify = TRUE)
  els <- str_split_1(x, sprintf("\\s*%s=\\s*", keys_regex))[-1]
  set_names(els, tolower(nms))
}

make_affiliation_id <- function(x) {
  paste0("aff", seq_along(x))
}

has_affiliation_sep <- function(x) {
  str_contain(x, "=")
}
