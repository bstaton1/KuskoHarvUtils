# KuskoHarvUtils  <img src="man/figures/sticker/KuskoHarvUtils-logo.png" align="right" height=200px/>

> Provides supporting functions for the ['KuskoHarvEst'](https://www.github.com/bstaton1/KuskoHarvEst), ['KuskoHarvData'](https://www.github.com/bstaton1/KuskoHarvData), and ['KuskoHarvPred'](https://www.github.com/bstaton1/KuskoHarvPred) packages, all of which focus on different aspects of processing data collected by the Lower Kuskokwim River In-season Subsistence Salmon Harvest Monitoring Program.

## Example Functions

### Date Processing

**NOTE**: _These are due for streamlining and may change. See [#3](https://github.com/bstaton1/KuskoHarvUtils/issues/3)._

| Function                 	| Description                                                                                                                                                                                                                           	|
|--------------------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| `combine_datetime()`     	| Combines character dates and times to object of class `"POSIXct/POSIXt"`, for processing using ['lubridate'](https://lubridate.tidyverse.org/). For example, `combine_datetime("6/12/2024", "16:35")` gives `"2024-06-12 16:35:00 AKDT"`.     	|
| `basic_date()`           	| Converts an object of class `"POSIXct/POSIXt"` to character output that is easier to read for humans. For example, `basic_date("2024-06-12 16:35:00 AKDT")` gives `"6/12/2024"`.                                                              	|
| `file_date()`            	| Converts an object of class `"POSIXct/POSIXt"` to a character output that is useful for building file names. For example, `file_date("2024-06-12 16:35:00 AKDT")` gives `"2024_06_12"`.                                                       	|
| `short_datetime()`       	| Converts an object of class `"POSIXct/POSIXt"` to a character output that is in a short format. For example, `short_datetime("2024-06-12 16:35:00 AKDT")` gives `"4:35 PM"`, and setting `include_date = TRUE` would give `"4:35 PM (6/12)"`. 	|
| `to_days_past_may31()`   	| Converts an object of class `date` to the number of days past May 31. For example, `to_days_past_may31(lubridate::as_date("2024-06-12"))` gives `12`.                                                                                 	|
| `from_days_past_may31()` 	| Creates an object of class `date` based on the number of days past May 31 and a year. For example, `from_days_past_may31(12, 2024)` gives `"2024-06-12"`.                                                                             	|

### Formatting

| Function          	| Description                                                                                                                                                                                                                                                                                           	|
|-------------------	|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| `smart_round()`   	| Rounds a vector such that the sum of the rounded vector equals the sum of the unrounded vector; useful in rounding percentages. Copied verbatim from [Stack Overflow](https://stackoverflow.com/questions/32544646/round-vector-of-numerics-to-integer-while-preserving-their-sum/35930285#35930285). 	|
| `percentize()`    	| Converts a numeric proportion (e.g., `0.25`) to a percentage value (e.g., `"25%"`), with the ability to auto-escape (`"\\%"`) for printing in LaTeX output and to correctly display rounded values (e.g., `0.0001` will become `"<1%"` by default, rather than `"0%"`).                            	|
| `kable_replace()` 	| Substitutes a `replacement` for a matched `pattern` in an object of class `"knitr_kable"`; useful in tweaking things not accessible through the standard `knitr::kable() \|> kableExtra::fn()` toolchain (_only for LaTeX output_).                                                	|
| `tiny_ci()`       	| Converts cells that would be displayed as `mean (lwrCI-uprCI)` to have the interval be smaller than the mean, with option included to place a line break between them (_only for LaTeX output_).                                                                                                      	|
