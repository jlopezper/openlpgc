context("test-lpgc_categories")

test_that("lpgc_show_categories is not empty", {
  skip_on_cran()

  expect_gt(length(lpgc_show_categories), 0)
})

test_that("There are some packages within several categories", {
  skip_on_cran()

  category <- "vivienda"

  expect_gt(length(ckanr::group_show(category, url = "http://apidatosabiertos.laspalmasgc.es/")$packages), 0)
  expect_is(ckanr::group_show(category, url = "http://apidatosabiertos.laspalmasgc.es/")$packages, "list")
  expect_is(lpgc_categories(category), "tbl_df")
  expect_error(lpgc_categories("ninguna"),
               "Category ninguna is not available. Please check lpgc_show_categories to check the available ones."
  )
})
