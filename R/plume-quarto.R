.names_quarto <- list_modify(
  .names,
  internals = list(
    deceased = "deceased",
    equal_contributor = "equal_contributor"
  ),
  secondaries = list(
    number = "number",
    dropping_particle = "dropping_particle",
    acknowledgements = "acknowledgements"
  ),
  nestables = list(
    degree = "degree"
  )
)

#' @title PlumeQuarto class
#' @description Class that pushes author metadata in YAML files or the YAML
#'   header of Quarto files.
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
    #' @param file A `.qmd`, `.yml` or `.yaml` file to insert author data into.
    #' @param names A vector of key-value pairs specifying custom names to use,
    #'   where keys are default names and values their respective replacements.
    #' @param roles A vector of key-value pairs defining roles where keys
    #'   identify columns and values describe the actual roles to use.
    #' @param credit_roles `r lifecycle::badge("deprecated")`
    #'
    #'   It is now recommended to use `roles = credit_roles()` to use the
    #'   `r link("crt")`.
    #' @param initials_given_name Should the initials of given names be used?
    #' @param dotted_initials Should initials be dot-separated?
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
      dotted_initials = TRUE,
      by = NULL
    ) {
      check_file(file, exts = c("qmd", "yml", "yaml"))
      super$initialize(
        data,
        names,
        roles,
        credit_roles,
        initials_given_name,
        dotted_initials,
        by = by
      )
      private$file <- file
      private$id <- private$pick("id")
    },

    #' @description Push or update author information in a YAML file or YAML
    #'   header. The generated YAML complies with Quarto's
    #'   `r link("quarto_schemas")`.
    #' @details
    #' If missing, `to_yaml()` inserts author information into the desired file.
    #' Otherwise, the function replaces old `author` and `affiliations` values
    #' with the ones provided in the input data.
    #' @return The input `file` invisibly.
    to_yaml = function() {
      yaml_push(private$get_template(), file = private$file)
    }
  ),

  private = list(
    file = NULL,
    names = .names_quarto,
    meta_key = "meta-",
    id = NULL,

    mold = function(...) {
      super$mold(starts_with(private$meta_key), ...)
    },

    get_template = function() {
      out <- list(
        author = private$author_tbl(),
        affiliations = private$affiliation_tbl()
      )
      add_class(out, cls = file_ext(private$file))
    },

    author_tbl = function() {
      tibble(
        id = private$author_ids(),
        number = private$pull("number"),
        name = tibble(
          given = private$pull("given_name"),
          family = private$pull("family_name"),
          `dropping-particle` = private$pull("dropping_particle")
        ),
        url = private$pull("url"),
        email = private$pull("email"),
        phone = private$pull("phone"),
        fax = private$pull("fax"),
        orcid = private$author_orcids(),
        note = private$author_notes(),
        degrees = private$itemise("degree"),
        acknowledgements = private$pull("acknowledgements"),
        attributes = private$author_attributes(),
        roles = private$itemise("role"),
        metadata = private$author_metadata(),
        affiliations = private$author_affiliations()
      )
    },

    author_ids = function() {
      ids <- private$pull("id")
      if (length(ids) == 1L) {
        return()
      }
      paste0("aut", ids)
    },

    author_orcids = function() {
      out <- private$pull("orcid")
      if (!is.null(out)) {
        check_orcid(out)
      }
      out
    },

    itemise = function(var) {
      private$pull_nestable(var, \(x) list(vec_drop_na(x)))
    },

    author_notes = function() {
      private$pull_nestable("note", \(x) bind(x, sep = ". ", arrange = FALSE))
    },

    pull_nestable = function(var, callback) {
      col <- private$pick(var)
      if (!private$has_col(col)) {
        return()
      }
      if (!is_nested(private$plume, col)) {
        return(private$pull(var))
      }
      out <- unnest(private$plume, cols = all_of(col))
      out <- summarise(out, `_` = if_not_na(
        .data[[col]],
        callback(.data[[col]]),
        all = TRUE
      ), .by = private$id)
      out[["_"]]
    },

    author_attributes = function() {
      out <- tibble(
        corresponding = private$pull("corresponding"),
        deceased = private$pull("deceased"),
        `equal-contributor` = private$pull("equal_contributor")
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
      ), .by = private$id)
      out[["_"]]
    },

    author_metadata = function() {
      if (!private$has_col(begins_with(private$meta_key))) {
        return()
      }
      select(private$plume, starts_with(private$meta_key))
    },

    affiliation_tbl = function() {
      affiliations <- private$pull("affiliation")
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

.affiliation_keys <- c(
  "number", "name", "department", "address", "city", "region", "state",
  "country", "postal-code", "url", "isni", "ringgold", "ror", "group"
)

parse_affiliation <- function(x) {
  if (!has_affiliation_sep(x)) {
    return(set_names(x, "name"))
  }
  keys <- collapse(.affiliation_keys, sep = "|")
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
