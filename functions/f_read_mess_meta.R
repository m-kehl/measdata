f_read_mess_meta <- function(){
  ## function to read measurement meta data
  #source
  mess_base <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/10_minutes/air_temperature/now/"
  mess_meta <- f_readDWD.meta(paste0(mess_base,"zehn_now_tu_Beschreibung_Stationen.txt"))

  #sort
  mess_meta <- arrange(mess_meta,Stationsname, .locale = "de")
  #format stations id
  mess_meta$Stations_id <- sprintf("%0*d", 5, mess_meta$Stations_id)
  return(mess_meta)
}

#copy from parts of https://github.com/brry/rdwd/blob/master/R/readDWD.R with minor changes (bug correction since
# since some meta files have 9 instead of 8 columns)
f_readDWD.meta <- function(file, quiet=rdwdquiet(), ...)
{
  # read a few lines to get column widths and names
  oneline <- readLines(file, n=60, encoding="latin1")
  # n=60 or 15 has no influence on total readDWD.meta time for 97 meta files (16 secs)
  oneline <- sub("Berlin-Dahlem (LFAG)", "Berlin-Dahlem_(LFAG)", oneline, fixed=TRUE)
  oneline <- sub("Berlin-Dahlem (FU)"  , "Berlin-Dahlem_(FU)"  , oneline, fixed=TRUE)
  # Fix reading error if only these two exist, like in daily/kl/hist mn4_Beschreibung_Stationen.txt 2022-04-07

  # column names:
  # remove duplicate spaces (2018-03 only in subdaily_stand...Beschreibung....txt)
  while( grepl("  ",oneline[1]) )  oneline[1] <- gsub("  ", " ", oneline[1])
  cnames <- strsplit(oneline[1], " ")[[1]]
  choehe <- grep("hoehe", cnames, ignore.case=TRUE) - 1

  # column widths (automatic detection across different styles used by the DWD)
  spaces <- Reduce(intersect, gregexpr(" ", oneline[-(1:2)]) )
  breaks <- spaces[which(diff(spaces)!=1)]
  breaks[choehe] <- breaks[choehe] - 3 #  to capture 4-digit Stationshoehen (1134 m Brocken, eg)
  widths <- diff(c(0,breaks,200))
  #
  # actually read metadata, suppress readLines warning about EOL:
  stats <- suppressWarnings(read.fwf(file, widths=widths, skip=2, strip.white=TRUE,
                                     fileEncoding="latin1", ...) )
  if(!grepl("subdaily_standard_format", file)) colnames(stats) <- cnames
  if(grepl("subdaily_standard_format", file))
  {
    # deal with linebreaks before bundesland 2024-05-14:
    stats <- stats[1:234,] # what a messud up file...
    ns <- nrow(stats)
    stats <- stats[-seq(3,ns,by=3), ]
    stats <- cbind(stats[seq(1,ns,by=2), ],stats[seq(2,ns,by=2), ])
    stats <- na.omit(stats[,1:8])
    stats[,1] <- substr(stats[,1],22,1e3)
    # do other things for this weird file that I already did before 2024-05:
    stats <- stats[ ! stats[,1] %in% c("","ST_KE","-----") , ]
    tf <- tempfile()
    # write.table(stats[,-1], file=tf, quote=FALSE, sep="\t") # originally what's needed
    write.table(stats, file=tf, quote=FALSE, sep="\t") # currently needed
    stats <- read.table(tf, sep="\t")
    colnames(stats) <- c("Stations_id", "von_datum", "bis_datum", "Stationshoehe",
                         "geoBreite", "geoLaenge", "Stationsname", "Bundesland")
  }
  # # check classes:
  # if(ncol(stats)!=9) tstop(ncol(stats)," columns detected instead of 8 for ", file)
  # classes <- c("integer", "integer", "integer", "integer", "numeric", "numeric", "character", "character")
  # actual <- sapply(stats, class)
  # if(actual[4]=="numeric") classes[4] <- "numeric"
  # if(!all(actual == classes))
  # {
  #   msg <- paste0(names(actual)[actual!=classes], ": ", actual[actual!=classes],
  #                 " instead of ", classes[actual!=classes], ".")
  #   msg <- paste(msg, collapse=" ")
  #   twarning("reading file '", file,"' did not give the correct column classes. ", msg)
  # }
  # return meta data.frame:
  stats
}
