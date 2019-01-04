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
  ckanr_setup(url = "http://apidatosabiertos.laspalmasgc.es/")
}

#' Categories of open data available on the City Council of Las Palmas de Gran Canaria.
#'
#' @export
#'
#' @examples
#' openlpgc_categories
lpgc_show_categories <- ckanr::group_list(as = "table")


lpgc_categories <- function(category) {
  # Check if category is a character vector
  if(!is.character(category)) stop("category must be a character vector")
  if(length(category) != 1) stop("category must contain a character vector of length 1")

  # Check if any category is not available
  is_cat_available <- category %in% lpgc_show_categories
  if(!is_cat_available) {
    stop(paste("Category", category[!is_cat_available] ,"is not available. Please check lpgc_show_categories to check the available ones.", sep = " "))
  }

  # Show all packages from this category
  cats <- ckanr::group_show(category)$packages

  # Get metadata
  author <- extract_metadata(category = cats, func = extract_author)
  maintainer <- extract_metadata(category = cats, func = extract_maintainer)
  id <- extract_metadata(category = cats, func = extract_id)
  name <- extract_metadata(category = cats, func = extract_name)
  notes <- extract_metadata(category = cats, func = extract_notes)
  created <- extract_metadata(category = cats, func = extract_created)

  # Create tibble with main info
  df <-
    tibble(author = author,
         maintainer = maintainer,
         id = id,
         name = name,
         notes = notes,
         created = created)

  df

}
