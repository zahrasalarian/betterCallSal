library(testthat)
library(stringr)
test_that("recognizing invalid dates works", {
  expect_equal(str_length(drawCovidMap("03-20-2020","Deaths")),str_length("date is not valid"))
})
