# develope data products, week4assignment, slidify presentation 

library(devtools)
install_github('slidify', 'ramnathv')
install_github('slidifyLibraries', 'ramnathv')
library(slidify)
library(slidifyLibraries)
author('Locating Alaska Volcanos')

slidify('index.Rmd')
library(knitr)
browseURL('index.html')

#click knitr, but not working to click publish
publish(title = 'alasaka-volcano', 'index.html', host = 'rpubs')