#' @title
#' Count the Number of Observations of Categorical Variables
#'
#' @description
#' `count_obs` returns a summary tibble listing the number of observations for each value of a categorical
#' variable or combination of categorical variables in a specified data frame. The grouping variables must
#' belong to one of the following classes: chr, fct, or date.
#'
#' @param data A data frame;  this parameter was named `data` to make it obvious that this should be the
#' raw data frame from which the user wants to extract information.
#'
#' @param group_vars The grouping variable(s). One or more grouping variables may be used. The grouping
#' variables specify which categorical variable(s) in `data` the function should count observations in.
#' The grouping variable must be of class chr, fct, or date. This parameter was named `group_vars` to
#' make it obvious that this variable should be used to specify the names of the variables that should
#' be used for grouping the data when the function is called.
#'
#' @return A tibble listing the number of observations of each value of a categorical variable or
#' combination of categorical variables specified in `group_vars` from the data frame `data`.
#'
#' @export
#'
#' @examples
#' count_obs(df, categorical_variable_1)
#' count_obs(dataframe, c(var1, var2, var3))

count_obs <- function(data, group_vars, .groups = 'drop') {
  # Make sure `data` is a data frame
  if (is.data.frame(data) == FALSE) {
    stop('`data` must be a data frame.')
  }

  # Only allow grouping by variables that belong to character, date, or factor classes
  # If any grouping variable is an incorrect class, an error message will be thrown
  stopifnot(is.character(data |> pull({{group_vars}})) | is.factor(data |> pull({{group_vars}})) |
             is.Date(data |> pull({{group_vars}})))

  # Find the number observations for each group and return the summary table
  data |>
    group_by(pick({{ group_vars }})) |>
    summarize(num_obs = n(), .groups = .groups)
}
