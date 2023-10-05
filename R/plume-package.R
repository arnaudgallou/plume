#' @description Handles and formats author information in scientific writing in
#'   'R Markdown' and 'Quarto'. 'plume' provides easy-to-use and flexible tools
#'   for injecting author metadata in 'YAML' headers as well as generating
#'   author and contribution lists (among others) as strings from tabular data.
#' @keywords internal
#' @importFrom dplyr distinct filter select dense_rank
#' @importFrom dplyr mutate summarise across rename arrange
#' @importFrom dplyr if_else if_any
#' @importFrom tidyr drop_na pivot_longer nest unnest expand_grid
#' @importFrom tidyselect all_of any_of starts_with
#' @importFrom tibble tibble as_tibble_row as_tibble rowid_to_column
#' @importFrom purrr set_names partial reduce
#' @importFrom purrr map map_vec map2_vec iwalk walk2
#' @importFrom purrr list_rbind list_transpose list_assign list_modify
#' @importFrom readr read_file write_lines
#' @importFrom rlang %||% := abort
#' @importFrom rlang expr exprs sym syms
#' @importFrom rlang is_named is_string is_bool is_true
#' @importFrom rlang caller_env caller_arg
#' @importFrom glue glue glue_collapse
#' @importFrom vctrs vec_group_id vec_duplicate_any vec_restore
#' @importFrom jsonlite toJSON parse_json
#' @importFrom yaml yaml.load as.yaml
#' @importFrom R6 R6Class
"_PACKAGE"
