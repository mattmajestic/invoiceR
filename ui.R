ui <- fluidPage(
  titlePanel('Invoice Generator'),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'name',label = 'Name: ',choices = "Matthew Majestic"),
      dateInput(inputId = 'start_date','Start Date: '),
      dateInput('end_date','End Date: '),
      numericInput('skip_days','No. of Skip Days: ',value = 0,min = 0,max = 10000),
      numericInput('bonus','Bonus: ',value = 0,min = 0,max = 100000),
      dateInput('inv_date','Invoice Date: '),
      "Number of days counted: ", 
      downloadButton("report", "Generate invoice")
    ),
    mainPanel(
      textOutput("days"),
      textOutput('address'),
      textOutput('salary'),
      imageOutput('sign')
    )))