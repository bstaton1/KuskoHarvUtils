# :::::::::::::::::::::::::::::::::::::::::::: #
# FUNCTIONS THAT HELP WITH MISCELLANEOUS TASKS #
# :::::::::::::::::::::::::::::::::::::::::::: #

#' Convert a proportion to a percent
#'
#' @param x Numeric; vector containing values on the proportional scale to be converted to a percentage value
#' @param escape Logical; should the percent symbol be escaped? Aids in placing this output into LaTeX tables
#' @param digits Numeric; supplied to [base::round()]. Defaults to `0`.
#'
#' @return Character vector storing percentage values. If a non-zero value would be rounded to zero, `"<1%"` is returned instead.
#' @export

percentize = function(x, escape = FALSE, digits = 0) {
  # create the percent version
  out = paste0(round(x * 100, digits = digits), ifelse(escape, "\\%", "%"))

  # test if a non-zero proportion was rounded to a zero value percent
  # if so, change output to be <1%
  zero_test = ifelse(escape, "0\\%", "0%")
  lt1_replace = ifelse(escape, "<1\\%", "<1%")
  ifelse(out == zero_test & x > 0, lt1_replace, out)
}

#' Capitalize a character string
#'
#' Applies [base::toupper()] to the first character in each
#'   element of a character vector
#'
#' @param x Character; a vector of character strings for which the
#'   first character should be converted to uppercase. If not
#'   a character, will be coerced to one.
#' @export

capitalize = function (x) {
  x = as.character(x)
  first = substr(x, 1, 1)
  last = substr(x, 2, nchar(x))
  paste0(toupper(first), last)
}

#' Summation-informed rounding
#'
#' Rounds a vector such that the sum of the rounded vector equals the sum of the unrounded vector
#'
#' @param x Numeric; vector to be rounded
#' @param digits Numeric; number of decimal points to round to
#' @references The source code for this function was copied from [this Stack Overflow answer](https://stackoverflow.com/a/35930285/3911200)
#' @export

smart_round = function(x, digits = 0) {
  # copied from https://stackoverflow.com/a/35930285/3911200
  up = 10 ^ digits
  x = x * up
  y = floor(x)
  indices = tail(order(x-y), round(sum(x)) - sum(y))
  y[indices] = y[indices] + 1
  y/up
}

#' Obtain Northerly Wind Speed Vector
#'
#' Decomposes a directional wind speed vector into its northerly speed
#'
#' @param speed Numeric; wind speed associated with the angle
#' @param angle Numeric; wind directional angle associated with the speed.
#' @param digits Numeric; how many decimal places to round to? Passed to [base::round()] and defaults to 1
#' @details The `angle` represents degrees from exactly northerly wind:
#'   * `angle = 0`: exactly northerly wind (i.e., from north to south, blowing in your face standing north)
#'   * `angle = 45`: exactly northeasterly wind
#'   * `angle = 180`: exactly southerly wind
#' @note The calculation performed is:
#'   \deqn{\text{speed} \cdot \text{cos}(\pi\cdot\frac{\text{angle}}{180})}
#' @return A numeric value representing the vector of northerly wind speed.
#'   Positive values correspond to northerly winds, negative values to southerly winds.
#'   The absolute magnitude of the number corresponds to the speed in the north or south direction.
#' @source G. Decossas provided this formula based on some previous work.
#' @export

get_Nwind = function(speed, angle, digits = 1) {
  round(speed * cos(pi * angle/180), digits = digits)
}

#' Obtain Easterly Wind Speed Vector
#'
#' Decomposes a directional wind speed vector into its easterly speed
#'
#' @param speed Numeric; wind speed associated with the angle
#' @param angle Numeric; wind directional angle associated with the speed.
#' @param digits Numeric; how many decimal places to round to? Passed to [base::round()] and defaults to 1
#' @details The `angle` represents degrees from exactly northerly wind:
#'   * `angle = 0`: exactly northerly wind (i.e., from north to south, blowing in your face standing north)
#'   * `angle = 45`: exactly northeasterly wind
#'   * `angle = 180`: exactly southerly wind
#' @note The exact calculation performed is:
#'   \deqn{\text{speed} \cdot \text{sin}(\pi\cdot\frac{\text{angle}}{180})}
#' @return A numeric value representing the vector of easterly wind speed.
#'   Positive values correspond to easterly winds, negative values to westerly winds.
#'   The absolute magnitude of the number corresponds to the speed in the east or west direction.
#' @source G. Decossas provided this formula based on some previous work.
#' @export

get_Ewind = function(speed, angle, digits = 1) {
  round(speed * sin(pi * angle/180), digits = digits)
}

#' Obtain the "Period" of the Season the Record Falls In
#'
#' Quickly assigns a time period (three-levels) of the season
#' based on the date
#'
#' @param x Either a numeric value representing days past May 31 that year
#'   or a date object, which will be coerced to days past May 31 prior to the calculation.
#' @return The period number corresponding to the input date(s) supplied to `x`:
#'   * `1`: June 12 - June 19; first week of drift fishing allowed.
#'   * `2`: June 20 - June 30; remainder of June.
#'   * `3`: July 1 - July 30; any date in July.
#'   * `NA`: if the date does not fall in any of these periods.
#' @export

get_period = function(x) {

  # convert to "days past may 31 if necessary and possible
  if (class(x) %in% c("numeric", "integer")) {
    day = x
  } else {
    if (class(x) == "Date") {
      day = to_days_past_may31(x)
    } else {
      stop ("x must be a numeric or Date object")
    }
  }

  # build the days in each period
  d1 = 12:19  # first week of drift fishing
  d2 = 20:30  # remainder of June
  d3 = 31:60  # any date in July

  # build the period indicators
  p1 = rep(1, length(d1)); names(p1) = d1
  p2 = rep(2, length(d2)); names(p2) = d2
  p3 = rep(3, length(d3)); names(p3) = d3
  period_key = c(p1, p2, p3)

  # determine which period this day is in
  period = period_key[as.character(day)]

  # return the period found
  return(unname(period))
}

#' @title Obtain Prediction Errors and Summaries
#'
#' @param yhat Numeric vector of predicted values.
#' @param yobs Numeric vector of observed values.
#' @note If `yhat` and `yobs` are of unequal lengths, the function will fail with a useful error message.
#' @return A [`list`][base::list] object with elements `$error` (`yhat - yobs`), `$p_error` (`(yhat - yobs)/yobs`), and `$summary`.
#'   `$summary` is a named vector with elements:
#'   * `RHO` -- Pearson correlation coefficient between `yhat` and `yobs`.
#'   * `RMSE` -- Root mean squared error: `sqrt(mean(error^2))`.
#'   * `ME` -- Mean error: `mean(error)`.
#'   * `MAE` -- Mean absolute error: `mean(abs(error))`.
#'   * `MPE` -- Mean proportional error: `mean(p_error)`.
#'   * `MAPE` -- Mean absolution proportional error: `mean(abs(p_error))`.
#' @export

get_errors = function(yhat, yobs) {

  # return an error if the two input vectors are unequal lengths
  if (length(yhat) != length(yobs)) {
    stop ("yhat and yobs must be of equal length")
  }

  # calculate raw errors
  error = yhat - yobs

  # calculate proportional errors
  p_error = error/yobs

  # calculate summaries and return
  list(
    error = error,
    p_error = p_error,
    summary = c(
      RHO = cor(yhat, yobs),
      RMSE = sqrt(mean(error^2)),
      ME = mean(error),
      MAE = mean(abs(error)),
      MPE = mean(p_error),
      MAPE = mean(abs(p_error))
    )
  )
}
