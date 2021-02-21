server <- function(input, output,session) {
  
  rv <- reactiveValues()
  
  observeEvent(input$time_period,{
    rv$invoice_range <- time_period_df %>%
      dplyr::filter(Time_Period == input$time_period) %>%
      dplyr::select(Days) %>%
      as.numeric()
    updateDateRangeInput(session,"dates",start = Sys.Date() - rv$invoice_range,end = Sys.Date())
  })
  
  output$days <- renderText({
      paste0('Contract Length: ',  input$end_date - input$start_date + 1 - input$skip_days," days")
    })
  output$address <- renderText({
    paste('Address: ',input$address, sep = ', ')
  })
  
  rTable_content <- reactive(
    {
        time_num <- time_period_df %>%
          dplyr::filter(Time_Period == input$time_period) %>%
          dplyr::select(Days) %>%
          as.numeric()

        DF <- data.frame("Date" = seq.Date(from = Sys.Date() - time_num,to = Sys.Date() ,by = "days"),
                         "Hours" = 0)
      
      # Try to keep previously entered custom value for match Type's
      if (length(input$invoice_table) > 0){
        oDF <- hot_to_r(input$invoice_table)
        DF$Hours <- oDF$Hours
      }
      
      DF
    }
  )

  output$invoice_table <- renderRHandsontable({

    rhandsontable(rTable_content(),rowHeaders = FALSE)
  })
  
  output$total <- renderText({
    paste0("total: ",sum(rTable_content()$Hours) * input$rate)
  })
  
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "invoice.pdf",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "invoice.Rmd")
      file.copy("invoice.Rmd", tempReport, overwrite = TRUE)
      
      # file.copy("details.csv",tdir)
      
      # Set up parameters to pass to Rmd document
      params <- list(name = input$name,
                     start_date = input$start_date,
                     end_date = input$end_date,
                     date = Sys.Date(),
                     rate = input$rate,
                     invoice_df = rTable_content(),
                     account = input$account,
                     routing = input$routing)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
}