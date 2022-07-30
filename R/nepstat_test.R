#' Package test
#'
#' @return Message with status and current time
#' @export
#'
#' @examples nepstat_test()
nepstat_test <- function() {
  currtime = Sys.time()
  message('The package us up to date and working correctly!')
  message(paste('Current time:', currtime))
}
