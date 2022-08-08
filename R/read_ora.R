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

  # Sets system time to hungarian
  Sys.setenv(NLS_LANG = "Hungarian_Hungary.AL32UTF8")
  Sys.setenv(TZ = "UTC")
  Sys.setenv(ORA_SDTZ = "UTC")

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

      error = function(e){
        rstudioapi::showDialog("Oarcle connection",
                               "Uuups... Something went wrong. Try to reconnect!")
        return(NULL)
      },

      warning = function(w){
        rstudioapi::showDialog("Oarcle connection",
                               "Uuups... Something went wrong. Try to reconnect!")
        return(NULL)
      }
    )

  if(!is.null(oracon)){
    rstudioapi::showDialog("Oarcle connection",
                           paste("<b>Welcome", username, "!</b><p>",
                           "You are connected to the", dbname, "database. Don't forget to
                               disconnect before leaving R. Have a nice query!"))
    return(oracon)

  }
}
