# ::::::::::::::::::::::::::::::::::::::::::: #
# FUNCTIONS THAT HELP WITH MANIPULATING DATES #
# ::::::::::::::::::::::::::::::::::::::::::: #

#' Convert date and time variables into a datetime variable
#'
#' @param dates Character; vector with elements in `M/D/YYYY` format
#' @param times Character; vector with elements in `H:MM` format
#' @param tz Character; the time zone to be assigned, supplied to [lubridate::mdy_hms()] and [lubridate::as_datetime()].
#'   Defaults to `"US/Alaska"`.
#'
#' @return A vector with of class `datetime`.
#'

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
#' Convert a `datetime` object to a character
#'   class that is easier to read for humans.
#'
#' @param datetimes Object of class `datetime`
#' @param include_dates Logical; if `TRUE` `(M/D)` will be appended to the back of the output.
#'   If `FALSE`, only the time (12-hour clock) will be returned.
#'

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
#' Converts a `datetime` object to a
#'   character class with format `YYYY_MM_DD`. This format
#'   is useful in constructing file names.
#'
#' @param x and object of class `datetime`
#'

file_date = function(x) {
  day = stringr::str_pad(lubridate::day(x), width = 2, side = "left", pad = "0")
  month = stringr::str_pad(lubridate::month(x), width = 2, side = "left", pad = "0")
  year = lubridate::year(x)
  paste(year, month, day, sep = "_")
}

#' Create a basic date from date time object
#'
#' Convert a `datetime` object to a character
#'   class that is easier to read for humans.
#'
#' @param datetime Object of class `datetime`
#'

basic_date = function(datetime) {
  day = lubridate::day(datetime)
  month = lubridate::month(datetime)
  year = lubridate::year(datetime)
  paste(month, day, year, sep = "/")
}












