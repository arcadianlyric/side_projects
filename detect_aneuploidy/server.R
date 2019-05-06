### R shiny, server

library(shiny)
library(shinyIncubator)
library(rsconnect)
library(ggplot2)
library(plotly)

## get data
load('data.rda')
# interval <-  read.csv('Batch_2/Interval_order.csv', header = T)
# depth <-  read.csv('Batch_2/Depth.csv', header=T)[(which(interval1$Chrom==24)[1]):dim(interval1)[1], ]

## set server
shinyServer(function(input, output) {
    output$distPlot <- renderPlotly({
        samples <-  input$samples
        df <- depth[,(colnames(depth)==samples)]
        df  <- data.frame(cbind(interval[(which(interval$Chrom==24)[1]):dim(interval)[1],2], df))
        colnames(df) <- c('location', 'depth')
        df <- df[complete.cases(df),]
        ggplot(df, aes(location, depth)) + geom_line()
    })
})
