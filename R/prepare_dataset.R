#' prepare_dataset
#'
#' Internal function. Please refer to run_synthetic_forecast documentation.
#'
#' @param df Main DataFrame.
#' @param df_elegible_units output from intern_elegile_units().
#' @param col_unit_name String with column name of the column with the units names.
#' @param col_time String with the column name of the time column.
#' @param unit_of_interest Value of the col_unit_name that is of interest.
#' @param max_time_unit_of_interest Outout from intern_get_max_time_unit_of_interest().
#'
#' @return A dataset to be inputed in the compute_synthetic_control().
#'
#' @import dplyr forcats
#' @importFrom forcats as_factor
#'
prepare_dataset <- function(
  df, df_elegible_units, col_unit_name, col_time, unit_of_interest, max_time_unit_of_interest
){
  out <- tryCatch(
    {
      dataset <- df %>%
        mutate(
          unit_name_id = as.integer(as_factor(!!sym(all_of(col_unit_name)))),
          unit_name = as.character(!!sym('unit_name_id'))
        ) %>%
        filter(
          !!sym(col_time) <= max_time_unit_of_interest
        ) %>%
        left_join(
          df_elegible_units,
          by = all_of(col_unit_name)
        ) %>%
        filter(
          (!!sym('manter') == T | !!sym(all_of(col_unit_name)) == as.character(unit_of_interest))
        ) %>%
        select(-c(!!sym(all_of(col_unit_name)),!!sym('manter'))) %>%
        relocate(c(!!sym('unit_name'),!!sym('unit_name_id')))
    },
    error=function(cond){
      print('Error in Function prepare_dataset():')
      cond
    }
  )
  return(out)
}
