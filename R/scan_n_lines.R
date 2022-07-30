
#' Fast number of rows in text file
#'
#' @param file The name of the text file to be scanned
#'
#' @return Integer of row number
#' @export
#'
#' @examples scan_n_lines("test.csv")
scan_n_lines <- function(file){
  # Run command line and recieve second element
  cmd_return = system(paste0('find /v /c "" ', file), intern = T)[2]
  # Cut the number from return
  n_lines = strsplit(cmd_return, ': ')[[1]][2]
  # Return count as integer
  return(as.integer(n_lines))
}
