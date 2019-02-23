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
  if(any(!is.character(keywords), !length(keywords) == 1)) stop("category must be a character vector of length 1")
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
