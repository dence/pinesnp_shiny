#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("PineSNP Functional Annotation Tool"),
  mainPanel(
    fileInput("SNPs_file",label = "Select SNPs file"),
    actionButton(inputId = "file_preview", "Preview  SNPs file"),
    actionButton(inputId = "filter_yes","Filter database on SNPs"),
    
    uiOutput("preview")
  ),
  fluidRow(
    column(
      12,tableOutput('merged_output')
      )
    
  ),
  
  sidebarPanel(
    textOutput("filtering")
    #textOutput("filtering"),
    #downloadButton("downloadData","Download")
    
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observeEvent(input$file_preview, {
    if( is.null(input$SNPs_file)) return(NULL)
    inFile <- input$SNPs_file
    file <- inFile$datapath
    
    #load the file into new environment and get it from there
    #e = new.env()
    #name <- load(file, envir = e, verbose = TRUE)
    
    
    #Preview the SNPs file
    output$preview <- renderUI({
      SNPs_file_preview <- readLines(file)
      splitText <- stringi::stri_split(str = SNPs_file_preview, regex = '\\n')
      replacedText <- lapply(splitText,p)
      return(replacedText)
    })
    
  })
  
  observeEvent(input$filter_yes, {
    if(is.null(input$SNPs_file)) return(NULL)
    
    #duplicated code here, need to fix this
    #should put inFile outside of both observeEvent's somehow
    inFile <- input$SNPs_file
    file <- inFile$datapath
    SNP_data <- read.delim(file, header=TRUE,sep="\t")
    
    #kind of a magic number here.
    data_file <- "example_data/ADEPT2.vep.txt"
    data <- read.delim(data_file,header = TRUE,sep="\t")
    
    tmp_merged_data <- merge(x=SNP_data, y=data, by="SNP_ID",all.x=TRUE)
    output$merged_output <- renderTable(tmp_merged_data)
    
    output$filtering <- renderText({"YOU ARE FILTERING!"})
    
    
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      
      paste(input$SNPs_file, ".csv",sep="\t")
    },
    content = function(file) {
      write.csv(tmp_merged_data,file)
      
    }
    
  )
}

# Run the application 
shinyApp(ui = ui, server = server)


