



df_example = read.csv('dev/example_df.csv',sep = ',',dec='.') %>%
  select(-X)
df_example  %>%  glimpse()

df_example %>%
  select(-c(y_cumsum,y)) -> df_example
  glimpse()

usethis::use_data(df_example,internal = F,overwrite = T)

