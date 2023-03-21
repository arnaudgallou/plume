unnest_drop <- function(x, cols) {
  x <- unnest(x, cols = all_of(cols))
  drop_na(x, all_of(cols))
}

add_group_ids <- function(x, cols) {
  for (col in cols) {
    x[predot(col)] <- group_id(x[[col]])
  }
  x
}

set_suffixes <- function(x, cols, symbols) {
  .cols <- predot(cols)
  iwalk(symbols[names(cols)], \(value, key) {
    if (is.null(value)) {
      return()
    }
    if (key == "orcid") {
      x <<- set_orcid_icons(x, value)
    } else {
      x <<- set_symbols(x, .cols[key], value)
    }
  })
  x
}

set_symbols <- function(x, col, symbols) {
  values <- x[[col]]
  symbols <- seq_symbols(symbols,  values)
  x[col] <- symbols[values]
  x
}

set_orcid_icons <- function(x, orcid) {
  x[predot(orcid)] <- make_orcid_link(x[[orcid]])
  x
}
