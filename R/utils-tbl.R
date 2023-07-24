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
  map_vec(rows, \(row) collapse(drop_na(row), sep))
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

set_suffixes <- function(data, cols, symbols) {
  .cols <- predot(cols)
  iwalk(symbols[names(cols)], \(value, key) {
    if (is.null(value)) {
      return()
    }
    if (key == "orcid") {
      data <<- add_orcid_icons(data, value)
    } else {
      data <<- set_symbols(data, .cols[key], value)
    }
  })
  data
}

set_symbols <- function(data, col, symbols) {
  if (is.null(symbols)) {
    return(data)
  }
  values <- data[[col]]
  symbols <- seq_symbols(symbols,  values)
  data[col] <- symbols[values]
  data
}

add_orcid_icons <- function(data, orcid) {
  attrs <- attributes(orcid)
  data[predot(attrs$var)] <- make_orcid_icon(data[[attrs$var]], attrs)
  data
}

add_orcid_links <- function(data, orcid, compact = FALSE) {
  .col <- predot(orcid)
  links <- make_orcid_link(data[[orcid]], compact)
  data[.col] <- paste0(data[[.col]], links)
  data
}
