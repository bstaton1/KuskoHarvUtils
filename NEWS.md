# *NEWS*

# KuskoHarvUtils 0.1.1 (2023-07-08)

Created the `kable_replace()` utility function, which is now used by `KuskoHarvUtils::add_vspace()` and makes permanent what was previously a temporary fix in `KuskoHarvEst:::make_harvest_sensitivity_table()`.
This function solves a general problem, and I thought that it belonged here rather than buried in a non-exported table-generating function ([#4](https://github.com/bstaton1/KuskoHarvUtils/issues/4)).

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
