server <- function(input, output,session) {
  
  rv <- reactiveValues()
  invoiceServer("invoice_ns",rv)
  
}