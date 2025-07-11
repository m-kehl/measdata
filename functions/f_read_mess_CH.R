f_read_mess_CH <- function(station_name,mess_meta_CH){


  station_abbr <- mess_meta_CH$station_abbr[mess_meta_CH$Stationsname==station_name]
  station_abbr <- tolower(station_abbr)
  URL <- paste0(
    "https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/",station_abbr,
    "/ogd-smn_",station_abbr,"_t_now.csv"
  )
  mess_data_CH <- read.csv(URL, sep=";")
  colnames(mess_data_CH)[2] <- "MESS_DATUM"
  mess_data_CH$MESS_DATUM <- as.POSIXct(mess_data_CH$MESS_DATUM,format = "%d.%m.%Y %H:%M", tz = "UTC")

  mess_data_CH$STATIONS_ID <- meta$station_wigos_id[meta$Stationsname == station_name]
  mess_data_CH$station_name <- meta$Stationsname[meta$Stationsname == station_name]

  return(mess_data_CH)
}
