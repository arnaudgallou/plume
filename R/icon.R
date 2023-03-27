md_link <- function(url, content = NULL) {
  content <- content %||% url
  sprintf("[%s](%s)", content, url)
}

md_image <- function(path, size, style, margin) {
  sprintf("%s![](%s){height=%ipx%s}%s", margin, path, size, style, margin)
}

file_name <- function(x) {
  paste0(x, ".", class(x))
}

svg <- function(x) {
  structure(x, class = "svg")
}

pdf <- function(x) {
  structure(x, class = "pdf")
}

icon <- function(x) {
  if (knitr::is_html_output()) {
    return(svg(x))
  }
  pdf(x)
}

get_icon <- function(file) {
  system.file(paste0("icons/", file), package = "plume")
}

icon_pars <- function(x, size, margin) {
  UseMethod("icon_pars")
}

icon_pars.default <- function(x, size, margin) {
  list(
    size = size,
    style = "",
    margin = sprintf("\\hspace{%ipt}", round(margin * .75))
  )
}

icon_pars.svg <- function(x, size, margin) {
  list(
    size = size + 4,
    style = sprintf(" style='margin: 0 %ipx; vertical-align: baseline'", margin),
    margin = ""
  )
}

make_icon <- function(x, size = 16, margin = size / 4) {
  aes <- map(c(size = size, margin = margin), round)
  pars <- icon_pars(x, aes$size, aes$margin)
  icon <- get_icon(file_name(x))
  md_image(icon, pars$size, pars$style, pars$margin)
}

make_orcid_link <- function(orcid) {
  check_orcid(orcid)
  url <- paste0("https://orcid.org/", orcid)
  icon <- make_icon(icon("orcid"))
  out <- md_link(url, icon)
  propagate_na(out, from = orcid)
}
