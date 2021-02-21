library(shiny)
library(dplyr)
library(DT)
library(rhandsontable)
library(rmarkdown)

time_period_df <- data.frame("Time_Period" = c("Bi-Weekly","Month","Quarter"),
                             "Days" = c(15,30,90))
