# TEST CASES THAT SHOULD GIVE AN ERROR DUE TO INCORRECT VARIABLE CLASS
error_msg <- 'Incorrect grouping variable class. Ensure all group_vars are of class chr, fct, or date'

testthat::test_that('Error for non-categorical grouping variable(s)', {
  testthat::expect_error(count_obs(datateachr::vancouver_trees, 'diameter'), error_msg)
  testthat::expect_error(count_obs(datateachr::vancouver_trees, c('neighbourhood_name', 'diameter')), error_msg)
  testthat::expect_error(count_obs(datateachr::vancouver_trees, c('latitude', 'longitude', 'diameter')), error_msg)
})

# OTHER TEST CASES THAT SHOULD GIVE AN ERROR
testthat::test_that('Test other cases that should give an error', {
  testthat::expect_error(count_obs(datateachr::vancouver_trees, 'country')) # 'country' is not a variable in vancouver_trees dataset
  testthat::expect_error(count_obs(datateachr::vancouver_trees, neighbourhood_name)) # group_vars is not a character vector
  testthat::expect_error(count_obs(1, 2)) # nonsense inputs to both parameters
  testthat::expect_error(count_obs(datateachr::vancouver_trees)) # missing group_vars
})

# ENSURE FUNCTION EXECUTES AND RETURNS A TIBBLE WHEN APPROPRIATE VALUES ARE PASSED TO data AND group_vars
return_class <- c("tbl", "tbl_df", "data.frame")

testthat::test_that('Test cases that should work and return a tibble', {
  testthat::expect_s3_class(count_obs(datateachr::vancouver_trees, 'genus_name'), return_class)
  testthat::expect_s3_class(count_obs(datateachr::vancouver_trees, c('species_name', 'genus_name')), return_class)
  testthat::expect_s3_class(count_obs(datateachr::vancouver_trees, c('neighbourhood_name', 'genus_name', 'species_name',
                                               'date_planted')), return_class)
})

# ENSURE FUNCTION RETURNS IDENTICAL TIBBLE TO THAT OBTAINED MANUALLY
test_1var <- datateachr::vancouver_trees %>%
  dplyr::group_by(neighbourhood_name) %>%
  dplyr::summarise(num_obs = dplyr::n(), .groups = 'drop')

test_2var <- datateachr::vancouver_trees %>%
  dplyr::group_by(neighbourhood_name, species_name) %>%
  dplyr::summarise(num_obs = dplyr::n(), .groups = 'drop')

test_3var <- datateachr::vancouver_trees %>%
  dplyr::group_by(neighbourhood_name, species_name, date_planted) %>%
  dplyr::summarise(num_obs = dplyr::n(), .groups = 'drop')

testthat::test_that('Compare to manual computations', {
  testthat::expect_identical(test_1var,count_obs(datateachr::vancouver_trees, 'neighbourhood_name'))
  testthat::expect_identical(test_2var,count_obs(datateachr::vancouver_trees, c('neighbourhood_name', 'species_name')))
  testthat::expect_identical(test_3var,count_obs(datateachr::vancouver_trees, c('neighbourhood_name', 'species_name', 'date_planted')))
})

rm(error_msg)
rm(return_class)
rm(test_1var)
rm(test_2var)
rm(test_3var)
