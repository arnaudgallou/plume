# stringb functions start
# modified from https://github.com/hadley/stringb

fixed <- function(x) {
  structure(x, class = c("fixed", "character"))
}

regex <- function(x) {
  structure(x, class = c("regex", "character"))
}

is_fixed <- function(x) {
  inherits(x, "fixed")
}

is_perl <- function(x) {
  is.null(attr(x, "class"))
}

string_detect <- function(string, pattern) {
  grepl(
    pattern, string,
    fixed = is_fixed(pattern),
    perl = is_perl(pattern)
  )
}

string_extract <- function(string, pattern) {
  string_sub(string, string_locate(string, pattern))
}

string_extract_all <- function(string, pattern) {
  loc <- string_locate_all(string, pattern)
  out <- lapply(seq_along(string), \(i) {
    loc <- loc[[i]]
    string_sub(rep(string[[i]], nrow(loc)), loc)
  })
  if (length(out) == 1L) {
    out <- unlist(out)
  }
  out
}

string_locate <- function(string, pattern) {
  out <- regexpr(
    pattern, string,
    fixed = is_fixed(pattern),
    perl = is_perl(pattern)
  )
  location(out)
}

string_locate_all <- function(string, pattern) {
  out <- gregexpr(
    pattern, string,
    fixed = is_fixed(pattern),
    perl = is_perl(pattern)
  )
  lapply(out, location, all = TRUE)
}

location <- function(x, all = FALSE) {
  start <- as.vector(x)
  if (all && identical(start, -1L)) {
    return(cbind(start = integer(), end = integer()))
  }
  end <- as.vector(x) + attr(x, "match.length") - 1
  no_match <- start == -1L
  start[no_match] <- NA
  end[no_match] <- NA
  cbind(start = start, end = end)
}

string_replace <- function(string, pattern, replacement) {
  sub(
    pattern, replacement, string,
    fixed = is_fixed(pattern),
    perl = is_perl(pattern)
  )
}

string_replace_all <- function(string, pattern, replacement) {
  gsub(
    pattern, replacement, string,
    fixed = is_fixed(pattern),
    perl = is_perl(pattern)
  )
}

string_sub <- function(string, start = 1L, end = -1L) {
  if (is.matrix(start)) {
    end <- start[, 2]
    start <- start[, 1]
  }
  n <- nchar(string)
  start <- ifelse(start < 0, start + n + 1, start)
  end <- ifelse(end < 0, end + n + 1, end)
  substr(string, start, end)
}

# stringb functions end

string_remove_all <- function(string, pattern) {
  string_replace_all(string, pattern, "")
}

string_contain <- function(string, pattern) {
  string_detect(string, fixed(pattern))
}

string_split <- function(string, pattern = "") {
  out <- strsplit(
    string, pattern,
    fixed = is_fixed(pattern),
    perl = is_perl(pattern)
  )
  if (length(out) == 1L) {
    out <- unlist(out)
  }
  out
}
