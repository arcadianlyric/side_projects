library(devtools)
install_github('slidify', 'ramnathv')
install_github('slidifyLibraries', 'ramnathv')
library(slidify)
library(slidifyLibraries)
author('Locating Alaska Volcanos')

slidify('index.Rmd')
library(knitr)
browseURL('index.html')

publish(title = 'alasaka-volcano', 'index.html', host = 'rpubs')