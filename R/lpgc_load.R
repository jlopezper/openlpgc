lpgc_load <- function(id) {
  returned_df <-
    structure(
      list(
        metadata = extract_metadata(list(ckanr::package_show(id))),
        data = extract_data(id)
      )
    )
  returned_df
}
