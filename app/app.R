library(shiny)
library(randomForest)

model <- readRDS(
  "../models/final_random_forest_model.rds"
)

ui <- fluidPage(
  
  titlePanel("Industrial Robot Failure Prediction"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        "type",
        "Machine Type",
        choices = c("H", "L", "M"),
        selected = "M"
      ),
      
      numericInput(
        "air_temp",
        "Air Temperature (K)",
        value = 300
      ),
      
      numericInput(
        "process_temp",
        "Process Temperature (K)",
        value = 310
      ),
      
      numericInput(
        "speed",
        "Rotational Speed (rpm)",
        value = 1500
      ),
      
      numericInput(
        "torque",
        "Torque (Nm)",
        value = 45
      ),
      
      numericInput(
        "tool_wear",
        "Tool Wear (min)",
        value = 180
      ),
      
      actionButton(
        "predict",
        "Predict Failure"
      )
    ),
    
    mainPanel(
      
      h3("Prediction Result"),
      
      verbatimTextOutput("prediction"),
      
      h3("Failure Probability"),
      
      verbatimTextOutput("probability"),
      
      hr(),
      
      h2("Visualizations"),
      
      h3("Machine Failure Distribution"),
      
      imageOutput(
        "failure_distribution",
        height = "400px"
      ),
      
      h3("Tool Wear vs Torque"),
      
      imageOutput(
        "tool_wear_torque",
        height = "400px"
      ),
      
      h3("Rotational Speed vs Torque"),
      
      imageOutput(
        "speed_torque",
        height = "400px"
      )
    )
  )
)

server <- function(input, output) {
  
  result <- eventReactive(input$predict, {
    
    new_machine <- data.frame(
      Type = factor(
        input$type,
        levels = c("H", "L", "M")
      ),
      Air.temperature..K. = input$air_temp,
      Process.temperature..K. = input$process_temp,
      Rotational.speed..rpm. = input$speed,
      Torque..Nm. = input$torque,
      Tool.wear..min. = input$tool_wear,
      Power = input$speed * input$torque
    )
    
    prediction <- predict(
      model,
      newdata = new_machine,
      type = "class"
    )
    
    probability <- predict(
      model,
      newdata = new_machine,
      type = "prob"
    )
    
    list(
      prediction = prediction,
      probability = probability
    )
  })
  
  output$prediction <- renderText({
    
    req(result())
    
    prediction <- as.character(
      result()$prediction
    )
    
    if (prediction == "1") {
      "Machine Failure Predicted"
    } else {
      "No Machine Failure Predicted"
    }
  })
  
  output$probability <- renderText({
    
    req(result())
    
    probability <- result()$probability
    
    paste0(
      "Failure Probability: ",
      round(probability[1, "1"] * 100, 2),
      "%\n",
      "No Failure Probability: ",
      round(probability[1, "0"] * 100, 2),
      "%"
    )
  })
  
  output$failure_distribution <- renderImage({
    
    list(
      src = normalizePath(
        "../plots/final_failure_distribution.png"
      ),
      contentType = "image/png",
      width = 700,
      height = 400
    )
    
  }, deleteFile = FALSE)
  
  output$tool_wear_torque <- renderImage({
    
    list(
      src = normalizePath(
        "../plots/tool_wear_vs_torque.png"
      ),
      contentType = "image/png",
      width = 700,
      height = 400
    )
    
  }, deleteFile = FALSE)
  
  output$speed_torque <- renderImage({
    
    list(
      src = normalizePath(
        "../plots/final_speed_torque.png"
      ),
      contentType = "image/png",
      width = 700,
      height = 400
    )
    
  }, deleteFile = FALSE)
}

shinyApp(
  ui = ui,
  server = server
)