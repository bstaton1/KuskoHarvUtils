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
  if (all(is.na(x))) {
    out = x
  } else {
    up = 10 ^ digits
    x = x * up
    y = floor(x)
    indices = tail(order(x-y), round(sum(x)) - sum(y))
    y[indices] = y[indices] + 1
    out = y/up
  }
  return(out)
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

#' Obtain the 'Pretty Name' of a Variable
#'
#' For printing axis labels, etc.
#'
#' @param var The variable name. Returns `NA` if not a valid variable.
#' @param escape Should percent symbols be escaped and `"^2"` converted to `"\\textsuperscript{2}"`? Defaults to `FALSE`.
#' @param is_title Should title case be used? Defaults to `TRUE`.
#'     Either way, proper capitalization of "Chinook" and "BTF" will always be respected.
#' @param long_species_comp Should "Percent Salmon Species Composition" be used in place of "% Spp"?
#' @export

get_var_name = function(var, escape = FALSE, is_title = TRUE, long_species_comp = FALSE) {

  # set a nice name for the standard variables
  var_name = switch(var,
                    "effort" = "Trips/Day",
                    "total_cpt" = "Catch/Trip",
                    "chinook_comp" = "% Chinook",
                    "chum_comp" = "% Chum",
                    "sockeye_comp" = "% Sockeye",
                    "day" = "Day",
                    "I(day^2)" = "Day^2",
                    "hours_open" = "Hours Open",
                    "fished_yesterday" = "Fished Yesterday",
                    "fished_yesterdayTRUE" = "Fished Yesterday",
                    "fished_yesterdayFALSE" = "Did Not Fish Yesterday",
                    "weekend" = "Weekend",
                    "weekendTRUE" = "Weekend",
                    "weekendFALSE" = "Not Weekend",
                    "p_before_noon" = "% Before Noon",
                    "total_btf_cpue" = "BTF CPUE",
                    "chinook_btf_comp" = "BTF % Chinook",
                    "I(chinook_btf_comp^2)" = "BTF % Chinook^2",
                    "chum_btf_comp" = "BTF % Chum",
                    "I(chum_btf_comp^2)" = "BTF % Chum^2",
                    "sockeye_btf_comp" = "BTF % Sockeye",
                    "I(sockeye_btf_comp^2)" = "BTF % Sockeye^2",
                    "chinook_harv" = "Chinook Harvest",
                    "chum_harv" = "Chum Harvest",
                    "sockeye_harv" = "Sockeye Harvest",
                    NA
  )

  # add long text about species comp if instructed
  if (long_species_comp & stringr::str_detect(var, "comp")) {
    var_name = paste0(var_name, " Salmon Species Composition") |>
      stringr::str_replace("\\%", "Percent")
  }

  # escape latex symbols if requested
  if (escape) {
    var_name = var_name |>
      stringr::str_replace("\\%", "\\\\%") |>
      stringr::str_replace("\\^2", "\\\\textsuperscript{2}")
  }

  # convert to title case if requested
  if (!is_title) {
    var_name = tolower(var_name) |>
      stringr::str_replace("chinook", "Chinook") |>
      stringr::str_replace("btf", "BTF")
  }

  return(var_name)
}

#' Make Period Labels
#'
#' Quickly obtains range of dates included in each period.
#'
#' @param last_day Numeric; last day to use as the end of the July period. Must be >= 31
#' @return Character vector with the date ranges for each period, as defined by [KuskoHarvUtils::get_period()]
#' @export

make_period_labels = function(last_day = KuskoHarvUtils::to_days_past_may31(lubridate::as_date("2023-07-31"))) {

  # error handles
  if (length(last_day) != 1) stop ("last_day must be a single number >= 31")
  if (last_day < 31) stop ("last_day must be >= 31")

  # create the vector of days to place into periods
  d = 12:last_day

  # place each day into a period
  p = KuskoHarvUtils:::get_period(d)

  # get the date of each day
  dt = KuskoHarvUtils::from_days_past_may31(d, year = 2023)

  # make a nice month/day label
  dy = lubridate::day(dt); mn = lubridate::month(dt)
  dt2 = paste0(mn, "/", dy)

  # extract those at the start and end of each period, and combine with a -
  labels = sapply(sort(unique(p)), function(i) paste(dt2[range(which(p == i))], collapse = "-"))

  # assign the labels names corresponding to the period code
  names(labels) = sort(unique(p))

  # return the output
  return(labels)
}
