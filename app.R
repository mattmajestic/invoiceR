source("global.R")
source("ui.R")
source("server.R")

options(shiny.port = 8686)
options(shiny.host = "0.0.0.0")

shinyApp(ui,server)
