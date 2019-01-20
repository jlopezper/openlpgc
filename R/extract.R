extract_generator <- function(feature) {
  force(feature)
  function(x_list) {
    if (!feature %in% names(x_list)) {
      return("No available")
    }

    feature <- x_list[[feature]]
    if(any(length(feature) != 1, nchar(feature) == 0)) {
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


extract_all_categories <- function(category, func) {
  sapply(category, func)
}


extract_metadata <- function(packages) {
  # Get metadata
  author <- extract_all_categories(category = packages, func = extract_author)
  maintainer <- extract_all_categories(category = packages, func = extract_maintainer)
  id <- extract_all_categories(category = packages, func = extract_id)
  name <- extract_all_categories(category = packages, func = extract_name)
  notes <- extract_all_categories(category = packages, func = extract_notes)
  created <- lubridate::as_date(lubridate::ymd_hms(extract_all_categories(category = packages, func = extract_created)))

  # Create tibble with main info
  df <-
    tibble::tibble(author = author,
                   maintainer = maintainer,
                   id = id,
                   name = name,
                   notes = notes,
                   created = created)

  df
}

