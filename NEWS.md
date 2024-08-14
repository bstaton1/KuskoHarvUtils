# *NEWS*

# KuskoHarvUtils 0.2.0 (2024-08-13)

This version update is to serve as an easy permanent reference -- see the [v0.2.0 release](https://www.github.com/bstaton1/KuskoHarvUtils/releases/tag/v0.2.0) for more details.
Several minor updates were made to the package README, including a new grouped package hexsticker logo. No changes in functionality from v0.1.6.

# KuskoHarvUtils 0.1.6 (2024-07-17)

A variety of axis function improvements.

* Improved axis functions -- `col` argument was not working properly
* `draw_axis_line()` now relies on `axis()` and thus now produces an undetectable result (previously the line was too thin, even when `xpd = TRUE` was used).
* Added `draw_regular_axis()`, to enable using the same axis drawing framework, even if the labels don't need special calculations prior to drawing.

# KuskoHarvUtils 0.1.5 (2024-07-14)

* Added a CSS style sheet for standardized KuskoHarv package vignettes
* Added the map figure, allows it to be used easily from anywhere
* Moved all axis functions from 'KuskoHarvPred' ([#9](https://github.com/bstaton1/KuskoHarvUtils/issues/9))
  * `draw_day_axis()`
  * `draw_percent_axis()`; also added an optional `at` argument to allow bypassing `grDevices::axisTicks()`
  * `draw_yn_axis()`
  * `draw_axis_line()`
  * `choose_axis_type()`

# KuskoHarvUtils 0.1.4 (2024-07-05)

* Fine-tuning of `get_var_name()`: "CPUE" will always be capitalized, and "Total Harvest" is now recognized as a variable.
* Fixed bug in help file of `to_days_past_may31()`.
* Added a `replace_all = TRUE/FALSE` argument to `kable_replace()`.
* Cleaned/updated all Roxygen documentation.
* Added package README

# KuskoHarvUtils 0.1.3 (2024-06-26)

* Added a `FUN` argument to `get_errors()`, which is used to set the function used to calculate error summaries; previously this was hard-coded to be `mean()` in the function body. Now the default is `median(error)`.

# KuskoHarvUtils 0.1.2 (2024-06-16)

* Created the `get_var_names()` function, which previously was in 'KuskoHarvPred', but belongs here more
* Created the `make_period_labels()` function, which previously was in the 'KuskoHarvPred-ms' project, but belongs here more as well.
* These changes are documented in [#7](https://github.com/bstaton1/KuskoHarvUtils/issues/7)

# KuskoHarvUtils 0.1.1 (2023-07-08)

* Created the `kable_replace()` utility function, which is now used by `KuskoHarvUtils::add_vspace()` and makes permanent what was previously a temporary fix in `KuskoHarvEst:::make_harvest_sensitivity_table()`.
This function solves a general problem, and I thought that it belonged here rather than buried in a non-exported table-generating function ([#4](https://github.com/bstaton1/KuskoHarvUtils/issues/4)).
* `KuskoHarvUtils::smart_round()` no longer returns `Error in checkHT(n, dx <- dim(x))` error if all `x` are `NA`. Instead, it returns the vector it was provided.

# KuskoHarvUtils 0.1.0 (2023-01-31)

This package was initialized by moving source code for a variety of utility from three other packages: 'KuskoHarvEst', 'KuskoHarvData', and 'KuskoHarvPred'.
It was deemed desirable to move these functions to a separate package because they are not specific to any one package, but are used throughout this family of packages.

This list of functions includes:

**From 'KuskoHarvEst'**

`percentize()`, `basic_date()`, `combine_datetime()`, `short_datetime()`, `tinyCI()`, `capitalize()`, `file_date()`, `smart_round()`, and `add_vspace()`

**From 'KuskoHarvData'**

`to_days_past_may31()`, `from_days_past_may31()`, `get_period()`, `get_Nwind()`, and `get_Ewind()`

**From 'KuskoHarvPred'**

`get_errors()`
