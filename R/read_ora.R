#' Connection to the Oracle database
#'
#' @param dbname String with the name of the database. Defaults to "EMERALD".
#' @param username String with the name of the user. Defaults to current Microsoft User.
#' @param password String with the password of the user. Defaults to RStudio popup message.
#'
#' @return `oracon` which is a ROracle connection object.
#' @export
#'
#' @examples \dontrun{oracon = read_ora()}
read_ora <- function(dbname = 'EMERALD',
                     username = Sys.getenv("USERNAME"),
                     password = rstudioapi::askForPassword(prompt = "Please enter your Oracle password...")){

  # Error if ROracle is not installed. Suggest installation.
  if(!('ROracle' %in% utils::installed.packages())) {
    stop('It seems that the \'ROracle\' package is not installed on your computer. Try calling \'install_ROracle()\' first!')
  }
  else {
    # Sets system time to hungarian
    Sys.setenv(NLS_LANG = "Hungarian_Hungary.AL32UTF8")
    Sys.setenv(TZ = "Europe/Budapest")
    Sys.setenv(ORA_SDTZ = "Europe/Budapest")

    # Establishes oracle connection
    oracon =
      tryCatch(
        expr = {
          ROracle::dbConnect(DBI::dbDriver('Oracle'),
                             dbname = dbname,
                             username = username,
                             password = password
          )
        },

        # Error handling
        error = function(e){
          stop(e)
          return(NULL)
        },

        # Warning handling
        warning = function(w){
          stop(w)
          return(NULL)
        }
      )

    # Return oracon with message
    if(!is.null(oracon)){
      message(paste("Welcome", username, "!\n", "You are connected to the", dbname, "database. Don't forget to disconnect before leaving R. Have a nice query!"))
      return(oracon)

    }
  }
}
