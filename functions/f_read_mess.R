f_read_mess <- function(name, mess_meta,granularity){
  ## function to read measurement surface data (like ie temperature, precipitation)
  # - name:        array; names of measurement station/s (characters)
  # - mess_meta:   data.frame; meta data for measurement surface data, result of
  #                            f_read_mess_meta.R
  # - granularity: character; to define which measurement data are downloaded,
  #                           options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  # - id:          character; namespace id

  #read surface measurement data
  #path definitions for download source
  url_base <- "ftp://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/"

  #check whether data is already loaded
  if (!exists("data_mess_all")){
    data_mess_all <<- NULL
    names_new <- name
  } else{
    data_mess_all <<- data_mess_all[data_mess_all$station_name %in% name,]
    names_old <- unique(data_mess_all$station_name)
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
    mess_base <- "10_minutes/air_temperature/now/10minutenwerte_TU_"
    mess_base_prec <- "10_minutes/precipitation/now/10minutenwerte_nieder_"
    mess_end <- "_now"
    granularity_global <<- "now"
  } else if (granularity == "daily"){
    mess_base <- paste0(granularity,"/kl/recent/tageswerte_KL_")
    mess_end <- "_akt"
    granularity_global <<- "daily"
  } else if (granularity == "monthly"){
    mess_base <- paste0(granularity,"/kl/recent/monatswerte_KL_")
    mess_end <- "_akt"
    granularity_global <<- "monthly"
  }

  #loop to load and concatenate measurement data for all stations
  #system.time({
  if (length(names_new) > 0){
  for (ii in c(1:length(names_new))){
    source <- paste0(url_base,mess_base,mess_meta$Stations_id[mess_meta$Stationsname == names_new[ii]],mess_end,".zip")

    if(url.exists(source)){
      data_mess <- dataDWD(source, force=NA, varnames=TRUE,quiet = T)
      data_mess$station_name <- names_new[ii]
    } else{
      data_mess <- NULL
    }

    if (granularity == "now"){
      source_prec <- paste0(url_base,mess_base_prec,mess_meta$Stations_id[mess_meta$Stationsname == names_new[ii]],mess_end,".zip")
      if(url.exists(source_prec)){
        data_prec <- dataDWD(source_prec, force=NA, varnames=TRUE,quiet = T)

      }else{
        data_prec <- NULL
      }
      data_mess <- merge(data_mess,data_prec)
    }
    data_mess <- arrange(data_mess,MESS_DATUM)
    data_mess_all <<- rbind(data_mess_all,data_mess)
  }}
  #}) #Sys.time

  # system.time({
  #   num_cores <- detectCores() - 1  # Use one less than total cores
  #   cl <- makeCluster(num_cores)
  #   registerDoParallel(cl)
  #   data_mess_all_parallel <- foreach(ii = 1:length(name), .packages = c("RCurl","rdwd","dplyr")) %dopar% {
  #     source <- paste0(url_base,mess_base,mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],mess_end,".zip")
  #     if(url.exists(source)){
  #       data_mess <- dataDWD(source, force=NA, varnames=TRUE,quiet = T)
  #       data_mess$station_name <- name[ii]
  #     } else{
  #       data_mess <- NULL
  #     }
  #
  #     if (granularity == "now"){
  #       source_prec <- paste0(url_base,mess_base_prec,mess_meta$Stations_id[mess_meta$Stationsname == name[ii]],mess_end,".zip")
  #
  #       if(url.exists(source_prec)){
  #         data_prec <- dataDWD(source_prec, force=NA, varnames=TRUE,quiet = T)
  #
  #       }else{
  #         data_prec <- NULL
  #       }
  #       data_mess <- merge(data_mess,data_prec)
  #     }
  #     data_mess <- arrange(data_mess,MESS_DATUM)
  #
  #
  #     #data_mess_all_parallel <- rbind(data_mess_all_parallel,data_mess)
  #
  #   }
  #   stopCluster(cl)
  #   data_mess_all_2 <- bind_rows(data_mess_all_parallel)
  #
  # }) #Sys.time

  return(data_mess_all)
}
