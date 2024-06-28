# *NEWS*

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
