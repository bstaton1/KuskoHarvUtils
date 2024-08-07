% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01-dates.R
\name{from_days_past_may31}
\alias{from_days_past_may31}
\title{Convert 'days past May 31' to a date}
\usage{
from_days_past_may31(days, year = "1900")
}
\arguments{
\item{days}{Numeric; number of days past May 31 to convert to a \code{"POSIXct/POSIXt"} object, can have multiple elements.}

\item{year}{Numeric or character; the year of the output \code{"POSIXct/POSIXt"} object. Can have multiple elements, but if so, should be the same length as \code{days}}
}
\description{
Unstandardizes a number of days past May 31
to be a \code{"POSIXct/POSIXt"} object
}
