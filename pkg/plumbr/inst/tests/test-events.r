library(testthat)

context("Events")

test_that("can add listeners", {
  a <- mutaframe(a = 1:10)
  expect_that(length(listeners(a)), equals(0))
  
  add_listener(a, function() 1)
  expect_that(length(listeners(a)), equals(1))
})

test_that("callback recieves correct info", {
  a <- mutaframe(a = 1:10)
  
  event <- NULL
  add_listener(a, function(i, j) {
    event <<- list(i = i, j = j)
  })

  a[1, 1] <- 2
  expect_that(event$i, equals(1))

  a[5, 1] <- 2
  expect_that(event$i, equals(5))

})

test_that("callback on proxied mutaframe returns correct indices", {
  a <- mutaframe(a = 1:10)
  b <- a[5:10, , drop = FALSE]
  
  event_a <- NULL
  event_b <- NULL
  add_listener(a, function(i, j) {
    event_a <<- list(i = i, j = j)
  })
  add_listener(b, function(i, j) {
    event_b <<- list(i = i, j = j)
  })

  b[1, 1] <- 2
  expect_that(event_a$i, equals(5))
  expect_that(event_b$i, equals(1))
})