library(datasets)
library(shiny)


# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
mpgData     <- mtcars
mpgData$am  <- as.factor(mpgData$am)
mpgData$cyl <- as.factor(mpgData$cyl)
mpgData$vs  <- as.factor(mpgData$vs)
mpgData$gear<- as.factor(mpgData$gear)
mpgData$carb<- as.factor(mpgData$carb)

# fitting linear model
modelFit <- lm(mpg ~ cyl + disp + hp + drat + wt + qsec + vs + am + gear + carb , data = mpgData)

# Choose a model by AIC in a Stepwise Algorithm
#select_model <- step(modelFit, direction="forward")

# generate model summary
summary(modelFit)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
            
            # Reactive expression to predict the mpg. This is 
            # called whenever the inputs change. The renderers defined 
            # below then all use the value computed from this expression
      
            output$estimate <- renderText({ 
                                    input$estimateButton
                                    isolate({
                                          customdata <- data.frame(cyl  = car_cyl(),
                                                                   disp = car_disp(),
                                                                   hp   = car_hp(),
                                                                   drat = 3.695,
                                                                   wt   = car_weight(), 
                                                                   qsec = input$v_Qsec,
                                                                   vs   = car_vs(),
                                                                   am   = input$v_am,
                                                                   gear = input$v_gear,
                                                                   carb = car_carb()
                                                                  )
                                                print(customdata)
                                                estimate   <- predict(modelFit, customdata , interval = "predict")
                                                    })
                                           })
            
            # Generate diagnostic plot s
            output$diagplot <- renderPlot({
                                         layout(matrix(c(1,2,3,4),2,2, byrow = TRUE))
                                         plot(modelFit, panel = panel.smooth)
                                       })
            # Create reactive functions
            car_cyl    <- reactive({
                                   cyl <- as.factor(input$v_cyl)
                                  })
            car_disp   <- reactive({
                                   disp <- as.numeric(input$v_disp)
                                  })
            car_hp     <- reactive({
                                   hp <- as.numeric(input$v_hp)
                                  })
            car_weight <- reactive({
                                   wt <- as.numeric(input$v_Weight)
                                  })
            car_vs     <- reactive({
                                   vs <- as.factor(input$v_vs)
                                  })
            car_carb   <- reactive({
                                   carb <- as.factor(input$v_carb)
                                  })
            
            
                        
            # Generate a summary of the data
            output$summary <- renderPrint({
                                          summary(mpgData)
                                         })
            
            # Generate a summary of the model
            output$SumMod <- renderPrint({
                                          summary(modelFit)
                                        })
            
            # Generate an HTML table view of the data
            output$table <- renderTable({
                                         data.frame(mpgData)
                                       })
            
            formulaText <- reactive({
                   paste("mpg ~ ",input$t_cyl, input$t_disp, input$t_hp, input$t_wt,
                                  input$t_qsec, input$t_vs, input$t_am, input$t_gear, input$t_carb)
             })

            output$caption <- renderText(
                                        formulaText()
                                        )
})
