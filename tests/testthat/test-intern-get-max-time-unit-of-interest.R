data("df_example")

test_that(
  desc = "Tests intern_get_max_time_unit_of_interest()",
  code = {
    max_time_unit <- intern_get_max_time_unit_of_interest(
      df = df_example,
      col_unit_name = 'unit',
      unit_of_interest = 30,
      col_time = 'time_period'
    )

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
