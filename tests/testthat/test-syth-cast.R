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