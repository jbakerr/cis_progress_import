################################# Server  ######################################

library(plyr)
library(dplyr)
library(tidyr)
library(lubridate)
library(shiny)
library(readxl)
library(openxlsx)

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
  
  
  getData_import_template <- reactive({
    
    import_template <- loadWorkbook(input$import_template)
    
    if(is.null(import_template)){
      return(NULL)
    }
    
    # import_template <- loadWorkbook(import_template)
    
    test <- read.xlsx(import_template, sheet = 1)
    
    test[1,] <- "Test"
    
    import_template <- writeData(import_template,1,test, startRow = 2, colNames = FALSE)
    
    return(import_template)
    
    
  })
  
# UI Display Functions ---------------------------------------------------------
  
  output$choose_school <- renderUI({
    validate(
      need(
        input$caselist, "Please Upload ")
      
    )
    
    caselist <- getData_caselist()
    
    schools <- caselist$`Home School`
    
    selectInput("school", "Select Schools", as.list(schools))
    
  }
  )
  
# Download Output Functions ----------------------------------------------------
  
  
  output$download_import_template <- downloadHandler(
    filename = "myFile.xlsx",
    content = function(file) {
      # Do more stuff here
      saveWorkbook(getData_import_template(), file, TRUE)
    }
  )
    
  
  
  # output$download_import_template <- downloadHandler(
  #   filename = function() {
  #     paste(
  #       input$school, "quarter_", input$quarter,
  #       "_metric_import_template", "xlsx", sep = ""
  #       )
  #   },
  #   content = function(file) {
  #     saveWorkbook(getData_import_template(), "file.xlsx")
  #   }
  # )  

})
