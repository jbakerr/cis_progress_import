################################# Server  ######################################

library(plyr)
library(dplyr)
library(tidyr)
library(lubridate)
library(shiny)
library(readxl)
library(openxlsx)
library(rsconnect)

source('modify_template.r', local = TRUE)

shinyServer(function(input, output) {
  
import_template <- loadWorkbook('import_template.xlsx')
  
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
    
    colnames(caselist) <- make.names(colnames(caselist))
    
    return(caselist)
    
  })
  
  
  getData_import_template <- reactive({
    
    if(is.null(input$caselist))
      return(NULL)
    
    caselist <- getData_caselist()
    subset <- get_subset(caselist, input)
    
    import_template <- modify_attendance(import_template, subset, input)
    
    import_template <- modify_suspensions(import_template, subset, input)
    
    import_template <- modify_grades(import_template, subset, input)
    
    return(import_template)
    
    
  })
  
# UI Display Functions ---------------------------------------------------------
  
  output$choose_school <- renderUI({
    validate(
      need(
        input$caselist, "Please Upload ")
      
    )
    
    caselist <- getData_caselist()
    
    schools <- caselist$Home.School
    
    selectInput("school", "Select Schools", as.list(schools))
    
  }
  )
  
# Download Output Functions ----------------------------------------------------
  
  
  output$download_import_template <- downloadHandler(
    filename = "myFile.xlsx",
    content = function(file) {
      saveWorkbook(getData_import_template(), file, TRUE)
    }
  )

})
