f_read_mess_meta_CH <- function(){
  ## function to read measurement meta data
  #source
  mess_meta_CH <- read.csv("https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/ogd-smn_meta_stations.csv",
                           sep = ";",encoding = "latin1")
  colnames(mess_meta_CH)[2] <- "Stationsname"

  return(mess_meta_CH)
}
