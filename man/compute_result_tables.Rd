% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compute_result_tables.R
\name{compute_result_tables}
\alias{compute_result_tables}
\title{compute_result_tables}
\usage{
compute_result_tables(
  df,
  synthetic_control_output,
  col_unit_name,
  unit_of_interest,
  serie_of_interest,
  max_time_unit_of_interest,
  periods_to_forecast,
  col_time
)
}
\arguments{
\item{df}{Main DataFrame.}

\item{synthetic_control_output}{Output from compute_synthetic_control().}

\item{col_unit_name}{String with column name of the column with the units names.}

\item{unit_of_interest}{Value of the col_unit_name that is of interest.}

\item{serie_of_interest}{Column name os the serie to be projected.}

\item{max_time_unit_of_interest}{Outout from intern_get_max_time_unit_of_interest().}

\item{periods_to_forecast}{(Integer) Number of periods to forecast.}

\item{col_time}{String with the column name of the time column.}
}
\value{
List with result tables.
}
\description{
Internal function. Please refer to run_synthetic_forecast documentation.
}
