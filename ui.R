library(shiny)


shinyUI(pageWithSidebar(
      # Application name
      headerPanel("Miles per gallon predictor"),
      
      # Conditional Sidebar to control the variables to include for the prediction
      sidebarPanel(
            checkboxGroupInput(inputId = "t_cyl", 
                               label   = "Select variables account for :",
                               choices = c("Cylinders"            = "cyl")
                              ),
            checkboxGroupInput(inputId = "t_disp", 
                               label   = NULL,
                               choices = c("Displacement"         = "disp")
                              ),
             checkboxGroupInput(inputId = "t_hp", 
                               label   = NULL,
                               choices = c("Horse Power"          = "hp")
                              ),
            checkboxGroupInput(inputId = "t_wt", 
                               label   = NULL,
                               choices = c("Weight"               = "wt")
                              ),
            checkboxGroupInput(inputId = "t_qsec", 
                               label   = NULL,
                               choices = c("1/4 mile time"        = "Qsec")
                              ),
            checkboxGroupInput(inputId = "t_vs", 
                               label   = NULL,
                               choices = c("V or Straight engine" = "vs")
                              ),
            checkboxGroupInput(inputId = "t_am", 
                               label   = NULL,
                               choices = c("Transmission"         = "am")
                              ),
            checkboxGroupInput(inputId = "t_gear", 
                               label   = NULL,
                               choices = c("Gears"                = "gear")
                              ),
            checkboxGroupInput(inputId = "t_carb", 
                               label   = NULL,
                               choices = c("Nb. carburators"      = "carb")
                              ),
            conditionalPanel(
                              condition = "input.t_cyl == 'cyl'",
                  
                              radioButtons(inputId  = "v_cyl", 
                                           label    = "Cylinders :",
                                           choices  = list( "4 cyl" = 4,
                                                            "6 cyl" = 6,
                                                            "8 cyl" = 8),
                                           selected = 4,
                                           inline   = TRUE
                                          )
                              ),
            conditionalPanel(
                              condition = "input.t_disp == 'disp' ",
                  
                              sliderInput(inputId   = "v_disp", 
                                          label     =  "Displacement (cu.in.):", 
                                          value     = 271.5, 
                                          min       = 71.1, 
                                          max       = 472.0, 
                                          animate   = TRUE
                                          )
                              ),
            conditionalPanel(
                              condition = "input.t_hp == 'hp' ",
                  
                              sliderInput(inputId   = "v_hp", 
                                          label     = "Gross horsepower:", 
                                          value     = 193.5, 
                                          min       = 52, 
                                          max       = 335, 
                                          animate   = TRUE
                                          )
                              ),            
            conditionalPanel(
                             condition = "input.t_wt == 'wt' ",

                             sliderInput(inputId   = "v_Weight", 
                                         label     = "Weight (in lb/1000):", 
                                         value     = 3.468, 
                                         min       = 1.513, 
                                         max       = 5.424, 
                                         animate   = TRUE
                                         )
                            ),
            conditionalPanel(
                              condition = "input.t_qsec == 'Qsec'",
                  
                              sliderInput(inputId  = "v_Qsec", 
                                          label    = "1/4 mile time (in sec)", 
                                          value    = 18.7, 
                                          min      = 14.5, 
                                          max      = 22.9,
                                          step     = 0.1,
                                          round    = -1,
                                          animate  = TRUE
                                          )
                              ),
            conditionalPanel(
                              condition = "input.t_vs == 'vs'",
                  
                              radioButtons(inputId  = "v_vs", 
                                           label    = "V or Straight engine:",
                                           choices  = list("V"        = 0,
                                                           "Straight" = 1),
                                           selected = 1,
                                           inline   = TRUE
                                          )
                              ),
            conditionalPanel(
                              condition = "input.t_am == 'am'",
                  
                              radioButtons(inputId  = "v_am", 
                                           label    = "Transmission type:",
                                           choices  = list("Automatic" = 0,
                                                           "Manual"    = 1),
                                           selected = 1,
                                           inline   = TRUE
                                          )
                              ),
            conditionalPanel(
                              condition = "input.t_gear == 'gear'",
                  
                              radioButtons(inputId = "v_gear", 
                                           label   = "Number of forward gears:",
                                           choices = list("3" = 3,
                                                          "4" = 4,
                                                          "5" = 5),
                                           selected= 4,
                                           inline  = TRUE
                  )
            ),
            conditionalPanel(
                  condition = "input.t_carb == 'carb'",
                  
                  radioButtons(inputId = "v_carb", 
                               label   = "Number of carburators:",
                               choices = list("1" = 1,
                                              "2" = 2,
                                              "3" = 3,
                                              "4" = 4,
                                              "6" = 6,
                                              "8" = 8),
                               selected= 4,
                               inline  = TRUE
                  )
            ),
            actionButton(inputId = "estimateButton",
                         label   = "Get estimation"
                        )
            
#             sidebarPanel(helpText("Notes ")
#                         )
      ),      
      
      # Show a tabs to display estimated mpg consumption, mtcars summary, mtcars table, plots
      mainPanel(
            tabsetPanel(
                  
                  tabPanel("Estimation",
                           h2("Estimation infos", align="center") ,
                           
                           p("The proposed predictor used the ", strong("mtcars"), " dataset and fits a multivariate linear regression model
                             on the whole dataset to calculate the regression of the outcome mpg on the other variables"
                             ), 

                           h3("Estimation interval"),
                           
                           p("The mpg estimation and the corresponding confidence interval (at 0.95 level) are obtained by applying 
                             the fitted model on the data povided by the user and calling the predict function with the interval keyword set to predict"
                            ),
                           
                           p("Here are the estimated mpg value for your car,
                              wih lower bound confidence interval and 
                              upper bound confidence interval :"
                            ),
                           
                           code(textOutput("estimate"))
                           
                           ),
                  
                  tabPanel("Dataset", 
                           h2("Raw data from the mtcars dataset"),
                           tableOutput("table")
                  ),
                  
                  tabPanel("Dataset Info", 
                           h2("Summary of mtcars dataset"),
                           verbatimTextOutput("summary"),
                           h2("Summary of the fitted model"),
                           verbatimTextOutput("SumMod") 
                          ), 
                  
                  tabPanel("Model Diagnostic" ,
                           h4("Top-Left     : the residuals vs predicted values plot allows to detect hereroskedasticity"),
                           h4("Top-Right    : the plot is used to check if the assumption of normal distribution for errors holds"),
                           h4("Bottom-Left  : the ‘Spread-Location’ plot shows the square root of the absolute residuals"),
                           h4("Bottom-right : allows to identify points of the dataset with hight leverage on the fitted model"),
                           plotOutput("diagplot")),
                  
                  tabPanel("Help",
                           h3("Notice"),
                           helpText("First select the caracteristics of your car that you want to use for the estimation."),
                           helpText("Then in the corresponding boxes, enter the values corresponding to your car."),
                           helpText("Press the", strong("Get estimation")," button to compute the estimation using the model"),
                           helpText("Finally check on the ", strong("Estimation")," tab to obtain your predicted Miles 
                                    per Gallon fuel consumption."),
                           h4("Here's the model currently used:"),
                           h3(textOutput("caption"))
                           )
            )
            )
))