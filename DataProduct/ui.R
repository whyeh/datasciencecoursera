library(shiny)
library(ggplot2)

shinyUI(
    fluidPage(
        titlePanel("Manufacturing Margin and Cost Calculator"),
        fluidRow(
            column(3, 
                   numericInput("labour", label = "Labour Hourly Rate", value = 25)
            ),
#             column(3, 
#                    numericInput("leng.shift", label = "Number of Hours per Shift", value = 8)
#             ),
            column(3, 
                   numericInput("indirect", label = "Hourly Indirect Burden", value = 81)
            )
        ),
        br(),
        
        fluidRow(
            column(3,
                   # textInput("inquiry1", label = "Inquiry Code", value = "Shift #, Product ID, etc..."),
                   numericInput("price1", label = "Product Price to Customer", value = 3.48),
                   numericInput("material1", label = "Material Cost", value = 1.9),
                   numericInput("direct1", label = "Direct Burden per Part", value = 0.25),
                   numericInput("num.operators1", label = "# of Operators Assigned", value = 4),
                   numericInput("ct1", label = "Theoretical Output CT (in sec)", value = 15),
                   numericInput("duration1", label = "Total Duration (in minutes)", value = 480),
                   numericInput("produced1", label = "# of Product Produced", value = 1280),
                   numericInput("planned1", label = "Planned Downtime (in minutes)", value = 50),
                   numericInput("downtime1", label = "Unplanned Downtime (in minutes)", value = 73),
                   numericInput("NG1", label = "# of NG outputs", value = 12),
                   actionButton("button1", "Show !")
            ), 
            column(8,
                   plotOutput("plot1", height = 550),
                   h4("Expected and Actual Profit"),
                   tableOutput("results")
            )
        )
#         br(),
#         
#         fluidRow(
#             checkboxInput(inputId = "compare",
#                           label = strong("Calculate Another Magin and Make Comparisons"),
#                           value = FALSE),
#             br(),
#             conditionalPanel(condition = "input.compare == true",
#                              column(3,
#                                     textInput("inquiry2", label = "Inquiry Code", value = "Shift #, Product ID, etc..."),
#                                     numericInput("price2", label = "Product Price to Customer", value = 0),
#                                     numericInput("material2", label = "Material Cost", value = 0),
#                                     numericInput("direct2", label = "Direct Burden per Part", value = 0),
#                                     numericInput("num.operators2", label = "# of Operators Assigned", value = 81),
#                                     numericInput("ct2", label = "Theoretical Output CT (in sec)", value = 0),
#                                     numericInput("duration2", label = "Total Duration (in minutes)", value = 0),
#                                     numericInput("produced2", label = "# of Product Produced", value = 0),
#                                     numericInput("planned2", label = "Planned Downtime (in minutes)", value = 50),
#                                     numericInput("downtime2", label = "Unplanned Downtime (in Minutes)", value = 0),
#                                     numericInput("NG2", label = "# of NG outputs", value = 0),
#                                     actionButton("button2", "Show !!")
#                              ), 
#                              column(6,
#                                     plotOutput("plot2", height = 400)
#                              ),
#                              br(),
#             )
#         )
    )
)