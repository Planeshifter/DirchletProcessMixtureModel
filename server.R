library(shiny)
library(shinyIncubator)
library(ggplot2)
library(MCMCpack)
source('GenerativeModel.R', echo=TRUE)

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
     
    # generate and plot an rnorm distribution with the requested
    # number of observations
    df = generate_clustered_obs(K=input$K, n=input$obs, Sigma=input$Sigma, rho=input$Rho)
    print(ggplot(data=df,aes(x=x1,y=x2))+geom_point(aes(col=z),size=2)+coord_fixed(ratio = 1))
    
  })
  
})
