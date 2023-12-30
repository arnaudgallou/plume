col_count <- function(data, name) {
  length(grep(name, names(data)))
}

itemise_rows <- function(data, cols) {
  out <- map(data[cols], as.character)
  list_transpose(out)
}

collapse_cols <- function(data, cols, sep) {
  if (length(cols) == 1L) {
    return(data[[cols]])
  }
  rows <- itemise_rows(data, cols)
  map_vec(rows, \(row) collapse(vec_drop_na(row), sep))
}

dissolve <- function(data, dict, callback, env = caller_env()) {
  iwalk(dict, \(value, key) {
    assign(key, callback(data, value), envir = env)
  })
}

unnest_drop <- function(data, cols) {
  data <- unnest(data, cols = all_of(cols))
  drop_na(data, all_of(cols))
}

add_group_ids <- function(data, cols) {
  for (col in cols) {
    data[predot(col)] <- group_id(data[[col]])
  }
  data
}

add_suffixes <- function(data, cols, symbols) {
  data
  .cols <- predot(cols)
  without_indexed_error(
    iwalk(symbols[names(cols)], \(value, key) {
      if (is.null(value)) {
        return()
      }
      if (key == "orcid") {
        data <<- add_orcid_icons(data, value)
      } else {
        data <<- add_symbols(data, .cols[[key]], value)
      }
    })
  )
  data
}

add_symbols <- function(data, col, symbols) {
  if (is.null(symbols)) {
    return(data)
  }
  values <- data[[col]]
  symbols <- seq_symbols(symbols,  values)
  data[col] <- symbols[values]
  data
}

add_orcid_icons <- function(data, orcid) {
  col <- unstructure(orcid)
  data[predot(col)] <- make_orcid_icon(data[[col]], attributes(orcid))
  data
}

add_orcid_links <- function(data, orcid, compact = FALSE) {
  .col <- predot(orcid)
  links <- make_orcid_link(data[[orcid]], compact)
  data[.col] <- paste0(data[[.col]], links)
  data
}

add_contribution_ranks <- function(data, values, roles, by, cols) {
  data <- col_init(data, cols$contributor_rank)
  iwalk(values, \(value, key) {
    data[cols$contributor_rank] <<- if_else(
      is_not_na(roles[key]) & data[[cols$role]] == roles[key],
      rank(data[[by]], value),
      data[[cols$contributor_rank]]
    )
  })
  data
}

col_init <- function(data, name) {
  if (!has_name(data, name)) {
    data[name] <- NA
  }
  data
}

assign_roles <- function(data, roles) {
  data
  iwalk(roles, \(value, key) {
    if (!has_name(data, key)) {
      return()
    }
    data[key] <<- if_else(data[[key]] == 1L, value, NA)
  })
  data
}

rename_roles <- function(data, roles, key) {
  nms <- names(roles)
  if (length(nms) > 1L) {
    key <- paste(key, seq_along(nms), sep = "_")
  }
  rename(data, any_of(set_names(nms, key)))
}
