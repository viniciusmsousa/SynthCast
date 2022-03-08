#' compute_synthetic_control
#'
#' Internal function. Please refer to run_synthetic_forecast documentation.
#'
#' Compute the synthetic control 9wraps Synth package).
#'
#'
#' @param prepared_dataset Output from prepare_dataset().
#' @param unit_of_interest Value of the col_unit_name that is of interest.
#' @param serie_of_interest Column name os the serie to be projected.
#' @param col_time String with the column name of the time column.
#' @param max_time_unit_of_interest Outout from intern_get_max_time_unit_of_interest().
#'
#' @return List with (i) Synth::dataprep() output and (ii) Synth::Synth() output.
#' @export
#'
#' @import dplyr Synth
#' @importFrom stats sd
#'
compute_synthetic_control <- function(
  prepared_dataset, unit_of_interest, serie_of_interest, col_time, max_time_unit_of_interest
){
  out <- tryCatch(
    {
      if(max_time_unit_of_interest<2){
        stop(paste(as.character(unit_of_interest),': has less then 2 time observation!'))
      }

      # (i) Vectors of units
      units_char <- prepared_dataset %>% distinct(!!sym('unit_name')) %>% unlist()
      units_int <- prepared_dataset %>% distinct(!!sym('unit_name_id')) %>% unlist()


      # (ii) Selecting elegible variables names (std != 0)
      elegible_variable_cols = prepared_dataset %>%
        select(-c(!!sym('unit_name'),!!sym('unit_name_id'),!!sym(col_time))) %>%
        colnames()


      variable_cols <- prepared_dataset %>%
        select(c(!!sym('unit_name'),all_of(elegible_variable_cols))) %>%
        group_by(!!sym('unit_name')) %>%
        summarise_all('mean') %>%
        ungroup() %>%
        select(-c(!!sym('unit_name'))) %>%
        apply(2, sd) != 0

      elegible_variable_cols <- elegible_variable_cols[variable_cols]
      if(length(elegible_variable_cols)<=0){
        stop('all variables from prepared_dataset have no variance across units.')
      }

      # (iii) Computing the Synthetic Control
      prepared_dataset = as.data.frame(prepared_dataset)


      dataprep_out <- dataprep(
        foo = prepared_dataset,
        predictors = elegible_variable_cols[elegible_variable_cols!=serie_of_interest],
        predictors.op = 'mean',
        dependent = serie_of_interest,
        unit.names.variable = 'unit_name',
        unit.variable = 'unit_name_id',
        time.variable = col_time,
        treatment.identifier =  units_int[units_char==as.character(unit_of_interest)],
        controls.identifier = units_int[units_char!=as.character(unit_of_interest)],
        time.predictors.prior = head(prepared_dataset[prepared_dataset$unit_name==as.character(unit_of_interest),],-1)[[col_time]],
        time.optimize.ssr = head(prepared_dataset[prepared_dataset$unit_name==as.character(unit_of_interest),],-1)[[col_time]],
        time.plot = prepared_dataset[prepared_dataset$unit_name==as.character(unit_of_interest),][[col_time]]
      )
      synth_out = synth(data.prep.obj = dataprep_out, optimxmethod = 'L-BFGS-B',)

      list(dataprep_out = dataprep_out,synth_out = synth_out)
    },
    error=function(cond){
      print('Error in Function compute_synthetic_control():')
      print(cond)
    }
  )
  return(out)
}
