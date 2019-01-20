require(ckanr)

ckanr_setup(url = "http://apidatosabiertos.laspalmasgc.es/")

package_list(as = "table", limit = 1e10)

categories <- group_list(as = "table")

tags <- tag_list(as = 'table')

head(tags, 50)

tag_show("6f20cde0-45e7-426e-b429-b9489e013c81")

x <- ckanr::group_show("salud")

x$packages[[1]]

x <- package_show(id = "1d9867a8-4027-44b4-8f79-18deb0dee359")

str(x$resources, max.level = 2)

df <- readr::read_csv(x$resources[[1]]$url)


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


#' Dataset available for each category
#'
#' @param category Category of interest according to \code{lpgc_show_categories}
#'
#' @return A \code{\link[tibble]{tibble}} with author, maintainer, id, name, extra notes and creation date.
#' @export
#'
#' @examples
#' (df <- lpgc_categories("salud"))
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
  final_df <- extract_metadata(packages = results)
  final_df
}



lpgc_keywords <- function(keywords) {
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
