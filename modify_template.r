library(openxlsx)

# import_template <- loadWorkbook('import_template.xlsx')

get_subset <- function(caselist, input){
  
  subset <- caselist[caselist$Home.School == input$school,]
  
  return(subset)
}


modify_attendance <- function(import_template, subset, input){

  attendance <- read.xlsx(import_template, sheet = 1)
  
  attendance[nrow(attendance) + nrow(subset),] <- "NA"
  
  attendance$Student.ID <- subset$Student.ID
  
  attendance$Date <- input$date
  
  attendance$School <- subset$Home.School
  
  attendance$`#.of.days.in.report.period` <- 45
  
  attendance$Grading.period <- input$quarter
  
  attendance$School.Year <- input$year
  
  attendance <- attendance[order(attendance$Student.ID),]
  
  
  writeData(import_template,1,attendance, startRow = 2, colNames = FALSE)
  
  return(import_template)

}


modify_suspensions <- function(import_template, subset, input){
  
  suspensions <- read.xlsx(import_template, sheet = 3)
  
  suspensions[nrow(suspensions) + nrow(subset),] <- "NA"
  
  suspensions$Student.ID <- subset$Student.ID
  
  suspensions$Date <- input$date
  
  suspensions$School <- subset$Home.School
  
  suspensions$Grading.period <- input$quarter
  
  suspensions$School.Year <- input$year
  
  suspensions <- suspensions[order(suspensions$Student.ID),]
  
  
  writeData(import_template,3,suspensions, startRow = 2, colNames = FALSE)
  
  return(import_template)
  
}


modify_grades <- function(import_template, subset, input){
  
  grade_categories <- c('Math 1', 'Science', 'Eng/Lang Arts/Reading/Writing')
  
  grades <- read.xlsx(import_template, sheet = 7)
  
  grades[nrow(grades) + nrow(subset),] <- "NA"
  
  grades$Student.ID <- subset$Student.ID
  
  grades$Date <- input$date
  
  grades$School <- subset$Home.School
  
  grades$Grading.period <- input$quarter
  
  grades$School.Year <- input$year
  
  grades <- grades[rep(row.names(grades), 3), 1:12]
  
  grades <- grades[order(grades$Student.ID),]
  
  grades$Core.Course <- grade_categories
  
  writeData(import_template,7,grades, startRow = 2, colNames = FALSE)
  
  return(import_template)
  
}

