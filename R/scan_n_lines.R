
#' Fast number of rows in text file
#'
#' @description This function uses the windows cmd to count the number of rows in a text file (csv, txt).
#' Linux and Mac OS are not supported yet. The text file should be on the local computer, the function
#' will not work on files from remote servers.
#'
#' @param file The path and name of the text file to be scanned.
#'
#' @return Integer of row number
#' @export
#'
#' @examples scan_n_lines("C:/Users/USERNAME/Desktop/test.csv")
scan_n_lines <- function(file){
  # Run command line and receive second element
  cmd_return = system(paste0('find /v /c "" ', file), intern = T)[2]
  # Cut the number from return
  n_lines = strsplit(cmd_return, ': ')[[1]][2]
  # Return count as integer
  return(as.integer(n_lines))
}
