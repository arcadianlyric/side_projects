# develope R product, week4assignment 
#setwd('/Users/YC/github/DevPro-week4')
#install.packages("devtools")
#devtools::install_github("shiny-incubator", "rstudio")

library(shiny)
library(shinyIncubator)
library(googleVis)
#library(XLConnect)
# ak volcano data from https://www.avo.alaska.edu/volcanoes/latlong.php
# filtered out 2015 incidents
# preprocess data
#wb= loadWorkbook('/Users/YC/Desktop/DevPro-week4/AKvolclatlong.xls')
#ak = readWorksheet(wb, sheet = getSheets(wb))
#save.image('tmp.rda')

load('tmp.rda')
# Format lattitude and longitude
ak$loc= paste(ak$Latitude, ':', ak$Longitude, sep='')
ak$detail= paste(ak$Volcano,  "at", as.character(ak$Latitude),":",as.character(ak$Longitude))

# set app
shinyServer(function(input, output, session) {
    output$gvis= renderGvis({
         withProgress(session, {
            
            ak.vol= ak[(ak$Volcano %in% input$volcano), ]
            
            gvisMap(ak.vol, "loc", "detail",
                    options=list(showTip=TRUE, 
                                 showLine=TRUE, 
                                 enableScrollWheel=TRUE,
                                 mapType='terrain', 
                                 useMapTypeControl=TRUE))
        })
    })
})