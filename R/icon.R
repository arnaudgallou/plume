#' @title ORCID icon
#' @description Helper function to control the size and colour of the ORCID
#'   icon.
#' @param size Size (in pixels) of the icon.
#' @param bw Should the black and white version of the icon be used?
#' @returns A plume icon.
#' @examples
#' aut <- Plume$new(encyclopedists, orcid_icon = orcid(bw = TRUE))
#' @export
orcid <- function(size = 16, bw = FALSE) {
  check_num(size, allow_null = FALSE, call = current_env())
  check_bool(bw, call = current_env())
  new_icon("orcid", size = size, bw = bw)
}

#' @export
print.plm_icon <- function(x, ...) {
  cat(sprintf("<%s>", x))
}

new_icon <- function(x, ..., size, bw) {
  attrs <- icn_get_attrs(x, size, bw, ...)
  do.call(structure, c(list(x, class = "plm_icon"), attrs))
}

md_link <- function(uri, content = NULL) {
  if (is.null(content)) {
    out <- sprintf("<%s>", uri)
  } else {
    out <- sprintf("[%s](%s)", content, uri)
  }
  propagate_na(out, from = uri)
}

md_image <- function(image, size, style, spacing) {
  wrap(sprintf("![](%s){height=%ipx%s}", image, size, style), spacing)
}

as_svg <- function(x) {
  structure(x, class = "svg")
}

as_pdf <- function(x) {
  structure(x, class = "pdf")
}

icn_format <- function(x) {
  if (knitr::is_html_output()) {
    return(as_svg(x))
  }
  as_pdf(x)
}

icn_filename <- function(x, bw) {
  bw <- if (bw) "-bw" else ""
  sprintf("%s%s.%s", x, bw, class(x))
}

icn_buffer <- function(x, margin) {
  UseMethod("icn_buffer")
}

icn_buffer.default <- function(x, margin) {
  list(
    style = "",
    spacing = sprintf("\\hspace{%ipt}", round(margin * .75))
  )
}

icn_buffer.svg <- function(x, margin) {
  list(
    style = sprintf(
      " style='margin: 0 %ipx; vertical-align: baseline'",
      margin
    ),
    spacing = ""
  )
}

icn_get_attrs <- function(x, size, bw, ...) {
  x <- icn_format(x)
  c(
    list(size = round(size), filename = icn_filename(x, bw), ...),
    icn_buffer(x, margin = round(size / 4L))
  )
}

icn_path <- function(file) {
  system.file(paste0("icons/", file), package = "plume")
}

icn_create <- function(attrs) {
  file <- icn_path(attrs$filename)
  md_image(file, attrs$size, attrs$style, attrs$spacing)
}

make_orcid_uri <- function(x) {
  check_orcid(x)
  out <- set_names(paste0("https://orcid.org/", x), x)
  propagate_na(out, from = x)
}

make_orcid_icon <- function(orcid, attrs) {
  uris <- make_orcid_uri(orcid)
  icon <- icn_create(attrs)
  md_link(uris, icon)
}

make_orcid_link <- function(orcid, compact) {
  uris <- make_orcid_uri(orcid)
  if (compact) {
    return(md_link(uris, names(uris)))
  }
  md_link(uris)
}
