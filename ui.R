
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Clustered Observations"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    tags$head( tags$script(src="http://cdn.mathjax.org/mathjax/2.0-latest/MathJax.js?config=TeX-AMS_HTML") ),
    sliderInput("obs", 
                "Number of observations:", 
                min = 1, 
                max = 1000, 
                value = 500),
    sliderInput("K",
                "Number of clusters",
                 min = 1,
                max = 25,
                value = 4),
    numericInput("Rho",
                 "\\( \\rho \\): Variance of \\( \\theta_k \\)", value=1, min=0,max=100),
    matrixInput('Sigma', '\\( \\Sigma \\): Covariance Matrix of \\( x_i \\)', data.frame(diag(2)))
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))
