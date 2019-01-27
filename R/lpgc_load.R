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
