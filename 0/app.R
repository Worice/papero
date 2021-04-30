library(shiny)
library(shinyFiles)
library(rvest)
library(xml2)
library(selectr)
library(stringr)
library(jsonlite)
library(DT)

# Define UI for app that draws a histogram ----
ui <- pageWithSidebar(
    # App title ----
    headerPanel("Porchi per sguardi!"),
        # Sidebar panel for inputs ----
        sidebarPanel(
            textInput("txt", "Enter the text to display below:"),
            textOutput("text"),
            verbatimTextOutput("verb"),
            
            DT::dataTableOutput("mytable")
        ),
        # Main panel for displaying outputs ----
       mainPanel(
       )
)

server <- function(input, output) {
       output$text <- renderText({ input$txt })
       output$verb <- renderText({ input$txt })

    
    url_name <- 'https://scholar.google.com/scholar?hl=en&as_sdt=0%2C38&q=diabetes&btnG='
    wp <- xml2::read_html(url_name)
    # Extract raw data
    titles <- rvest::html_text(rvest::html_nodes(wp, '.gs_rt'))
    authors_years <- rvest::html_text(rvest::html_nodes(wp, '.gs_a'))
    # Process data
    authors <- gsub('^(.*?)\\W+-\\W+.*', '\\1', authors_years, perl = TRUE)
    years <- gsub('^.*(\\d{4}).*', '\\1', authors_years, perl = TRUE)
    # Make data frame
    df <- data.frame(titles = titles, authors = authors, years = years, stringsAsFactors = FALSE)
    
    # print search
    output$mytable <- DT::renderDataTable({ df })
}

shinyApp(ui = ui, server = server)