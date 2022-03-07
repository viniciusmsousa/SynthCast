#' run_synthetic_forecast
#'
#' Executes all the other package functions in order to have a list with the results table.
#'
#' @param df Main DataFrame.
#' @param col_unit_name String with column name of the column with the units names.
#' @param unit_of_interest Value of the col_unit_name that is of interest.
#' @param col_time String with the column name of the time column.
#' @param periods_to_forecast (Integer) Number of periods to forecast.
#' @param serie_of_interest Column name os the serie to be projected.
#'
#' @return List with results table.
#' @export
#'
#' @examples
#' \donttest{
#' synthetic_forecast <- run_synthetic_forecast(
#' df = df_example,
#' col_unit_name = 'unit',
#' col_time='time_period',
#' periods_to_forecast=12,
#' unit_of_interest = '30',
#' serie_of_interest = 'x1'
#' )
#' }
#'
run_synthetic_forecast <- function(
  df, col_unit_name, unit_of_interest, col_time, periods_to_forecast,
  serie_of_interest
){
  # Testing argument types
  stopifnot(
    class(df)=="data.frame",
    class(col_unit_name)=="character",
    class(unit_of_interest)%in%c("integer", "character", "numeric"),
    class(col_time)%in%c("character"),
    class(periods_to_forecast)%in%c("integer", "numeric"),
    class(serie_of_interest)%in%c("character")
  )
  out <- tryCatch(
    {
      print(paste("Forecasting Unit: ", unit_of_interest, ". Serie: ", serie_of_interest))
      # 1) Retriving max time period of unit of interest
      intern_max_time_unit_interedt <- intern_get_max_time_unit_of_interest(
        df = df,
        col_unit_name = col_unit_name,
        unit_of_interest = unit_of_interest,
        col_time = col_time
      )

      # 2) Selecting elegible control units
      ## these are the units that have at least the max period time + forecast periods
      ## of the variable of interest.
      intern_elegible_units <- intern_elegile_units(
        df = df,
        col_unit_name = col_unit_name,
        col_time = col_time,
        max_time_unit_of_interest = intern_max_time_unit_interedt,
        periods_to_forecast = periods_to_forecast
      )

      # 3) Prepara dataset to Synthetic Method
      intern_dataset_prepared <- prepare_dataset(
        df = df,
        df_elegible_units = intern_elegible_units,
        col_unit_name = col_unit_name,
        col_time = col_time,
        unit_of_interest = unit_of_interest,
        max_time_unit_of_interest = intern_max_time_unit_interedt

      )

      # 4) Compute the Synthetic Control
      intern_compute_synthetic_control_out <- compute_synthetic_control(
        prepared_dataset = intern_dataset_prepared,
        unit_of_interest = unit_of_interest,
        serie_of_interest = serie_of_interest,
        col_time = col_time,
        max_time_unit_of_interest = intern_max_time_unit_interedt
      )

      # 5) Compute the Results Tables
      compute_result_tables_out <- compute_result_tables(
        synthetic_control_output = intern_compute_synthetic_control_out,
        unit_of_interest = unit_of_interest,
        serie_of_interest = serie_of_interest,
        max_time_unit_of_interest = intern_max_time_unit_interedt,
        df = df,
        col_unit_name = col_unit_name,
        periods_to_forecast = periods_to_forecast,
        col_time = col_time
      )

      compute_result_tables_out
    },
    error=function(cond){
      print('Error in Function run_synthetic_forecast():')
      print(cond)
    }
  )
  return(out)
}
