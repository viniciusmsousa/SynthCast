#' intern_get_max_time_unit_of_interest
#'
#' Internal function. Please refer to run_synthetic_forecast documentation.
#'
#' Intern function to compute the max time period of the unit of interest.
#'
#' @param df Main DataFrame.
#' @param col_unit_name String with column name of the column with the units names.
#' @param unit_of_interest Value of the col_unit_name that is of interest.
#' @param col_time String with the column name of the time column.
#'
#' @return Same type as col_time, max value.
#' @export
#'
intern_get_max_time_unit_of_interest <- function(
  df, col_unit_name, unit_of_interest, col_time
){
  out <- tryCatch(
    {
      time_max_unit_interest <- max(df[df[[col_unit_name]]==unit_of_interest,][[col_time]])
    },
    error = function(cond){
      print('Error in Function intern_get_max_time_unit_of_interest():')
      print(cond)
    }
  )
  return(out)
}
