#' Draw an axis showing dates
#'
#' Uses date labels, but for plots with user coordinates
#' based on the number of days past May 31st.
#'
#' @param fday Numeric; the first day on the axis to draw (1 = June 1; see [to_days_past_may31()])
#' @param lday Numeric; the last day (30 = June 30; see [to_days_past_may31()])
#' @param by Numeric; interval to draw axis ticks at
#' @param side Numeric; the side of the plot to draw the axis on;
#'  1 = bottom, 2 = left, 3 = top, 4 = right
#' @param col Character; color to use for the axis line, tick marks, and tick mark labels (where applicable).
#'   Defaults to `par("col.axis")`.
#' @param ... Optional arguments to be passed to [graphics::axis()]
#' @export

draw_day_axis = function(fday, lday, by, side = 1, col = par("col.axis"), ...) {
  at = seq(fday, lday, by = by)
  date = KuskoHarvUtils::from_days_past_may31(at)
  month = lubridate::month(date)
  day = lubridate::day(date)
  lab = paste(month, day, sep = "/")
  axis(side = side, at = at, labels = lab, col = "white", col.ticks = col, ...)
  draw_axis_line(side = side, col = col)
}

#' Draw an axis showing percentages
#'
#' Uses percentage labels, but for plots with user coordinates
#' based on the proportional scale.
#'
#' @inheritParams draw_day_axis
#' @param at Numeric; optional vector to place tick marks and tick mark labels on the proportional scale.
#'   Defaults to `NULL`, in which case [grDevices::axisTicks()] is used to automatically select tick mark locations.
#' @export

draw_percent_axis = function(side, at = NULL, col = par("col.axis"), ...) {

  # if 'at' not provided, automatically determine pretty tick mark locations
  if (is.null(at)) {
    usr = par("usr")
    if (side == 1) i = c(1,2) else i = c(3,4)
    at = axisTicks(usr[i], log = FALSE)
  }

  # draw the axis
  axis(side = side, at = at, labels = paste0(at * 100, "%"), col = "white", col.ticks = col, ...)
  draw_axis_line(side = side, col = col)
}

#' Draw an axis showing yes/no categories
#'
#' Uses character labels, but for plots with user coordinates based on
#' 0 = No, 1 = Yes.
#'
#' @inheritParams draw_day_axis
#' @export

draw_yn_axis = function(side, col = par("col.axis"), ...) {
  axis(side = side, at = c(0,1), labels = c("No", "Yes"), col = "white", col.ticks = col, ...)
  draw_axis_line(side = side)
}

#' Draw an axis line with no ticks or labels
#'
#' @inheritParams draw_day_axis
#' @export

draw_axis_line = function(side, col = par("col.axis")) {
  usr = par("usr")
  if (side == 1) segments(usr[1], usr[3], usr[2], usr[3], col = col, xpd = TRUE)
  if (side == 2) segments(usr[1], usr[3], usr[1], usr[4], col = col, xpd = TRUE)
  if (side == 3) segments(usr[1], usr[4], usr[2], usr[4], col = col, xpd = TRUE)
  if (side == 4) segments(usr[2], usr[3], usr[2], usr[4], col = col, xpd = TRUE)
}

#' Auto-select the type of axis to draw
#'
#' For use in generalized plotting functions where
#' the type of variable (and thus axis) needs to change
#'
#' @param var Variable name. Must be a character vector of length 1.
#' @return Character vector of length 1; one of:
#'   * `"yn"` -- if `var %in% c("fished_yesterday", "weekend")`
#'   * `"day"` -- if `var == "day"`
#'   * `"percent"` -- e.g., if `var %in% c("chinook_comp", "btf_chinook_comp", "p_before_noon")`
#'   * `"regular"` -- otherwise
#' @export

choose_axis_type = function(var) {

  # error handle to make sure var is a single element vector
  if (length(var) > 1) stop ("var must be a vector of length 1")

  # error handle to make sure var is a character
  if (!is.character(var)) stop ("var must be a character vector")

  # set the variable names that use each specialty axis type
  yn_vars = c("fished_yesterday", "weekend")
  day_vars = c("day")
  percent_vars = c(
    "chinook_comp", "chum_comp", "sockeye_comp",
    "chinook_btf_comp", "chum_btf_comp", "sockeye_btf_comp",
    "p_before_noon"
  )

  # initialize an empty type
  type = NA
  if (is.na(type) & var %in% yn_vars) type = "yn"
  if (is.na(type) & var %in% day_vars) type = "day"
  if (is.na(type) & var %in% percent_vars) type = "percent"
  if (is.na(type)) type = "regular"

  return(type)
}
