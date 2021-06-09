#' compute_result_tables
#'
#' Internal function. Please refer to run_synthetic_forecast documentation.
#'
#' @param df Main DataFrame.
#' @param synthetic_control_output Output from compute_synthetic_control().
#' @param col_unit_name String with column name of the column with the units names.
#' @param unit_of_interest Value of the col_unit_name that is of interest.
#' @param serie_of_interest Column name os the serie to be projected.
#' @param max_time_unit_of_interest Outout from intern_get_max_time_unit_of_interest().
#' @param periods_to_forecast (Integer) Number of periods to forecast.
#' @param col_time String with the column name of the time column.
#'
#' @return List with result tables.
#'
#' @import dplyr tidyr Synth utils
#'
compute_result_tables <- function(
  df, synthetic_control_output, col_unit_name, unit_of_interest,
  serie_of_interest, max_time_unit_of_interest, periods_to_forecast, col_time
){
  out <- tryCatch(
    {
      execution_date = as.character(Sys.Date())
      # 1) Synth package tables
      synth_tables <- synth.tab(dataprep.res =   synthetic_control_output$dataprep_out,
                                synth.res = synthetic_control_output$synth_out)

      # 2) Synthetic units
      synthetic_control_composition <- synth_tables$tab.w %>%
        as_tibble() %>%
        mutate(
          execution_date = execution_date,
          projected_unit=as.character(unit_of_interest),
          projected_serie = serie_of_interest,
          synthetic_units=as.character(!!sym('unit.names'))
        ) %>%
        filter(!!sym('w.weights') > 0) %>%
        arrange(desc(!!sym('w.weights'))) %>%
        select(-c(!!sym('unit.numbers'),!!sym('unit.names'))) %>%
        relocate(c(execution_date,!!sym('projected_unit'),!!sym('projected_serie'),synthetic_units))

      # 3) Variable importance and Comparison between synthetic and unit of interest
      variable_importance_and_comparison <- as_tibble(synth_tables$tab.pred,rownames='variable') %>%
        left_join(
          synth_tables$tab.v %>%
            as_tibble(rownames='variable') %>%
            tidyr::unnest(cols=c(!!sym('v.weights'))) %>%
            arrange(desc(!!sym('v.weights'))),
          by='variable'
        ) %>%
        filter(!!sym('v.weights')>0) %>%
        arrange(desc(!!sym('v.weights'))) %>%
        mutate(
          execution_date=execution_date,
          projected_unit=as.character(unit_of_interest),
          projected_serie = serie_of_interest
        ) %>%
        relocate(c(execution_date,!!sym('projected_unit'),!!sym('projected_serie'))) %>%
        rename(
          unit_of_interest=!!sym('Treated'),
          synthetic=!!sym('Synthetic'),
          sample=!!sym('Sample Mean')
        )

      # 4) Optimzation MAPE
      predicted <- synthetic_control_output$dataprep_out$Y0plot %*% synthetic_control_output$synth_out$solution.w
      observed <- synthetic_control_output$dataprep_out$Y1plot

      mape_backtest <- tibble(
        execution_date=execution_date,
        projected_unit=as.character(unit_of_interest),
        projected_serie = serie_of_interest,
        max_time_unit_of_interest = max_time_unit_of_interest,
        periods_to_forecast = periods_to_forecast,
        elegible_control_units = ncol(synthetic_control_output$dataprep_out$Y0plot)-1,
        number_control_units = length(unique(synthetic_control_composition$synthetic_units)),
        mape = mean(abs((observed-predicted)/observed)) * 100
      )

      # 5) Observed and projected values
      #print('5 tabela: start')

      #print('renomear tabela auxiliar: start')
      df_obs_projec <- df %>%
        rename(units_name = !!sym(col_unit_name),
               time_period = !!sym(col_time),
               projected_serie_value = !!sym(serie_of_interest))
      #print('renomear tabela auxiliar: end')


      ## a) Observed values
      df_observed <- df_obs_projec %>%
        filter(!!sym('units_name') == unit_of_interest,
               !!sym('time_period') <= max_time_unit_of_interest) %>%
        select(c(!!sym('time_period'),!!sym('projected_serie_value'))) %>%
        mutate(is_projected=0)


      ## b) Projected Values
      synthetic_units <- synth_tables$tab.w %>%
        as_tibble() %>%
        filter(!!sym('w.weights')>0) %>%
        mutate(unit.names=as.character(!!sym('unit.names'))) %>%
        select(!!sym('unit.names'),!!sym('w.weights'))

      df_projected <- df_obs_projec %>%
        mutate(units_name = as.character(!!sym('units_name'))) %>%
        filter(!!sym('units_name') %in% synthetic_units$unit.names,
               !!sym('time_period') <= (max_time_unit_of_interest+periods_to_forecast)) %>%
        select(!!sym('units_name'),!!sym('time_period'),!!sym('projected_serie_value')) %>%
        left_join(
          synthetic_units,
          by=c('units_name'='unit.names')
        ) %>%
      mutate(projected_serie_value = !!sym('projected_serie_value')*!!sym('w.weights')) %>%
        group_by(!!sym('time_period')) %>%
        summarise(projected_serie_value = sum(!!sym('projected_serie_value'))) %>%
        ungroup() %>%
        filter(!!sym('time_period') > max_time_unit_of_interest) %>%
        mutate(is_projected=1)

      ## c) Bind de observed and projected
      output_projecao <- bind_rows(df_observed,df_projected) %>%
        mutate(
          execution_date = execution_date,
          projected_unit = as.character(unit_of_interest),
          projected_serie = serie_of_interest
        ) %>%
        relocate(c(execution_date,!!sym('projected_unit'),!!sym('time_period'),!!sym('projected_serie_value'),!!sym('projected_serie_value')))

      tables_list <- list(
        synthetic_control_composition = synthetic_control_composition,
        variable_importance_and_comparison = variable_importance_and_comparison,
        mape_backtest = mape_backtest,
        output_projecao = output_projecao
      )
      tables_list
    },
    error=function(cond){
      print('Error in Function compute_result_tables():')
      cond
    }
  )
  return(out)
}
