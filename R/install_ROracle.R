
#' Install ROracle package
#'
#' @return None
#' @export
#'
#' @examples \dontrun{install_ROracle()}
install_ROracle <- function(){
  # Is Oracle Instamt Client installed?
  if(!('oracle_x64' %in% list.files('C:/opt'))){
    stop('The Oracle Instant Client driver is missing from your computer. Contact your IT-Admin for
    the installation and try again!')
  }
  else if('ROracle' %in% utils::installed.packages()){
    stop('It seems that \'ROracle\' is already installed on your computer')
  }
  else {
    # Set proxy for downloading
    Sys.setenv(http_proxy = "http://fproxy.kshad.hu:8080")
    Sys.setenv(https_proxy = "http://fproxy.kshad.hu:8080")

    # Copy SDK from ora disk
    SDKzip = '//jupiter/ora2nt/ora6i/instantclient_11_2_x64/install/instantclient-sdk-windows.x64-11.2.0.3.0.zip'
    SDKexdir = paste0('C:/Users/', Sys.getenv('USERNAME'), '/Desktop/orasdk_temp')

    utils::unzip(zipfile = SDKzip,
                 exdir = SDKexdir,
                 overwrite = TRUE)

    # Set Sysvars
    Sys.setenv('OCI_LIB64' = '//jupiter/ora2nt/ora6i/instantclient_11_2_x64')
    Sys.setenv('OCI_INC' = paste0(SDKexdir, '/instantclient_11_2/sdk/include'))

    # Install ROracle
    utils::install.packages('ROracle')

    # Remove temporary folder from Desktop
    unlink(SDKexdir, recursive = TRUE)

    # Message
    message('The \'ROracle\' package has been succesfully installed on your computer!')
  }
}
