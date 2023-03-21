extract_key_sep <- function(format, key) {
  sep_regex <- paste0("(?!^)(?<=[acn]),\\^?(?=", key, ")")
  sep <- string_extract(format, sep_regex)
  if (is.na(sep)) {
    return("")
  }
  sep
}

extract_keys <- function(x) {
  x <- string_split(x)
  x[x %in% letters]
}

sanitize <- function(x) {
  string_remove_all(x, "([,^])\\K\\1+")
}

clean_suffix_format <- function(x) {
  out <- string_remove_all(x, ",+")
  sanitize(out)
}

parse_suffix_format <- function(format) {
  format <- sanitize(format)
  keys <- extract_keys(format)
  seps <- map_vec(keys, \(key) extract_key_sep(format, key))
  list(
    keys = keys,
    seps = set_names(seps, keys),
    format = clean_suffix_format(format)
  )
}

keys_to_pattern <- function(format, keys) {
  keys <- to_chr_class(keys)
  string_replace_all(format, paste0("(", keys, ")"), "{\\1}")
}
