library(shiny)
library(dplyr)

# Song data
data <- read.csv("data.csv")
hanoi_food <- data %>% 
  filter(city == "Hanoi") %>% 
  select(-city)

# UI
ui <- fluidPage(
  titlePanel("Yummy in my Tummy?"),
  sidebarLayout(
    sidebarPanel(
      br(),
      selectInput("city", "Choose a city:", choices = c("Hanoi", "Bangkok")),
      br(),
      actionButton("generate", "Generate URL")
    ),
    mainPanel(
      h4(textOutput("title")),
      br(),
      uiOutput("tab")
    )
  )
)

# Server
server <- function(input, output, session) {
  # Function to generate a random video URL
  generate_url <- function(city) {
    if (city == "Hanoi") {
      id <- sample(hanoi_food$id, 1)
      url <- a("surprise", href=hanoi_food$url[id])
    } else if (city == "Bangkok") {
      id <- sample(bangkok_food$id, 1)
      url <- a("surprise", href=hanoi_food$url[id])
    }
    return(list(url = url))
  }
  
  # Generate URL on button click
  observeEvent(input$generate, {
    result <- generate_url(input$city)
    output$tab <- renderUI({
      tagList("URL link:", result$url)
    })
  })
}

# Run app
shinyApp(ui, server)