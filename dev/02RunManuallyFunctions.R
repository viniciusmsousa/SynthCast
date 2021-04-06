
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

units_int[units_char==as.character(unit_of_interest)]


compute_synthetic_control(
  prepared_dataset = prepared_df,
  unit_of_interest = 30,
  serie_of_interest = 'x1',
  col_time = 'time_period',
  max_time_unit_of_interest = max
)
