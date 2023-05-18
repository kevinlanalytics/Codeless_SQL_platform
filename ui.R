ui <- navbarPage(
  title ='DATA_platform',
  tabPanel('Data',
           sidebarPanel(
             selectInput("variable1", "Select a Data table:", choices = NULL, selected = NULL),
             selectizeInput("col_select", "Select Data column(s):",choices = NULL, selected=NULL, multiple= TRUE),
             uiOutput("filters"),
             uiOutput("filters1"),
             selectInput(inputId =  "data_Pro2",
                         label = "Choose a column for processing",
                         choices = "None", selected = 'None'),
             # checkboxInput("Proc_checkbox", "Do you want to process a column?",value = FALSE),             
             selectInput("filters3", "Choose a processing method for the column you selected", choices = NULL, selected = NULL),
             actionButton(inputId = "SubmitButton",label = "Submit"),
             width = 2
           ),
           mainPanel(
             tabsetPanel(
               id = 'dataset',
               tabPanel("Data Selected",
                        textOutput("text1"),
                        verbatimTextOutput("text2"),
                        DT::dataTableOutput("table1")),
               tabPanel("Data Structure",
                        verbatimTextOutput("summary"),
                        verbatimTextOutput("row"),
                        verbatimTextOutput("col")),
               tabPanel("Customization",
                        sidebarPanel(
                          selectInput(inputId =  "data_Pro3",
                                      label = "Choose a column to customize",
                                      choices = "None", selected = 'None'),
                          textInput("textinput", label= "New Column Name (no space, no comma)", value = "Enter text...")
                        ))
             ))
  ),
  tabPanel('Visualization',
           sidebarPanel("To display a histogram or bar chart, choose one variable for x or y and set the other to 'None'",
                        selectInput("X_variable", "X Axis Variable", choices = NULL),
                        selectInput("Y_variable", "Y Axis Variable", choices = NULL),
                        radioButtons("plotType", "Plot type",c("Scatter"="geom_point", "Line"="geom_line","Histogram"="geom_histogram","Box and Whisker"= "geom_boxplot","Bar"="geom_bar")),
                        # verbatimTextOutput("row"),
                        # verbatimTextOutput("col"),
                        actionButton(inputId = "SubmitButton2",label = "Submit"),
                        width = 2
           ),
           mainPanel(
             tabsetPanel(
               id = 'dataset',
               tabPanel("Data Selected",
                        textOutput("Yay Text Boxes"),
                        # verbatimTextOutput("summary"),
                        DT::dataTableOutput("table2")),
               tabPanel("Visualization",
                        plotOutput("plot"))))
  ),
  navbarMenu("More",
             #download as RMD, Paste in 1st text, SQuery_final, Last text
             tabPanel("Download as R",
                      downloadButton("downloadData", "Download R File")
             ),
             tabPanel("Data Dictionary",
                      titlePanel("ShinyBS tooltips"),
                      tipify(actionButton("btn", "On hover"),"Hello! This is a hover pop-up!",placement = "bottom", trigger ="hover"),
                      tipify(actionButton("btn2", "On click"), "Hello again! This is a click-able pop-up", placement="bottom", trigger = "click"),
                      tags$figure(align = "center",
                                  tags$img(src = "TravelData.jpg",width = 600,alt = "Travel Data Summary Table"),
                        tags$figcaption("Travel Data Summary Table - please see data dictionaries for more details")
                      )),
             tabPanel("Sub-Component C")
  )
)
