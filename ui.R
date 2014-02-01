
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Dirichlet Process Mixture Modelling"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    tags$head( tags$script(src="http://cdn.mathjax.org/mathjax/2.0-latest/MathJax.js?config=TeX-AMS_HTML") ),
    
    p(strong("Generate Observations")),
    sliderInput("obs", 
                "Number of observations:", 
                min = 1, 
                max = 1000, 
                value = 500),
    sliderInput("K",
                "Number of clusters",
                 min = 1,
                max = 20,
                value = 4),
    numericInput("Rho",
                 "\\( \\rho \\): Variance of \\( \\theta_k \\)", value=1, min=0,max=100),
    matrixInput('Sigma', '\\( \\Sigma \\): Covariance Matrix of \\( x_i \\)', data.frame(diag(2))),
    wellPanel(
      p(strong("DP-Means")),
      sliderInput("lambda",
                  "Penalty parameter \\( \\lambda \\)",
                  min = 1,
                  max = 200,
                  value = 100,
                  animate = FALSE)
    )
      
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("DGP", plotOutput("distPlot")),
      tabPanel("Prediction",plotOutput("estPlot")),
      tabPanel("Code",
               h3(HTML("GenerativeModel.R")),
               HTML('<script src="https://gist.github.com/Planeshifter/4e512b6d842e1436768d.js"></script>')
               )
               )
          )
  )
)
