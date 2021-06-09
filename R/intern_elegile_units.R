#' intern_elegile_units
#'
#' Internal function. Please refer to run_synthetic_forecast documentation.
#'
#' Selects the elegible units to build the synthetic control: Rule the elegible units are the units that
#' have at least max_time_unit_of_interest + periods_to_forecast time periods.
#'
#' @param df Main DataFrame.
#' @param col_unit_name String with column name of the column with the units names.
#' @param col_time String with the column name of the time column.
#' @param max_time_unit_of_interest Outout from intern_get_max_time_unit_of_interest().
#' @param periods_to_forecast (Integer) Number of periods to forecast.
#'
#' @return DataFrame with the columns: (i) col_unit_name and (ii) manter (bool)
#'
#' @import dplyr
intern_elegile_units <- function(
  df, col_unit_name, col_time, max_time_unit_of_interest, periods_to_forecast
){
  out <- tryCatch(
    {
      dataset_max_time_per_unit <- df %>%
        group_by(!!sym(col_unit_name)) %>%
        summarise(max_time = max(!!sym(col_time))) %>%
        ungroup() %>%
        filter(!!sym('max_time') >= (max_time_unit_of_interest+periods_to_forecast)) %>%
        mutate(manter = T) %>%
        select(-c(!!sym('max_time')))

      dataset_max_time_per_unit
    },
    error = function(cond){
      print('Error in Function intern_elegile_units():')
      cond
    }
  )
  return(out)
}
