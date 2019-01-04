extract_generator <- function(feature) {
  force(feature)
  function(x_list) {
    if (!feature %in% names(x_list)) {
      return("No available")
    }

    feature <- x_list[[feature]]
    if(all(length(feature) != 1, nchar(feature) > 0)) {
      feature <- NA
    }


    feature
  }
}

extract_author <- extract_generator("author")
extract_maintainer <- extract_generator("maintainer")
extract_id <- extract_generator("id")
extract_name <- extract_generator("name")
extract_notes <- extract_generator("notes")
extract_created <- extract_generator("metadata_created")


extract_metadata <- function(category, func) {
  sapply(category, func)
}
