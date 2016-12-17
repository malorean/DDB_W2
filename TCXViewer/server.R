#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(XML)
library(plyr)
library(dplyr)
library(shiny)
library(leaflet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$path <- renderText({
    inFile <- input$tcxfile
    if(!is.null(inFile))
      outpath <- inFile$name
    if(is.null(inFile))
      outpath <- "No Selection made!"
    HTML(paste("<b>", outpath, "</b>"))
  })
   
  output$map <- renderLeaflet({
    xml.path <- input$tcxfile
    
    if (is.null(xml.path))
      return(NULL)
    
    xml.file <- xmlParse(xml.path$datapath)
    xml.track.nodes <- 
      getNodeSet(xml.file,
                 "//ns:Trackpoint", 
                 "ns", 
                 fun = 
      )
    track.data <- ldply(xml.track.nodes, as.data.frame(xmlToList))
    names(track.data) <- c('time', 'lat', 'long', 'alt', 'distance', 'speed')
    
    track.data <- track.data %>%
      mutate_all(funs(as.character)) %>%
      mutate_each_(funs(as.double), vars(-starts_with("time"))) %>%
      mutate(time = as.POSIXct(time, format = "%Y-%m-%dT%H:%M:%S")) %>%
      filter(speed > 0)
    
    leaflet() %>% 
      addTiles() %>%
      addPolylines(lat = track.data$lat,
                   lng = track.data$long, 
                   popup = paste(as.character(round(track.data$speed * 3.6, 2)), " km/h")) %>%
      addMarkers(lat = track.data$lat[1], lng = track.data$long[1], popup = "Start")
  })
})
