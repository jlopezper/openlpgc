#' Setting API connection
#'
#' @return Connection to the LPGC hometown open data website
api_conn <- function() {
  ckanr::ckanr_setup(url = "http://apidatosabiertos.laspalmasgc.es/")
}

#' Categories of open data available on the City Council of Las Palmas de Gran Canaria.
#'
#' @export
#'
#' @examples
#' openlpgc_categories
lpgc_show_categories <- ckanr::group_list(as = "table")


#' Datasets available for each category
#'
#' @param category Category of interest according to \code{lpgc_show_categories}
#'
#' @return A \code{\link[tibble]{tibble}} with author, maintainer, id, name, extra notes and creation date.
#' @export
#'
#' @examples \dontrun{df <- lpgc_categories("salud")}
#' @seealso \code{\link{lpgc_show_categories}}
lpgc_categories <- function(category) {
  # Check if category is a character vector
  if(!is.character(category)) stop("category must be a character vector")
  if(length(category) != 1) stop("category must contain a character vector of length 1")

  # Check if any category is not available
  is_cat_available <- category %in% lpgc_show_categories
  if(!is_cat_available) {
    return(message(paste("Category", category[!is_cat_available] ,"is not available. Please check lpgc_show_categories to check the available ones.", sep = " ")))
  }

  # Show all packages from this category
  results <- ckanr::group_show(category)$packages

  # Get metadata
  ids <- lapply(results, function (x) x$id)
  final_df <- dplyr::bind_rows(lapply(ids, function(x) extract_metadata(x)))

  final_df
}



#' Search datasets by keyword in the open data site of the city of Las Palmas de Gran Canaria
#'
#' @param keywords Words that describe the data that is intended to be found (in Spanish). Spaces may be included and there is no distinction between uppercase or lowercase.
#'
#' @return A \code{\link[tibble]{tibble}} with:
#' \itemize{
#'  \item Author
#'  \item Maintainer
#'  \item ID
#'  \item Name
#'  \item Notes
#'  \item Creation date
#'  }
#'
#' @export
#'
#' @examples \dontrun{lpgc_search(keywords = "medio ambiente")}
#' @seealso \code{\link{lpgc_load}}
lpgc_search <- function(keywords) {
  if(!is.character(keywords)) stop("category must be a character vector")
  keywords <- ckanr::package_search(keywords)
  if(keywords$count == 0) {
    return(message("No datasets available with these keywords"))
  } else {
    results <- keywords$results
  }

  # Get metadata
  ids <- lapply(results, function (x) x$id)
  final_df <- dplyr::bind_rows(lapply(ids, function(x) extract_metadata(x)))

  #final_df <- extract_metadata(packages = results)
  final_df
}




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

