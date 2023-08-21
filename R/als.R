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
  x <- string_split(x)
  x[x %in% letters]
}

als_extract_mark <- function(format, key) {
  mark_regex <- paste0("[,^]{1,2}(?=", key, ")")
  mark <- string_extract(format, mark_regex)
  if (is.na(mark)) {
    return("")
  }
  mark
}

als_sanitise <- function(x) {
  string_remove_all(x, "([,^])\\K\\1+")
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

als_join <- function(elts, marks) {
  out <- map2_vec(elts, marks, \(elt, mark) {
    if (is_blank(elt) & string_contain(mark, "^")) {
      return("^")
    } else if (is_blank(elt)) {
      return(elt)
    }
    paste0(mark, elt)
  })
  collapse(out)
}

als_clean <- function(x) {
  for (pattern in c("(?<=^|\\^),|,$", "\\^{2}")) {
    x <- string_remove_all(x, pattern)
  }
  x
}

als_make <- function(data, cols, format) {
  rows <- itemise_rows(data, cols)
  marks <- als_parse(format)
  if (is_empty(marks$heads)) {
    return(map_vec(rows, collapse))
  }
  out <- map_vec(rows, \(row) als_join(row, marks$heads))
  out <- paste0(out, marks$tail)
  als_clean(out)
}
