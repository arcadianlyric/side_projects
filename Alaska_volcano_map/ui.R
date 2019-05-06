# develope R product, week4assignment 
#setwd('/Users/YC/github/DevPro-week4')

# progressInit issue
#devtools::install_github('rstudio/rsconnect')
library(shiny)
library(shinyIncubator)
library(googleVis)
# install an older version of shiny to solve processInit issue
#devtools::install_github("rstudio/shiny-incubator", ref = "0f343efe9b6c255e6687aaa52b5443cf975f96e7")
#library(rsconnect)
#rsconnect::setAccountInfo(name="<ACCOUNT>", token="<TOKEN>", secret="<SECRET>")
#deployApp()

shinyUI(fluidPage(
    headerPanel("Alasaka volcanos"),
    mainPanel(
        p("This", a(href="http://shiny.rstudio.com/", "Shiny"),
          "application let you know volcano locations in Alaska. You can select volcano by names and find them on map."),
p("The Alasaka volcano data is from", a(href="https://www.avo.alaska.edu/volcanoes/latlong.php", "here"), ". The source code for the application is available on", a(href="https://github.com/arcadianlyric/DevPro-week4", "GitHub"), "."),
        progressInit(),
        htmlOutput("gvis")
        ),
    sidebarPanel(
        checkboxGroupInput("volcano", label='Select one or more volcanos.',c('Adagdak'='Adagdak', 'Akutan' = 'Akutan', 'Alagogshak'='Alagogshak', 'Amak'='Amak', 'Amchixtam Chaxsxii'='Amchixtam Chaxsxii', 'Amukta'='Amukta', 'Andrew Bay volcano'='Andrew Bay volcano', 'Aniakchak'='Aniakchak', 'Atka'='Atka', 'Augustine'='Augustine', 'Basalt of Gertrude Creek'='Basalt of Gertrude Creek', 'Behm Canal-Rudyerd Bay'='Behm Canal-Rudyerd Bay', 'Black Peak'='Black Peak', 'Blue Mtn'='Blue Mtn', 'Bobrof'='Bobrof', 'Bogoslof'='Bogoslof', 'Bona-Churchill'='Bona-Churchill', 'Buldir'='Buldir', 'Buzzard Creek'='Buzzard Creek', 'Capital'='Capital', 'Carlisle'='Carlisle', 'Chagulak'='Chagulak', 'Chiginagak'='Chiginagak', 'Cleveland'='Cleveland', 'Cone 3110'='Cone 3110', 'Cone 3601'='Cone 3601', 'Dana'='Dana', 'Davidof'='Davidof', 'Denison'='Denison', 'Devils Desk'='Devils Desk', 'Double Glacier'='Double Glacier', 'Douglas'='Douglas', 'Drum'='Drum', 'Duncan Canal'='Duncan Canal', 'Dutton'='Dutton', 'East Cape volcano'='East Cape volcano', 'Edgecumbe'='Edgecumbe', 'Emmons Lake Volcanic Center'='Emmons Lake Volcanic Center', 'Espenberg'='Espenberg', 'Fisher'='Fisher', 'Folsoms Bluff'='Folsoms Bluff', 'Fourpeaked'='Fourpeaked', 'Frosty'='Frosty', 'Gareloi'='Gareloi', 'Gilbert'='Gilbert', 'Gordon'='Gordon', 'Great Sitkin'='Great Sitkin', 'Griggs'='Griggs', 'Hayes'='Hayes', 'Herbert'='Herbert', 'Iliamna'='Iliamna', 'Imuruk Lake'='Imuruk Lake', 'Ingakslugwat Hills'='Ingakslugwat Hills', 'Ingrisarak Mtn'='Ingrisarak Mtn', 'Iron Trig Cone'='Iron Trig Cone', 'Isanotski'='Isanotski', 'Iskut-Unuk River Cones'='Iskut-Unuk River Cones', 'Jarvis'='Jarvis', 'Jumbo Dome'='Jumbo Dome', 'Kagamil'='Kagamil', 'Kaguyak'='Kaguyak', 'Kanaga'='Kanaga', 'Kasatochi'='Kasatochi', 'Katmai'='Katmai', 'Kejulik'='Kejulik', 'Khvostof'='Khvostof', 'Kialagvik'='Kialagvik', 'Kiska'='Kiska', 'Klawasi Group'='Klawasi Group', 'Knob 1000'='Knob 1000', 'Kochilagok Hill'='Kochilagok Hill', 'Koniuji'='Koniuji', 'Kookooligit Mountains'='Kookooligit Mountains', 'Korovin'='Korovin', 'Koyuk-Buckland volcanics'='Koyuk-Buckland volcanics', 'Kukak'='Kukak', 'Kupreanof'='Kupreanof', 'Little Sitkin'='Little Sitkin', 'Mageik'='Mageik', 'Makushin'='Makushin', 'Martin'='Martin', 'Moffett'='Moffett', 'Nelson Island'='Nelson Island', 'Novarupta'='Novarupta', 'Nunivak Island'='Nunivak Island', 'Nushkolik Mountain volcanic field'='Nushkolik Mountain volcanic field', 'Okmok'='Okmok', 'Pavlof'='Pavlof', 'Pavlof Sister'='Pavlof Sister', 'Porcupine'='Porcupine', 'Prindle Volcano'='Prindle Volcano', 'Rainbow River Cone'='Rainbow River Cone', 'Recheshnoi'='Recheshnoi', 'Redoubt'='Redoubt', 'Roundtop'='Roundtop', 'Sanford'='Sanford', 'Seguam'='Seguam', 'Segula'='Segula', 'Semisopochnoi'='Semisopochnoi', 'Sergief'='Sergief', 'Shishaldin'='Shishaldin', 'Skookum Creek'='Skookum Creek', 'Snowy'='Snowy', 'Spurr'='Spurr', 'St. George volcanic field'='St. George volcanic field', 'St. Michael'='St. Michael', 'St. Paul Island'='St. Paul Island', 'Steller'='Steller', 'Submarine 001'='Submarine 001', 'Submarine 002'='Submarine 002', 'Submarine 003'='Submarine 003', 'Submarine 004'='Submarine 004', 'Submarine 005'='Submarine 005', 'Submarine 006'='Submarine 006', 'Takawangha'='Takawangha', 'Tana'='Tana', 'Tanada Peak'='Tanada Peak', 'Tanaga'='Tanaga', 'Tlevak Strait-Suemez Island'='Tlevak Strait-Suemez Island', 'Togiak volcanics'='Togiak volcanics', 'Trader Mtn'='Trader Mtn', 'Trident'='Trident', 'Ugashik-Peulik'='Ugashik-Peulik', 'Ukinrek Maars'='Ukinrek Maars', 'Uliaga'='Uliaga', 'Ungulungwak Hill-Ingrichuak Hill'='Ungulungwak Hill-Ingrichuak Hill', 'Unnamed (near Ukinrek Maars)'='Unnamed (near Ukinrek Maars)', 'Veniaminof'='Veniaminof', 'Volcano 1 near Kupreanof'='Volcano 1 near Kupreanof', 'Volcano 2 near Kupreanof'='Volcano 2 near Kupreanof', 'Volcano 3 near Kupreanof'='Volcano 3 near Kupreanof', 'Volcano 4 near Kupreanof'='Volcano 4 near Kupreanof', 'Vsevidof'='Vsevidof', 'Westdahl'='Westdahl', 'Wrangell'='Wrangell', 'Yantarni'='Yantarni', 'Yunaska'='Yunaska'))
)))
