f_updateselectize_parameters <- function(session,id,granularity,parameters,mess_country){
  ## function to update selectizeInput so it adapts itself to available data
  #    per granularity
  # - session:     Shiny session
  # - id:          character; objects id of selectizeInput to adapt
  # - granularity: character; to define which data granularity is active
  #                          options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  # - parameters:  array; name/s of parameters which are selected (characters)

  ## source input data
  source(paste0(getwd(),"/input.R"),local = TRUE)
  ## define column to take from input data
  if (mess_country == "Schweiz"){
    country <- "mch"
  } else{
    country <- "dwd"
  }
  dwd_name <- paste0(country,"_name_",granularity)
  ## update
  updateSelectizeInput(session,id,
                       choices = meteo_parameters$parameter[meteo_parameters[dwd_name][[1]] != "XX"],
                       selected = parameters)
}
