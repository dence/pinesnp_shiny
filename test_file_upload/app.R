#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

x <- rnorm(100)
save(x, file = "x.RData")
rm(x)
y <- rnorm(100, mean = 2)
save(y, file = "y.RData")
rm(y)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel(".RData File Upload Test"),
  mainPanel(
    fileInput("file",label = ""),
    actionButton(inputId="plot","Plot"),
    plotOutput("hist")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  observeEvent(input$plot, {
    if ( is.null(input$file)) return(NULL)
    inFile <- input$file
    file <- inFile$datapath
    #load the file into new environment and get it from there
    e = new.env()
    name <- load(file, envir = e)
    data <- e[[name]]
    
    #Plot the data
    output$hist <- renderPlot({
      hist(data)
    })
  }
               
               )
}

# Run the application 
shinyApp(ui = ui, server = server)

