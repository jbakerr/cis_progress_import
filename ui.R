
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  img(src = "logo.png", height = 102, width = 102),
  titlePanel("CIS Progress Monitoring Import Generator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput('caselist', 'Upload Caselist File',
                accept = c("xlsx", '.xlsx')),
      uiOutput("choose_school"),
      
      # selectInput('schools', 'Select School to Generate File For', choices = c("EK Powe", "Eno Valley")),
      dateInput('date', 'Select End Date for Quarter'),
      selectInput('quarter', 'Select Quarter to Generate Import File For', choices = c('1', '2', '3', '4')),
      downloadButton('download_import_template', 'Download the Import Template for Selected School')
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      p("distPlot")
    )
  )
))
