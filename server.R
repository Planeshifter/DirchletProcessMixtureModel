library(shiny)
library(shinyIncubator)
library(ggplot2)
library(MCMCpack)
library(Rcpp)

source('GenerativeModel.R', echo=TRUE)
source('DP-means.R', echo=TRUE)
Rcpp::sourceCpp('DP_means.cpp')

shinyServer(function(input, output) {
  
  last_value = 0
  data <- reactiveValues()
  
  generate_data <- reactive(
  data$df <- generate_clustered_obs(K=input$K, n=input$obs, Sigma=input$Sigma, rho=input$Rho)
  )
  
  estimate_model <- reactive({
    df_temp = data$df
    dp_means(df_temp$x1, df_temp$x2, input$lambda)
  })
  
  output$distPlot <- renderPlot({
    
    generate_data()
    # generate and plot an rnorm distribution with the requested
    # number of observations
     print(ggplot(data=data$df,aes(x=x1,y=x2))+geom_point(aes(col=z),size=2)+coord_fixed(ratio = 1)+labs(col="Cluster"))  
    })
  
  output$estPlot <- renderPlot({
    
    generate_data()
    print(ggplot(data=data$df,aes(x=x1,y=x2))+geom_point(size=2)+coord_fixed(ratio = 1))     
    
    params = estimate_model() 
    last_value = input$button1
    Cluster = as.factor(params[["labels"]])
    df2 = cbind(data$df, Cluster)
    print(ggplot(data=df2,aes(x=x1,y=x2))+geom_point(aes(col=Cluster), size=2)+coord_fixed(ratio = 1))     

  })
  
  

  
})
