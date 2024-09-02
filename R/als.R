als_key_set <- function(format) {
  set <- c(
    a = "affiliation",
    c = "corresponding",
    n = "note",
    o = "orcid"
  )
  keys <- als_extract_keys(format)
  set[keys]
}

als_extract_keys <- function(x) {
  str_extract_all(x, "[a-z]")[[1]]
}

als_extract_mark <- function(format, key) {
  mark_regex <- paste0("[,^]{1,2}(?=", key, ")")
  mark <- str_extract(format, mark_regex)
  if (is.na(mark)) {
    return("")
  }
  mark
}

als_sanitise <- function(x) {
  str_remove_all(x, "(?<=([,^]))\\1+")
}

als_parse <- function(format) {
  format <- als_sanitise(format)
  keys <- als_extract_keys(format)
  marks <- map_vec(c(keys, "$"), \(key) als_extract_mark(format, key))
  last <- length(marks)
  list(
    heads = marks[-last],
    tail = marks[last]
  )
}

als_join <- function(x, marks) {
  prev_item <- vector("character", 1L)
  out <- map2_vec(x, marks, \(item, mark) {
    if (is_empty(item) && str_contain(mark, "^")) {
      return("^")
    }
    if (is_empty(item)) {
      return(item)
    }
    if (is_empty(prev_item) && str_contain(mark, ",")) {
      mark <- stringr::str_remove(mark, fixed(","))
    }
    prev_item <<- item
    paste0(mark, item)
  })
  collapse(out)
}

als_make <- function(data, cols, format) {
  rows <- itemise_rows(data, cols)
  marks <- als_parse(format)
  if (is_empty(marks$heads)) {
    return(map_vec(rows, collapse))
  }
  out <- map_vec(rows, \(row) als_join(row, marks$heads))
  out <- paste0(out, marks$tail)
  als_sanitise(out)
}
