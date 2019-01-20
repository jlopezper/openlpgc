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
extract_format <- extract_generator("format")


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



extract_data <- function(id) {
  # Resources of specified id
  resources <- ckanr::package_show(id)$resources
  # Formats available in that package
  formats_pkg_available <- extract_all_categories(category = resources,
                                                  func = extract_format)
  # Format to read, based on own preference
  format_to_read <- format_read(id)
  # Get index
  index <- which(formats_pkg_available %in% format_to_read)
  # Which function it has to use in order to read the url
  function_to_read <- determine_read_generic(id)

  if(length(index) == 1) {
    # Get tibble with the data
    final_df <- tibble::as_tibble(function_to_read(resources[[index]]$url))
  } else {
    url <- vector(mode = "list", length = length(index))
    name <- vector(mode = "list", length = length(index))

    for (i in seq_along(index)) {
      url[[i]] <- resources[[i]]$url
      name[[i]] <- resources[[i]]$name
    }

    final_df <- lapply(url, function(x) {tibble::as_tibble(function_to_read(x))})
    names(final_df) <- name
  }
  final_df
}




