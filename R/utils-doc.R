get_table_vars <- function(category) {
  names <- list_modify(.names_plume, !!!.names_quarto)
  out <- tibble(
    Name = squash(names),
    Plume = .data$Name %in% unlist(.names_plume),
    PlumeQuarto = .data$Name %in% unlist(.names_quarto),
  )
  if (!is.null(category)) {
    out <- filter(out, .data$Name %in% list_fetch(names, category))
  }
  out
}

plm_table <- function(data, ...) {
  out <- arrange(data, dplyr::desc(Plume))
  out <- gt::gt(out, ...)
  out <- gt::text_case_match(
    out,
    "TRUE" ~ fontawesome::fa("check"),
    .default = "",
    .locations = gt::cells_body(starts_with("Plume"))
  )
  out <- gt::cols_align(out, align = "center", columns = starts_with("Plume"))
  out <- gt::cols_width(out, Name ~ gt::pct(50))
  gt::opt_row_striping(out)
}

plm_table_vars <- function(category = NULL, ...) {
  plm_table(get_table_vars(category), ...)
}
