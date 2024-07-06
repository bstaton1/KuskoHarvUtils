# ::::::::::::::::::::::::::::::::::::::::::::::::::: #
# FUNCTIONS THAT HELP WITH FORMATTING CONTENT FOR TEX #
# ::::::::::::::::::::::::::::::::::::::::::::::::::: #

#' Make the CI part of a summary smaller text than the mean
#'
#' Adds the appropriate LaTeX code to a summary produced by
#' [KuskoHarvEst::report()] to make the CI portion smaller than the mean portion.
#' This is a nice touch for tabular output.
#'
#' @param x Character vector; the output of [KuskoHarvEst::report()], or any character string with the format `"est (lwrCI-uprCI)"`.
#' @param linebreak Logical; should a line break be inserted between the mean portion and the CI portion?
#' @return Character vector with each element correctly formatted with LaTeX code.
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

#' Replace text in a kable Object
#'
#' Sometimes something needs to be altered
#' in the TeX code after the kable object is built.
#' This function helps with that.
#'
#' @param kable_input The output of a `knitr::kable() |> kableExtra::fn()` chain.
#' @param pattern Character; pattern to look for, passed to [stringr::str_replace()].
#' @param replacement Character; replacement value, passed to [stringr::str_replace()].
#' @param replace_all Logical; should [stringr::str_replace_all()] be used instead of [stringr::str_replace()]?
#' @return Identical to `kable_input`, but with the first instance (or all instances if `replace_all = TRUE`) of `pattern` matched on each line replaced with `replacement.`
#' @export

kable_replace = function(kable_input, pattern, replacement, replace_all = FALSE) {
  if (replace_all) f = stringr::str_replace_all else f = stringr::str_replace
  kable_input_new = f(as.character(kable_input), pattern = pattern, replacement = replacement)
  class(kable_input_new) = class(kable_input)
  attributes(kable_input_new) = attributes(kable_input)
  return(kable_input_new)
}

#' A function to add vspace to the bottom of a kable
#'
#' @inheritParams kable_replace
#' @param space Character; LaTeX units and magnitude of space to include in a `\vspace`
#'   call at the bottom of the table
#' @details This function should be called as the last step in the chain of commands.
#' @return Identical to `kable_input`, but with `\vspace{space}` appended to the end.
#' @export

add_vspace = function(kable_input, space = "-1em") {
  kable_replace(
    kable_input = kable_input,
    pattern = "end\\{tabular\\}",
    replacement = stringr::str_replace("end\\{tabular\\}\\\n\\\\vspace{SPACE}", "SPACE", space)
  )
}
