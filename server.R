server = function(input, output) {
  output$days <- renderText(
    {
      paste0('Contract Length: ',  input$end_date - input$start_date + 1 - input$skip_days," days")
    }
  )
  output$address <- renderText({
    line <- details %>%
      filter(name == input$name)
    
    paste('Address: ',line$addr_l1,line$addr_l2,line$addr_l3, sep = ', ')
  })
  output$salary <- renderText({
    line <- details %>%
      filter(name == input$name)
    
    paste0('Salary: ',line$salary)
  })
  output$sign <- renderImage({
    list(src = paste0(path,"\\",input$name,'.png'), width = 250, height = 150)
  },deleteFile = FALSE)
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "invoice.pdf",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tdir <- path 
      tempReport <- file.path(tdir, "inv_md.Rmd")
      file.copy("invoice.Rmd", tempReport, overwrite = TRUE)
      
      # file.copy("details.csv",tdir)
      
      # Set up parameters to pass to Rmd document
      params <- list(name = input$name,
                     start_date = input$start_date,
                     end_date = input$end_date,
                     date = input$inv_date,
                     skip_days = input$skip_days,
                     bonus = input$bonus,
                     details_file = details_file)
      
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