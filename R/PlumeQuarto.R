#' @title PlumeQuarto class
#' @description Class extending `Plume` that allows you to push or update author
#'   metadata in the YAML header of a `.qmd` file. The generated YAML complies
#'   with `Quarto`'s author and affiliations
#'   [schemas](https://quarto.org/docs/journals/authors.html).
#' @export
PlumeQuarto <- R6Class(
  classname = "PlumeQuarto",
  inherit = Plume,
  public = list(
    #' @description Set equal contributors.
    #' @param ... Values in the column defined by `by` used to specify which
    #'   authors are equal contributors. Matching of values is case-insensitive.
    #'   Use `"all"` to assign equal contribution to all authors.
    #' @param by Variable used to specify which authors are equal contributors.
    #'   By default, uses authors' ids.
    #' @return The class instance.
    set_equal_contributor = function(..., by) {
      private$set_status("equal_contributor", ..., by = by)
    },

    #' @description Set deceased authors.
    #' @param ... Values in the column defined by `by` used to specify whether
    #'   an author is deceased or not. Matching of values is case-insensitive.
    #' @param by Variable used to specify whether an author is deceased or not.
    #'   By default, uses authors' ids.
    #' @return The class instance.
    set_deceased = function(..., by) {
      private$set_status("deceased", ..., by = by)
    },

    #' @description Push or update author information in a YAML header.
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
        name = tibble(
          given = private$get("given_name"),
          family = private$get("family_name"),
          `dropping-particle` = private$get("dropping_particle")
        ),
        orcid = private$get("orcid"),
        email = private$get("email"),
        number = private$get("number"),
        fax = private$get("fax"),
        url = private$get("url"),
        note = private$author_notes(),
        attribute = private$author_attributes(),
        affiliations = private$author_affiliations(),
        metadata = private$author_metadata()
      )
    },

    author_notes = function() {
      col <- self$names$note
      if (!private$has_col(col)) {
        return()
      }
      if (!is_nested(self$plume, col)) {
        return(private$get("note"))
      }
      out <- unnest(self$plume, cols = all_of(col))
      out <- summarise(out, `_` = if_not_na(
        .data[[col]],
        bind(.data[[col]], sep = ", ", arrange = FALSE),
        all = TRUE
      ), .by = all_of(self$names$id))
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
      col <- self$names$affiliation
      if (!private$has_col(col)) {
        return()
      }
      .col <- predot(col)
      out <- unnest(self$plume, cols = all_of(col))
      out <- add_group_ids(out, col)
      out <- mutate(out, !!.col := if_not_na(
        .data[[.col]],
        paste0("aff", .data[[.col]])
      ))
      out <- summarise(out, `_` = list(
        tibble(ref = sort(!!sym(.col)))
      ), .by = all_of(self$names$id))
      out[["_"]]
    },

    author_metadata = function() {
      if (private$has_col(paste0("^", private$meta_prefix))) {
        select(self$plume, starts_with(private$meta_prefix))
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


parse_affiliation <- function(x) {
  if (!has_affiliation_sep(x)) {
    return(set_names(x, "name"))
  }
  keys <- paste(affiliation_keys(), collapse = "|")
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

affiliation_keys <- function() {
  c(
    "number", "name", "department", "address",
    "city", "region", "country", "postal-code", "url"
  )
}
