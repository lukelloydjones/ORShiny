shinyUI(pageWithSidebar(
  headerPanel("Linear model effects to odds ratios"),
  sidebarPanel(
    fileInput('file1', 'Choose file', accept=c('text/csv', 'text/comma-separated-values, text/plain', '.csv')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    numericInput("numericK", "Sample prevalence", min = 0.0, max = 1.0, value = 0.5, step = 0.1),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), 'Comma')
  ),
  mainPanel(
    tabsetPanel(id = "tabset",
         tabPanel("About",
                 h2("About"),
                 p("This Shiny app accompanies the manuscript titled 
                   'Mappings to the odds ratio from linear mixed models in genome-wide association studies'. This application
                   is designed to map regression coefficients from a linear model to the odds ratio from genome-wide
                   association studies (GWAS) on disease traits. It has been shown to be effective at mapping effects 
                   generated from
                   a linear mixed model GWAS to the odds ratio. This allows for a comparison between effects generated from 
                   logistic regression from other studies."),
                 p("Reference allele frequencies can be used if the user's summary statistics do not have sample allele 
                    frequencies. If this is the case then please replace the 'FREQ' column name with the reference allele
                    frequency for the effect allele."),
                 strong("The workflow is as follows:"),
                 p("i) the user loads a set of summary statistics results generated from a linear mixed model GWAS analysis using the
                    'Choose file' button. Different delimeters can be chosen. A sample prevalence value must be stipulated before
                    loading. If each variant or a set of variants has a different prevalence then this can be supplied as a new
                    column of to be loaded
                    summary statistics set. Please name this column 'K'."),
                 p("ii) the user can inspect the loaded summary statistics results generated and the mapped OR in the 
                   'Load and inspect' tab."),
                 p("iii) the user can then download the results from the 'Download' tab."),
                 p("For further questions, please contact l.lloydjones@uq.edu.au. This app was developed by Luke Lloyd-Jones.")
         ),
         tabPanel("Load and inspect",
                 h2("Browse for file to load data"),
                 tableOutput('contents')
         ),
         tabPanel("Download", value = 3,
                 h2("Download"),
                 div(id = "dl",
                   downloadButton("download", label = "Download"))
        )    
    )
  )
))
