f_read_mess_CH <- function(station_name,mess_meta_CH){


  station_abbr <- mess_meta_CH$station_abbr[mess_meta_CH$station_name==station_name]
  station_abbr <- tolower(station_abbr)
  URL <- paste0(
    "https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/",station_abbr,
    "/ogd-smn_",station_abbr,"_t_now.csv"
  )
  mess_data_CH <- read.csv(URL, sep=";")

}
