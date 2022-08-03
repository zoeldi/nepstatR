#' Text file processing in chunks
#'
#' @description Given a large text file (possibly larger than available RAM), this function applies
#' a user-defined function on the data. The processing is done in a selected size of smaller chunks,
#' so the user does not have to read the entire data set before manipulating it.The function supports
#' baseR, dplyr and data.table syntax as well.
#'
#' @param file_name String of path and name of the text file to be processed in chunks.
#' @param chunksize Integer of the maximal number of rows to be processed in each chunk.
#' @param todo A function describing the process to be applied to a chunk.
#'
#' @return A data.table including the results from the chunks.
#' @export
#'
#' @examples
#' \dontrun{
#' # subset with data.table syntax
#' filter1 <- function(x){x[COLUMN_1 == 'Some Value', .(COLUMN_1, COLUMN_2)]}
#'
#' dt1 <- chunkwise(file_name = 'C:/Users/USERNAME/Desktop/largedata.csv',
#'                  chunksize = 10000L,
#'                  todo = filter1)
#'
#' # subset with dplyr syntax
#' filter2 <- function(x){x %>%
#'                          filter(COLUMN_1 == 'Some Value') %>%
#'                          select(COLUMN_1, COLUMN_2)
#'                          }
#'
#' dt2 <- chunkwise(file_name = 'C:/Users/USERNAME/Desktop/largedata.csv',
#'                  chunksize = 10000L,
#'                  todo = filter2)
#'                  }
chunkwise <- function(file_name,
                      chunksize,
                      todo)
  {

  # Create connection to file
  file_conn = file(description = file_name,
                   open = 'r')

  # Get column names
  c_names = colnames(data.table::fread(file = file_name,
                                       colClasses = 'character',
                                       nrows = 0))

  # Initiate store for chunks
  chunkstore = list()

  # Initiate counter for loop
  iter = 1

  # Start loop
  repeat{

    # If first iteration: header is included
    if (iter == 1) {

      message('Iteration: 1')

      chunk = data.table::fread(text = readLines(con = file_conn,
                                                 n = chunksize),
                                header = T,
                                colClasses = 'character')

      chunk_n = nrow(chunk) + 1

    }
    # Otherwise header has to be added
    else {

      chunk = data.table::fread(text = readLines(con = file_conn,
                                                 n = chunksize),
                                col.names = c_names,
                                header = F,
                                colClasses = 'character')

      chunk_n = nrow(chunk)
    }
    # If chunk is emmpty then the file is over: break
    if (chunk_n == 0) {

      message('Process ended at ', iter, '. iteration')

      break

    }
    # Else if chunk is not empty but smaller than chunksize, do what has to be done
    # and then break, because the next chunk would be empty
    else if (chunk_n < chunksize) {

      chunkresult = todo(chunk)

      chunkstore[[paste0('iter_', iter)]] = chunkresult

      message('Process ended at ', iter, '. iteration')

      break

    }
    # otherwise the process should be repeated
    else {

      chunkresult = todo(chunk)

      chunkstore[[paste0('iter_', iter)]] = chunkresult

      iter = iter + 1

      message('Iteration: ', iter)
    }

  }

  # Bind results of each chunk
  finalresult = data.table::rbindlist(chunkstore,
                                      fill = TRUE)

  # Close connection to file
  close(file_conn)

  # Return result
  return(finalresult)
}
