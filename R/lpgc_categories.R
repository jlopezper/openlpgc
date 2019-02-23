#' Categories of open data available on the City Council of Las Palmas de Gran Canaria.
#'
#' @export
#'
#' @examples
#' lpgc_show_categories
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
    return(stop(paste("Category", category[!is_cat_available] ,"is not available. Please check lpgc_show_categories to check the available ones.", sep = " ")))
  }

  # Show all packages from this category
  results <- ckanr::group_show(category)$packages

  # Get metadata
  ids <- lapply(results, function (x) x$id)
  final_df <- dplyr::bind_rows(lapply(ids, function(x) extract_metadata(x)))

  final_df
}
