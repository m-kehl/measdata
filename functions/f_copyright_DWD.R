f_copyright_DWD <- function(){
  #' copywrite message
  #'
  #' write DWD copywrite message using Unicode character for copyright sign
  #' @return A list object which contains a character of the copywrite message
  #' @examples
  #' library(shiny)
  #' copywrite <- f_copyright_DWD();
  #'
  #'
  p("Datenbasis: \u00A9 Deutscher Wetterdienst (opendata.dwd.de)")
}
