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
  desc = "Test intern_elegile_units()",
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
