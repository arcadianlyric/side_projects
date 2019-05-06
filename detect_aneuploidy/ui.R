### R shiny UI

library(shiny)
library(shinyIncubator)
library(rsconnect)
library(ggplot2)
library(plotly)

shinyUI(fluidPage(
        plotlyOutput("distPlot"),
        sidebarPanel(
            checkboxGroupInput("samples", label='Select a sample',c('sample1'='Sample.01','sample2'='Sample.02','sample3'='Sample.03','sample4'='Sample.04','sample5'='Sample.05','sample6'='Sample.06','sample7'='Sample.07','sample8'='Sample.08','sample9'='Sample.09','sample10'='Sample.10','sample11'='Sample.11','sample12'='Sample.12','sample13'='Sample.13','sample14'='Sample.14','sample15'='Sample.15','sample16'='Sample.16','sample17'='Sample.17','sample18'='Sample.18','sample19'='Sample.19','sample20'='Sample.20','sample21'='Sample.21','sample22'='Sample.22','sample23'='Sample.23','sample24'='Sample.24'))
        )
    ))
