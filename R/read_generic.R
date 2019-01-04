id = "dfec7f1a-d522-4fa9-8712-4aa308eeeab6"

formats_id <- function(id) {
  pck_resources <- ckanr::package_show(id)$resources
  formats <- toupper(sapply(pck_resources, function(x) x[["format"]]))
  formats
}

formats_id(id)


format_read <- function(id) {
  file_format <- formats_id(id)
  # Allowed formats, in preference order
  allowed_formats <- c("CSV", "XLS", "XLSX")

  if (any(!is.na(match(file_format, allowed_formats)))) {
    file_format <- file_format[order(match(file_format, allowed_formats))][[1]]
  } else {
    file_format <- character(0)
  }

  file_format
}


determine_read_generic <- function(id) {

  fun_read <- format_read(id)

  read_generic <-
    switch(fun_read,
           "CSV" = readr::read_csv,
           "XLS" = readxl::read_excel,
           "XLSX" = readxl::read_excel,
           function() stop())
  # If cannot find delimiter, return an error that will be called
  # when the function is used. Because this read generic will be called
  # under try in extract_data, the error will suggest that the data cannot be read
  # and just return the meta data
  read_generic
}
