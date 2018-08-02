################################# UI  ##########################################

# Set up Environment -----------------------------------------------------------

library(shiny)

# Pull additional scripts to be used during process ----------------------------



# Start ui function ------------------------------------------------------------

shinyUI(fluidPage(

  # Application title
  img(src = "logo.png", height = 102, width = 102),
  titlePanel("CIS Progress Monitoring Import Generator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # Import Template Upload
      fileInput('import_template', 'Upload the CIS Provided Import Template',
                accept = c('xlsx', '.xlsx')),
      # caselist upload 
      fileInput('caselist', 'Upload Caselist File',
                accept = c("xlsx", '.xlsx')),
      # select dynamic schools
      uiOutput("choose_school"),
      
      # select date for quarter 
      dateInput('date', 'Select End Date for Quarter'),
      
      # select quarter
      selectInput(
        'quarter', 'Select Quarter to Generate Import File For',
        choices = c('1', '2', '3', '4')
        ),
      # download file
      downloadButton(
        'download_import_template', 
        'Download the Import Template for Selected School'
        )
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      includeMarkdown("md/instructions.md")
      )
  )
))
