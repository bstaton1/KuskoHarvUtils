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
#'

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
#'   first character should be converted to uppercase

capitalize = function (x) {
  if (!is.character(x)) stop("x must be of class 'character'")
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

smart_round = function(x, digits = 0) {
  # copied from https://stackoverflow.com/a/35930285/3911200
  up = 10 ^ digits
  x = x * up
  y = floor(x)
  indices = tail(order(x-y), round(sum(x)) - sum(y))
  y[indices] = y[indices] + 1
  y/up
}



