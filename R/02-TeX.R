# ::::::::::::::::::::::::::::::::::::::::::::::::::: #
# FUNCTIONS THAT HELP WITH FORMATTING CONTENT FOR TEX #
# ::::::::::::::::::::::::::::::::::::::::::::::::::: #

#' Make the CI part of a summary smaller text than the mean
#'
#' Adds the appropriate LaTeX code to a summary produced by
#'   [report()] to make the CI portion smaller than the mean portion.
#'   This is a nice touch for tabular output.
#'
#' @param x Character; the output of [report()]
#' @param linebreak Logical; should a linebreak be inserted between the mean portion and the CI portion?
#' @export


tinyCI = function(x, linebreak = TRUE) {
  # if x has CIs
  if (stringr::str_detect(x, "\\(")) {
    # build the replacement text
    replacement = paste0("\\footnotesize{", stringr::str_extract(x, "\\(.+\\)"), "}")

    # extract the mean part
    x = stringr::str_extract(x, "^.+ \\(")

    # paste on the CI replacement text
    x = paste0(substr(x, 1, nchar(x) - 1), replacement)

    # include the latex code to put the CI on a new line if in a table cell
    if (linebreak) {
      x = stringr::str_replace(x, " \\\\f", "\n\\\\f")
      x = kableExtra::linebreak(x, align = "c")
    }
    return(x)
  } else {
    return(x)
  }
}

#' Replace Text in a kable Object
#'
#' Sometimes something needs to be altered
#' in the TeX code after the kable object is built.
#'
#' @param kable_input The output of a Output of a `knitr::kable() |> kableExtra::fn()` chain.
#' @param pattern Pattern to look for -- interpreted as a regular expression. See [stringr::str_replace()].
#' @param replacement Replacement value.
#' @export

kable_replace = function(kable_input, pattern, replacement) {
  kable_input_new = stringr::str_replace(as.character(kable_input), pattern = pattern, replacement = replacement)
  class(kable_input_new) = class(kable_input)
  attributes(kable_input_new) = attributes(kable_input)
  return(kable_input_new)
}

#' A function to add vspace to the bottom of a kable
#'
#' @inheritParams kable_replace
#' @param space Character; LaTeX units and magnitude of space to include in a vspace
#'   call at the bottom of the table
#' @details This function should be called as the last step in the chain of commands.
#' @export

add_vspace = function(kable_input, space = "-1em") {
  kable_replace(
    kable_input = kable_input,
    pattern = "end\\{tabular\\}",
    replacement = stringr::str_replace("end\\{tabular\\}\\\n\\\\vspace{SPACE}", "SPACE", space)
  )
}
