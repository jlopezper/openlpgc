context("test-lpgc_search")

test_that("return message when keywords do not exists", {
  expect_message(lpgc_search("ninguno"), "No datasets available with these keywords")
})


test_that("get error when keyword is not a character vector of length 1", {
  expect_error(lpgc_search(c("uno", "dos")))
  expect_error(lpgc_search(1))
  expect_error(lpgc_search(c(1, 2)))
})

test_that("check formats and classes", {
  expect_is(lpgc_search("medio ambiente"), "tbl_df")
})
