library(shiny)
library(DT)
library(corrplot)
library(Hmisc)
library(rpivotTable)
library(ggplot2)
library(GGally)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = "http://bootswatch.com/flatly/bootstrap.css",
  
  # Application title
  titlePanel("Data ExploreR"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width=3,
       helpText("Upload a dataset of your choice and perform exploratory data analysis"), 
       fileInput("upload", "Select a file to upload", 
                 accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')), 
       hr(),
       checkboxInput('header', 'Header', TRUE),
       radioButtons('sep', 'Separator',
                    c(Comma=',',
                      Semicolon=';',
                      Tab='\t'),
                    ','),
       radioButtons('quote', 'Quote',
                    c(None='',
                      'Double Quote'='"',
                      'Single Quote'="'"),
                      '"'),
        
       
       hr(), 
       hr(),
       HTML("Made for fun by: <a href=mailto:jasmine.dumas@gmail.com>Jasmine Dumas</a>")
    ),
    # main panel
    mainPanel(
      
       tabsetPanel(type = "pills",
                   tabPanel(title = "About", 
                            hr(), 
                            h3("What can we learn about the data before modeling?"), 
                            p("In statistics, exploratory data analysis (EDA) is an approach to analyzing 
                              data sets to summarize their main characteristics, often with visual methods.
                              A statistical model can be used or not, but primarily EDA is for seeing what 
                              the data can tell us beyond the formal modeling or hypothesis testing task. "),
                            HTML("<a href='https://en.wikipedia.org/wiki/Exploratory_data_analysis'> Further Reading on EDA from Wikipedia</a>"),
                            hr(), 
                            
                            img(src="DS_process.png", height = 450, width=600), p("Picture Source: https://en.wikipedia.org/wiki/File:Data_visualization_process_v1.png")
                            ),
                   tabPanel(title = "Table", 
                            hr(),
                            DT::dataTableOutput("contents") 
                            ),
                   tabPanel(title = "Summary", 
                            hr(),
                            h4("Statistical Summary"),
                            verbatimTextOutput("summary"), 
                            h4("Variable Contents"),
                            verbatimTextOutput("str")
                            ),
                   tabPanel(title = "Missing Values", 
                            hr(),
                            p("Missing values are a frequent problem for researchers and modelers. A significant amount of missing values
                              can lead to poor interpretation of the data, a decrease in confidence of the calculations, and restrictions
                              on statistical modeling techniques."),
                            
                            textOutput("missingtext")
                            ),
                   tabPanel(title = "Distribution", 
                            hr(),
                            h4("Histogram"),
                            uiOutput("columns"),
                            br(),
                            plotlyOutput("distribution"), 
                            h4("Boxplot"), 
                            plotlyOutput("boxplot")
                            ),
                   tabPanel(title = "Linear Assumptions",
                            hr(),
                            h4("Scatterplot Matrix"),
                            plotOutput("pairsmatrix") #, 
                            #h4("Correlation Visualization"), 
                            #plotOutput("correlogram") 
                            ), 
                  tabPanel(title = "Pivot Table",
                           hr(),
                           h4("Pivot Table"),
                           rpivotTableOutput("pivot")
                           ), 
                  tabPanel(title="Models & Algorithms", 
                           hr(),
                           textOutput("algosmodels"))
    )
  )
)))
