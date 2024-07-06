# ::::::::::::::::::::::::::::::::::::::::::: #
# FUNCTIONS THAT HELP WITH MANIPULATING DATES #
# ::::::::::::::::::::::::::::::::::::::::::: #

#' Convert date and time variables into a datetime variable
#'
#' @param dates Character; vector with elements in `M/D/YYYY` format.
#' @param times Character; vector with elements in `H:MM` format.
#' @param tz Character; the time zone to be assigned, supplied to [lubridate::mdy_hms()] and [lubridate::as_datetime()].
#'   Defaults to `"US/Alaska"`.
#'
#' @return A vector with of class `"POSIXct/POSIXt"`.
#' @export

combine_datetime = function(dates, times, tz = "US/Alaska") {
  # step 1: combine dates and times and into standardized format
  step1 = suppressWarnings(lubridate::mdy_hms(paste(dates, paste0(times, ":00")), tz = tz))

  # step 2: force it to be a datetime object in R
  step2 = lubridate::as_datetime(step1, tz = tz)

  # return the output
  return(step2)
}

#' Format a datetime object to be shorter
#'
#' Convert a `"POSIXct/POSIXt"` object to a character
#'   class that is easier to read for humans.
#'
#' @param datetimes Object of class `"POSIXct/POSIXt"`, can have multiple elements.
#' @param include_dates Logical; whether the date should be included, as well as the time.
#' @return Character vector of length equal to that of `datetimes`.
#'   If `include_dates = FALSE`, only the time will be returned (12-hr clock).
#'   If `include_dates = TRUE`, the time and the date will be returned (`"M/D"` format).
#' @export

short_datetime = function(datetimes, include_date = FALSE) {

  # extract the day and month, and format them as M/D
  dates_short = paste(
    lubridate::month(datetimes),
    lubridate::day(datetimes), sep = "/"
  )

  # extract the time and format it as 12 hour clock (drop seconds as well)
  times_short = format(datetimes, format = "%I:%M %p")
  times_short = stringr::str_remove(times_short, "^0")

  # combine them if requested
  if (include_date) {
    out = paste0(times_short, " (", dates_short, ")")
  } else {
    out = times_short
  }

  # return the output
  return(out)
}

#' Create a date for use in file names
#'
#' Converts a `"POSIXct/POSIXt"` object to a
#'   character class useful in constructing file names.
#'
#' @param datetimes Object of class `"POSIXct/POSIXt"`, can have multiple elements.
#' @return Character vector of length equal to that of `datetimes`, but converted to format `"YYYY_MM_DD"`.
#' @export

file_date = function(datetimes) {
  day = stringr::str_pad(lubridate::day(datetimes), width = 2, side = "left", pad = "0")
  month = stringr::str_pad(lubridate::month(datetimes), width = 2, side = "left", pad = "0")
  year = lubridate::year(datetimes)
  paste(year, month, day, sep = "_")
}

#' Create a basic date from date time object
#'
#' Convert a `"POSIXct/POSIXt"` object to a character
#'   class that is easier to read for humans.
#'
#' @param datetimes Object of class `"POSIXct/POSIXt"`, can have multiple elements.
#' @return Character vector of length equal to that of `datetimes`, but converted to format `"M/D/YYYY"`.
#' @export

basic_date = function(datetimes) {
  day = lubridate::day(datetimes)
  month = lubridate::month(datetimes)
  year = lubridate::year(datetimes)
  paste(month, day, year, sep = "/")
}

#' Convert date to 'days past May 31'
#'
#' Standardizes a `"POSIXct/POSIXt"` object to be the number of days
#' past May 31 of that year
#'
#' @param dates Object of class `"POSIXct/POSIXt"`, can have multiple elements.
#' @return Numeric vector with length equal to `dates`, representing the number of days past May 31.
#' @export

to_days_past_may31 = function(dates) {
  ref_date = lubridate::as_date(paste0(lubridate::year(dates), "-05-31"))
  as.numeric(dates - ref_date, "days")
}

#' Convert 'days past May 31' to a date
#'
#' Unstandardizes a number of days past May 31
#' to be a `"POSIXct/POSIXt"` object
#'
#' @param days Numeric; number of days past May 31 to convert to a `"POSIXct/POSIXt"` object, can have multiple elements.
#' @param year Numeric or character; the year of the output `"POSIXct/POSIXt"` object. Can have multiple elements, but if so, should be the same length as `days`
#' @export

from_days_past_may31 = function(days, year = "1900") {
  ref_date = lubridate::as_date(paste0(as.character(year), "-05-31"))
  ref_date + days
}
