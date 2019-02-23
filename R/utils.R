ckanr::ckanr_setup(url = "http://apidatosabiertos.laspalmasgc.es/")


#' Function to test if datasets have the proper quality
#'
#' @param test_type Should be 'empty' for testing if data slot is empty and 'read' for testing if each dataset can be read.
#'
#' @return Proportion of datasets passing the specified test
test_quality_datasets <- function(test_type) {
  # Empty: check proportion of datasets which has no data
  # Read: check proportion of datasets which cannot be read
  if(!test_type %in% c("empty", "read")) stop("Only 'empty' and 'read' values allowed")

  search_results_id <- sapply(ckanr::package_search(rows = 300)$results, "[[", "id")

  check_if <- sapply(search_results_id, function(x) {
    message("Trying to read id: ", x)
    if(test_type == "empty") {
      try_read <- try(lpgc_load(x))
      ifelse(inherits(try_read, "try-error"), FALSE, TRUE)
    } else {
      df <- lpgc_load(id = x)
      ifelse(length(df$data) == 0, FALSE, TRUE)
    }
  })

  return(sum(check_if)/length(search_results_id))
}

