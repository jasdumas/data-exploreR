library(shiny)
library(DT)
library(corrplot)
library(Hmisc)
library(rpivotTable)
library(ggplot2)
library(GGally)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  data_in <- reactive({
    inFile <- input$upload
    
    if (is.null(inFile))
      return(NULL)
    dat = read.csv(inFile$datapath, header=input$header, sep=input$sep, 
             quote=input$quote)
    dat
  })
  
  output$contents <- DT::renderDataTable({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
   datatable(data_in())
    
  })
  
  output$summary <- renderPrint({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    summary(data_in())
  })
  
  output$str <- renderPrint({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    str(data_in())
  })
  
  missing_reactive <- reactive({ sum(is.na(data_in()))})
  
  output$missingtext <- renderText({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    h = paste0("There are ", missing_reactive(), " missing values in this dataset.")
    print(h)
  })
  
  output$columns <- renderUI({
    cols = colnames(data_in())
    selectInput("columnsUI", "Select a variable from the dataset:", choices = cols)
  })

  columns_reactive <- reactive({
    c = input$columnsUI
  })

  output$distribution <- renderPlotly({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    # hist(data_in()[[columns_reactive()]], col = "salmon", 
    #      probability = TRUE, breaks = as.numeric(input$n_breaks),
    #      main = paste0("Histogram of ", columns_reactive()), 
    #      ylab = paste0(columns_reactive()), xlab = "")
    # dens <- density(data_in()[[columns_reactive()]], adjust = input$bw_adjust)
    # lines(dens, col = "purple", type="b")
    # 
    
    plot_ly(x=data_in()[[columns_reactive()]], 
                 type="histogram", opacity = 0.6, showlegend = FALSE)

  })
  
  continuous_data <- reactive({
    continuous_data = data_in()[, sapply(data_in(), is.numeric) | sapply(data_in(), is.integer)]
    continuous_data = as.data.frame(continuous_data)
    print(length(continuous_data))
  })
  
  output$boxplot <- renderPlotly({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )

   plot_ly(y = data_in()[[columns_reactive()]], type="box")
  })
  
  output$pairsmatrix <- renderPlot({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    
    #ggpairs(continuous_data(), columns = 1:length(continuous_data()))
    ggpairs(data_in())
        
  })
  
  mcor <- reactive({
    mcor = cor(continuous_data(), use = "complete.obs")
  })
  
  # output$correlogram <- renderPlot({
  #   validate(
  #     need(data_in(), "Please select a dataset to upload.")
  #   )
  #   corrplot(matrix(mcor()), type="upper", order="hclust", tl.col="black", tl.srt=45)
  # })

  pivot_reactive <- reactive({
    p = rpivotTable(data_in())
    p
  })
  
  output$pivot <- renderRpivotTable({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    pivot_reactive()
  })
  
  
  output$algosmodels <- renderText({
    validate(
      need(data_in(), "Please select a dataset to upload.")
    )
    if (length(continuous_data()) <= 2) {
      t = paste0("Potential next steps include: Simple Linear Regression")
      print(t)
    } else if (length(continuous_data()) < 14) {
      t = paste0("Potential next steps include: Multiple Linear Regression")
      print(t)
    } else if (length(continuous_data()) > 15) {
      t = paste0("Potential next steps include: Variable Selection & Reduction")
      print(t)
    } else {
      print("This shoud not happen!")
    }
    
    
  })
})
