library(shiny)

ui <- fluidPage(
  h1("Hello")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)