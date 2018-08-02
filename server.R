

library(plyr)
library(dplyr)
library(tidyr)
library(lubridate)
library(shiny)
library(readxl)

shinyServer(function(input, output) {

  
# Input functions --------------------------------------------------------------
  
  getData_caselist <- reactive({
    
    
    caselist <- input$caselist
    
    if(is.null(caselist))
      return(NULL)
    
    nms <- names(read_excel(caselist$datapath, n_max = 0))
    
    
    ct <- ifelse(grepl("Date", nms), "date", "guess")
    
    caselist <- suppressWarnings(
      read_excel(caselist$datapath, sheet = 1,skip = 1, col_types = ct)
    )
    
    
    
    # caselist <- caselist_script(caselist)
    return(caselist)
    
  })
# UI Display Functions ---------------------------------------------------------
  
  output$choose_school <- renderUI({
    validate(
      need(
        input$caselist, "studentlist_error_code")
      
    )
    
    caselist <- getData_caselist()
    
    schools <- caselist$`Home School`
    
    selectInput("school", "Select Schools", as.list(schools))
    
  }
  )
  
  
  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
