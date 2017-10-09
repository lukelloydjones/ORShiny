source("shiny_lmor_func.R")
options(shiny.maxRequestSize=500*1024^2)
library(readr) 
shinyServer(function(input, output) {
  withProgress(message = "LOADING . . . PLEASE WAIT", value = 0.9,
  {
      # Number of times we'll go through the loop
      #load("uk10k_af")
  }) 
  
  output$contents <- renderTable({ 
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.

    inFile <- input$file1

    if (is.null(inFile))
    {
      return(NULL)
    }
    x <- read_delim(inFile$datapath, col_names=T, delim = input$sep)
    c.names <- colnames(x)
    if (length(which(c.names == "K")) == 1)
    {
      bound   <<- LmToOddsRatio(x, x$K, 0)	
    } else
    {
      bound   <<- LmToOddsRatio(x, input$numericK, 0)
    }
    return(head(bound, 50))
  })
  
  output$download <- downloadHandler(
    filename = function() {
      paste0("transformed_", input$file1)
    }, 
    content = function(file) {
      write.table(bound, file, sep = "\t", row.names = FALSE, quote = FALSE)
    }
  )
  
    # Show the first "n" observations
  output$view <- renderTable({
    input.df <- data.frame(input$numericB, input$numericK, input$numericP)
    colnames(input.df) <- c("BETA", "K", "FREQ")
	bound   <<- LmToOddsRatio(input.df, input$numericK, 0)
    bound
  }, include.rownames=FALSE)
    
})
