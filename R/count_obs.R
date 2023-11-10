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
#' @param group_vars Character vector containing the name(s) of the grouping variable(s). One or more
#' grouping variables may be used. The grouping variables specify which categorical variable(s) in `data`
#' the function should count observations in. The grouping variable must be of class chr, fct, or date.
#' This parameter was named `group_vars` to make it obvious that this variable should be used to specify
#' the names of the variables that should be used for grouping the data when the function is called.
#'
#' @param .groups Default value is set to FALSE.
#'
#' @return A tibble listing the number of observations of each value of a categorical variable or
#' combination of categorical variables specified in `group_vars` from the data frame `data`.
#'
#' @export
#'
#' @examples
#' library(datateachr)
#'
#' #count number of observations of one categorical variable
#' count_obs(datateachr::vancouver_trees, "neighbourhood_name")
#'
#' #count number of observations of two categorical variables
#' count_obs(datateachr::vancouver_trees, c("neighbourhood_name", "species_name"))

count_obs <- function(data, group_vars, .groups = 'drop') {
  # Make sure `data` is a data frame
  if (is.data.frame(data) == FALSE) {
    stop('`data` must be a data frame.')
  }

  # Only allow grouping by variables that belong to character, date, or factor classes
  # If any grouping variable is an incorrect class, an error message will be thrown
  i <- 1 # initialize indexing variable

  for (i in 1:length(group_vars)) { # loop to check variable classes in group_vars
    if (is.character(data[[group_vars[[i]]]]) == FALSE && is.factor(data[[group_vars[[i]]]]) == FALSE &&
        lubridate::is.Date(data[[group_vars[[i]]]]) == FALSE) {
      stop('Incorrect grouping variable class. Ensure all group_vars are of class chr, fct, or date.')
    } else {
      i <- i + 1 # if variable is correct type, move onto next variable in group_vars
    }
  }

  # Find the number observations for each group and return the summary table
  data |>
    dplyr::group_by(dplyr::pick({{ group_vars }})) |>
    dplyr::summarize(num_obs = dplyr::n(), .groups = .groups)
}
