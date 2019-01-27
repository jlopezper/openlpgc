#' Load the data from Las Palmas de Gran Canaria City Council.
#'
#' @inheritParams extract_metadata
#' @return A list with two slots:
#' \itemize{
#'  \item A \code{\link[tibble]{tibble}} with metadata provided by the site.
#'  \item If a single file, a \code{\link[tibble]{tibble}} with the data. If multiple files, a list with as many slots as files are read.
#'  }
#' @export
#'
#' @examples \dontrun{lpgc_load(id = "47ea65a4-bc0e-42e1-8bfc-8bd3508642e6")}
lpgc_load <- function(id) {
  if(!all(is.character(id), length(id) == 1)) stop("id must be a character vector of length 1")
  returned_df <-
    structure(
      list(
        metadata = tryCatch(expr = extract_metadata(id),
                            error = function(e) message("** id not found **")),
        data = tryCatch(expr = extract_data(id),
                        error = function(e) NULL)
      )
    )
  returned_df
}
