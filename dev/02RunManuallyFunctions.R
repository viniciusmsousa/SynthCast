
library(devtools)
library(dplyr)
library(SyntheticForecast)

prepare_dataset

data('df_example')
df_example %>% glimpse()

max <- intern_get_max_time_unit_of_interest(df = df_example, col_unit_name = 'unit', unit_of_interest = 30,
                                     col_time = 'time_period')

elegible <- intern_elegile_units(df = df_example,
                     col_unit_name = 'unit',
                     col_time = 'time_period',
                     max_time_unit_of_interest = max,
                     periods_to_forecast = 6)

prepared_df <- prepare_dataset(
  df = df_example,
  df_elegible_units = elegible,
  col_unit_name = 'unit',
  col_time = 'time_period',
  unit_of_interest = 30,
  max_time_unit_of_interest = max
)

prepared_df %>% glimpse()

as.integer(forcats::as_factor(df_example$unit))


units_char <- prepared_df %>% distinct(!!sym('unit_name')) %>% unlist()
units_int <- prepared_df %>% distinct(!!sym('unit_name_id')) %>% unlist()


compute_synthetic_control(
  prepared_dataset = prepared_df,
  unit_of_interest = 30,
  serie_of_interest = 'x1',
  col_time = 'time_period',
  max_time_unit_of_interest = max
)





# teste -------------------------------------------------------------------



library(devtools)
library(dplyr)
library(SynthCast)

source('R/intern_elegile_units.R')
source('R/intern_get_max_time_unit_of_interest.R')

df_example <- read.csv('dev/export.csv') %>%
  as_tibble() %>%
  select(-c(periodo)) %>%
  glimpse()

id = 2536526
unit_of_interest = id

max <- intern_get_max_time_unit_of_interest(df = df_example, col_unit_name = 'id', unit_of_interest = id,
                                            col_time = 'mob')

elegible <- intern_elegile_units(df = df_example,
                                 col_unit_name = 'id',
                                 col_time = 'mob',
                                 max_time_unit_of_interest = max,
                                 periods_to_forecast = 6)

source('R/prepare_dataset.R')
prepared_df <- prepare_dataset(
  df = df_example,
  df_elegible_units = elegible,
  col_unit_name = 'id',
  col_time = 'mob',
  unit_of_interest = id,
  max_time_unit_of_interest = max
)

prepared_df %>% View()


units_char <- prepared_df %>% distinct(!!sym('unit_name')) %>% unlist()
units_int <- prepared_df %>% distinct(!!sym('unit_name_id')) %>% unlist()

units_int[units_char==as.character(unit_of_interest)]




source('R/compute_synthetic_control.R')
intern_compute_synthetic_control_out <- compute_synthetic_control(
  prepared_dataset = prepared_df,
  unit_of_interest = id,
  serie_of_interest = 'receita_spread',
  col_time = 'mob',
  max_time_unit_of_interest = max
)




source('R/compute_result_tables.R')
compute_result_tables_out <- compute_result_tables(
  synthetic_control_output = intern_compute_synthetic_control_out,
  unit_of_interest = id,
  serie_of_interest = 'receita_spread',
  max_time_unit_of_interest = max,
  df = as.data.frame(df_example),
  col_unit_name = 'id',
  periods_to_forecast = 6,
  col_time = 'mob'
)
compute_result_tables_out


source('R/run_synthetic_forecast.R')
synthetic_forecast <- run_synthetic_forecast(
  df = as.data.frame(df_example),
  col_unit_name = 'id',
  col_time='mob',
  periods_to_forecast=12,
  unit_of_interest = 2536526,
  serie_of_interest = 'receita_spread'
)






if(sum(duplicated(c(controls.identifier.name,treatment.identifier.name))) > 0)



  # wip ---------------------------------------------------------------------


library(devtools)
library(dplyr)
library(SynthCast)








df_example %>% filter(id==) %>% View()
