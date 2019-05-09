# A shiny app was made to visualize Y chromosome, one can locate exact regions with gains and losses. 
# 1. Open runShiny.R, change path to the current path. 
# 2. Run all scripts in runShiny.R, a window with panel will appear, it may take a few seconds.
# 3. Select one sample to continue, a plot showing read on y-axis and location on x-axis will appear.
# 4. Move cursor on the plot to display read and location information.

library(shiny)
library(shinyIncubator)
library(rsconnect)
library(ggplot2)
library(plotly)

runApp()
