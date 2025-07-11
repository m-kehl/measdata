f_read_mess_CH <- function(name,mess_meta_CH,granularity){

  #check whether data is already loaded
  if (!exists("data_mess_all")){
    data_mess_all <<- NULL
    names_new <- name
  } else{
    data_mess_all <<- data_mess_all[data_mess_all$name %in% name,]
    names_old <- unique(data_mess_all$name)
    names_new <- name[!(name %in% names_old)]
  }

  #set to default values when granularity changes
  if(exists("granularity_global")){
    if(granularity != granularity_global){
      data_mess_all <<- NULL
      names_new <- name
    }
  }

  if (granularity == "now"){
    csv_base <- "_t_now"
    granularity_global <<- "now"
  }
  # else if (granularity == "daily"){
  #   mess_base <- paste0(granularity,"/kl/recent/tageswerte_KL_")
  #   mess_end <- "_akt"
  #   granularity_global <<- "daily"
  # } else if (granularity == "monthly"){
  #   mess_base <- paste0(granularity,"/kl/recent/monatswerte_KL_")
  #   mess_end <- "_akt"
  #   granularity_global <<- "monthly"
  # }

  #loop to load and concatenate measurement data for all stations
  #system.time({
  if (length(names_new) > 0){
    for (ii in c(1:length(names_new))){
      station_abbr <- mess_meta_CH$station_abbr[mess_meta_CH$Stationsname==names_new[ii]]
      station_abbr <- tolower(station_abbr)
      URL <- paste0(
        "https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/",station_abbr,
        "/ogd-smn_",station_abbr,csv_base,".csv"
      )
      if(url.exists(URL)){
        mess_data_CH <- read.csv(URL, sep=";")
      } else{
        mess_data_CH <- NULL
      }

      mess_data_CH$STATIONS_ID <- mess_meta_CH$station_wigos_id[mess_meta_CH$Stationsname == names_new[ii]]
      mess_data_CH$station_name <- mess_meta_CH$Stationsname[mess_meta_CH$Stationsname == names_new[ii]]

      data_mess_all <<- rbind(data_mess_all,mess_data_CH)
    }}

    colnames(data_mess_all)[2] <- "MESS_DATUM"
    data_mess_all$MESS_DATUM <- as.POSIXct(data_mess_all$MESS_DATUM,format = "%d.%m.%Y %H:%M", tz = "UTC")

  return(data_mess_all)
}
