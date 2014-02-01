library(shiny)
library(shinyIncubator)
library(ggplot2)
library(MCMCpack)
library(Rcpp)

source('GenerativeModel.R', echo=TRUE)
Rcpp::sourceCpp('DP_means.cpp')

shinyServer(function(input, output) {
  
  last_value = 0
  data <- reactiveValues()
  
  generate_data <- reactive(
  data$df <- generate_clustered_obs(K=input$K, n=input$obs, alpha0 = input$alpha, Sigma=input$Sigma, rho=input$Rho)
  )
  
  estimate_model <- reactive({
    df_temp = data$df
    dp_means(df_temp$x1, df_temp$x2, input$lambda)
  })
  
  output$iterations <- renderPrint({
   params = estimate_model()
   params[["iterations"]]
  })
  
  output$distPlot <- renderPlot({
    
    generate_data()
    # generate and plot an rnorm distribution with the requested
    # number of observations
     print(ggplot(data=data$df,aes(x=x1,y=x2))+geom_point(aes(col=z),size=2)+coord_fixed(ratio = 1)+labs(col="Cluster",title="Scatter plot showing the true hidden clusters"))  
    })
  
  output$estPlot <- renderPlot({
    
    generate_data()
    print(ggplot(data=data$df,aes(x=x1,y=x2))+geom_point(size=2)+coord_fixed(ratio = 1))     
    
    params = estimate_model() 
    last_value = input$button1
    
    Cluster = as.factor(params[["labels"]])
 
    df2 = cbind(data$df, Cluster)
    p = ggplot(data=df2,aes(x=x1,y=x2))+geom_point(aes(col=Cluster), size=2)+coord_fixed(ratio = 1)
    p = p + labs(title="Scatterplot showing the results of DP-means clustering")
    df3 = data.frame(x = params[["mu_x1"]], y =  params[["mu_x2"]])
    print(df3)
    p = p + geom_point(data=df3, aes(x=x,y=y), pch=5,size=2.5)
    print(p)     
    
  })
  
  

  
})
