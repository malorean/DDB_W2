#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("TCX Viewer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput("tcxfile",
                "Choose a tcx file",
                accept = "*.tcx"),
      actionButton("trackMap", label = "Show track"),
      actionButton("demoMap", label = "Show demo map")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput("path"),
      leafletOutput("map")
    )
  )
))
