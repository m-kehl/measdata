f_read_mess_waiter <- function(name, mess_meta,mess_country,granularity,id){
  ## function to read measurement surface data (like ie temperature, precipitation)
  # - name:        array; names of measurement station/s (characters)
  # - mess_meta:   data.frame; meta data for measurement surface data, result of
  #                            f_read_mess_meta.R
  # - granularity: character; to define which measurement data are downloaded,
  #                           options: "now" for today's most recent measurement data
  #                                   "daily" for daily measurement data
  #                                   "monthly" for monthly measurement data
  # - id:          character; namespace id

  ## show waiter while reading data
  waiter_show(
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ),
    id = c(NS(id,"mess_plot"))
  )
  waiter_show(
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ),
    id = c(NS(id,"mess_plot_daily"))
  )
  waiter_show(
    html = tagList(
      spin_fading_circles(),
      "Download data from opendata.dwd.de .."
    ),
    id = c(NS(id,"mess_plot_monthly"))
  )
  if (mess_country == "Schweiz"){
    f_read_mess_CH(name,mess_meta)
  } else{
    f_read_mess(name,mess_meta,granularity)
  }


  waiter_hide()
  return(data_mess_all)
}
