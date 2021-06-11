# Computing Objects to be Tested With -------------------------------------

max_time_unit <- intern_get_max_time_unit_of_interest(
  df = df_example,
  col_unit_name = 'unit',
  unit_of_interest = 30,
  col_time = 'time_period'
)

elegible <- intern_elegile_units(
  df = df_example,
  col_unit_name = 'unit',
  col_time = 'time_period',
  max_time_unit_of_interest = max_time_unit,
  periods_to_forecast = 6
)

prepared_df <- prepare_dataset(
  df = df_example,
  df_elegible_units = elegible,
  col_unit_name = 'unit',
  col_time = 'time_period',
  unit_of_interest = 30,
  max_time_unit_of_interest = max_time_unit
)

synthetic_control = compute_synthetic_control(
  prepared_dataset = prepared_df,
  unit_of_interest = 30,
  serie_of_interest = 'x1',
  col_time = 'time_period',
  max_time_unit_of_interest = max_time_unit
)

result_tables <- compute_result_tables(
  df = df_example,
  synthetic_control_output = synthetic_control,
  col_unit_name = 'unit',
  unit_of_interest = 30,
  serie_of_interest = 'x1',
  max_time_unit_of_interest = max_time_unit,
  periods_to_forecast = 12,
  col_time = 'time_period'
)

synthetic_forecast <- run_synthetic_forecast(
  df = df_example,
  col_unit_name = 'unit',
  serie_of_interest = 'x1',
  unit_of_interest = 30,
  col_time = "time_period",
  periods_to_forecast = 12
)


# Tests -------------------------------------------------------------------

test_that(
  desc = "Tests intern_get_max_time_unit_of_interest()",
  code = {
    expect_equal(
      object = class(max_time_unit),
      expected = "integer"
    )
    expect_equal(
      object = length(max_time_unit),
      expected = 1
    )
    expect_equal(
      object = max_time_unit,
      expected = 21
    )
  }
)

test_that(
  desc = "Tests intern_elegile_units()",
  code = {
    expect_equal(
      object = class(elegible),
      expected = c("tbl_df", "tbl", "data.frame")
    )
    expect_equal(
      object = as.vector(sapply(elegible, class)),
      expected = c("integer", "logical")
    )
  }
)

test_that(
  desc = "Tests prepare_dataset()",
  code = {
    expect_equal(
      object = class(prepared_df),
      expected = c("data.frame")
    )

    expect_equal(
      object = c(ncol(prepared_df), nrow(prepared_df)),
      expected = c(31, 525)
    )

    expect_equal(
      object = as.vector(sapply(prepared_df, class)),
      expected = c(
        "character", "integer", "integer", "numeric",
        "numeric", "numeric", "numeric", "numeric",
        "numeric", "numeric", "numeric", "numeric",
        "numeric", "numeric", "numeric", "numeric",
        "numeric", "numeric", "numeric", "numeric",
        "numeric", "numeric", "numeric", "numeric",
        "numeric", "numeric", "numeric", "numeric",
        "numeric", "numeric", "numeric"
      )
    )
  }
)

test_that(
  desc = "Tests compute_synthetic_control()",
  code = {
    expect_equal(
      object = class(synthetic_control),
      expected = c("list")
    )
    expect_equal(
      length(synthetic_control),
      expected = c(2)
    )

    expect_equal(
      object = names(synthetic_control),
      expected = c("dataprep_out", "synth_out")
    )
  }
)

test_that(
   desc = 'Tests compute_result_tables()',
   code = {
     expect_equal(
       object = class(result_tables),
       expected = 'list'
     )

     expect_equal(
       object = length(result_tables),
       expected = 4
     )

     expect_equal(
       object = names(result_tables),
       expected = c('synthetic_control_composition',
                    'variable_importance_and_comparison',
                    'mape_backtest',
                    'output_projecao')
     )
   }
)

test_that(
  desc = "Test: argument type error in the run_synthetic_forecast()",
  code = {
    expect_error(
      object = run_synthetic_forecast(
        df = tibble(),
        col_unit_name = "unit",
        unit_of_interest = 30,
        col_time = "time_period",
        periods_to_forecast = 6
      ),
      class = "simpleError"
    )

    expect_error(
      object = run_synthetic_forecast(
        df = df_example,
        col_unit_name = 23,
        unit_of_interest = 30,
        col_time = "time_period",
        periods_to_forecast = 6
      ),
      class = "simpleError"
    )

    expect_error(
      object = run_synthetic_forecast(
        df = df_example,
        col_unit_name = 23,
        unit_of_interest = "unit",
        col_time = 23,
        periods_to_forecast = 6
      ),
      class = "simpleError"
    )

    expect_error(
      object = run_synthetic_forecast(
        df = df_example,
        col_unit_name = 23,
        unit_of_interest = "unit",
        col_time = "time_period",
        periods_to_forecast = "period_non_numeric"
      ),
      class = "simpleError"
    )
  }
)

test_that(
  desc = 'Tests run_synthetic_forecast()',
  code = {
    expect_equal(
      object = class(synthetic_forecast),
      expected = 'list'
    )

    expect_equal(
      object = length(synthetic_forecast),
      expected = 4
    )

    expect_equal(
      object = names(synthetic_forecast),
      expected = c('synthetic_control_composition',
                   'variable_importance_and_comparison',
                   'mape_backtest',
                   'output_projecao')
    )
  }
)
