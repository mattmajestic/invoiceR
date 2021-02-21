ui <- fluidPage(
  titlePanel('Invoice Generator'),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        textInput("name","Your Business",placeholder = "LLC, Inc, Etc")
      ),
      fluidRow(
        textInput("account","Your Account Number",placeholder = "Left part of check"),
        textInput("routing","Your Routing Number",placeholder = "Right part of check")
      ),
      #dateRangeInput("dates","Date Range",start = Sys.Date() - 30,end = Sys.Date() + 30),
      numericInput("rate","Hourly Rate",value = 50,min = 1,max = 1000),
      radioButtons("time_period","Time Period",choices = c("Bi-Weekly")),
      downloadButton("report", "Generate invoice")
    ),
    mainPanel(
      rHandsontableOutput("invoice_table"),
      br(),
      textOutput("total")
    )))