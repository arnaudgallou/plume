#' @title Create an ORCID icon
#' @description
#' Create an ORCID icon for use with the [`Plume`] class. This is currently only
#' compatible with R Markdown.
#' @param size Size of the icon (in pixels).
#' @param bw Should the black and white version of the icon be used?
#' @returns A plume icon, i.e. an object with S3 class `plm_icon`.
#' @examples
#' aut <- Plume$new(encyclopedists, orcid_icon = icn_orcid(bw = TRUE))
#' @export
icn_orcid <- function(size = 16, bw = FALSE) {
  check_num(size)
  check_bool(bw)
  new_icon("orcid", size = size, bw = bw)
}

#' @title ORCID icon
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Please use [icn_orcid()] instead.
#' @inheritParams icn_orcid
#' @returns A plume icon.
#' @keywords internal
#' @export
orcid <- function(size = 16, bw = FALSE) {
  lifecycle::deprecate_warn("0.2.6", "orcid()", "icn_orcid()")
  icn_orcid(size, bw)
}

#' @export
print.plm_icon <- function(x, ...) {
  cat(sprintf("<%s icon>%s", x, eol()))
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
  add_class(x, "svg", inherit = FALSE)
}

as_pdf <- function(x) {
  add_class(x, "pdf", inherit = FALSE)
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
  attrs <- list(size = round(size), filename = icn_filename(x, bw), ...)
  buffer <- icn_buffer(x, margin = round(size / 4L))
  c(attrs, buffer)
}

icn_path <- function(file) {
  system.file(file.path("icons", file), package = "plume")
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
