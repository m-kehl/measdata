## Server part for the surface measurement data (according User Interface: messdataUI.R)
messdataServer <- function(id,active) {
  # - id:     character; namespace id
  # - active: character; name of active tabset

  moduleServer(id, function(input, output, session) {
    ## update UI -> hide sincetill box
    shinyjs::hideElement("box_sincetill")

    ## read and process meta and measurement data
    # read meta data
    #observe({
    mess_meta <- reactive(f_read_mess_meta(input$mess_country))
    #output$testing <- renderText(input$mess_country)
    #})
    # update UI based on meta data
    observe({
    updateSelectizeInput(session,"mess_name",
                         choices = base::unique(mess_meta()$Stationsname),
                         options = list(maxItems = 5))
    })

    # read measurement data
    mess_data <- reactive(f_read_mess_waiter(input$mess_name,mess_meta(),input$mess_country,sub(paste0(id,"-"),"",input$mess_tabsets),id))

    #output$text_output <- renderText(input$mess_name)

    ## show information box
    observeEvent(input$info_mess, {
      f_infotext(active)
    })

    ## update UI
    observeEvent(sub(paste0(id,"-"),"",input$mess_tabsets,input$mess_country),{
      f_updateselectize_parameters(session,"parameter_plot1",sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,input$mess_country)
      f_updateselectize_parameters(session,"parameter_plot2",sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,input$mess_country)
    })

    ## plot measurement data
    observe({
      # placeholder-plot if no station is chosen in UI
      if (ifelse(length(input$mess_name) == 0,TRUE,ifelse(is.na(input$mess_name),TRUE,FALSE))){
        output$mess_plot <- renderPlot(f_plot_placeholder())
        output$mess_plot_daily <- renderPlot(f_plot_placeholder())
        output$mess_plot_monthly <- renderPlot(f_plot_placeholder())
        output$mess_plot_rec <- renderPlot(f_plot_empty())
        output$mess_plot_daily_prec <- renderPlot(f_plot_empty())
        output$mess_plot_monthly_prec <- renderPlot(f_plot_empty())
      } else if (sub(paste0(id,"-"),"",input$mess_tabsets) == "now"){
        # plot measurement data for recent measurements
        output$mess_plot <- renderPlot(f_plot_mess(mess_data(),input$mess_country,sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,"Plot 1: "))
        output$mess_plot_prec <- renderPlot(f_plot_mess(mess_data(),input$mess_country,sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,"Plot 2: "))
        shinyjs::hideElement("box_sincetill")
      } else if (sub(paste0(id,"-"),"",input$mess_tabsets) == "daily"){
        # update UI
        updateSliderInput(session,"sincetill",
                          min = mess_data()$MESS_DATUM[1],
                          max = mess_data()$MESS_DATUM[nrow(mess_data())],
                          timeFormat = "%d.%m.%Y")
        shinyjs::showElement("box_sincetill")
        # plot measurement data for daily measurements
        output$mess_plot_daily <- renderPlot(f_plot_mess(mess_data(),input$mess_country,sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,"Plot 1: ",input$sincetill))
        output$mess_plot_daily_prec <- renderPlot(f_plot_mess(mess_data(),input$mess_country,sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,"Plot 2: ",input$sincetill))
      } else if (sub(paste0(id,"-"),"",input$mess_tabsets) == "monthly"){
        # plot measurement data for monthly measurements
        output$mess_plot_monthly <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot1,"Plot 1: "))
        output$mess_plot_monthly_prec <- renderPlot(f_plot_mess(mess_data(),sub(paste0(id,"-"),"",input$mess_tabsets),input$parameter_plot2,"Plot 2: "))
        # update UI
        shinyjs::hideElement("box_sincetill")
      }
    })
  })
}
