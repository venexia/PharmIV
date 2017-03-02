library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Power calculator for instrumental variable analysis in pharmacoepidemiology"),
  
  sidebarPanel(
    numericInput("n", "Sample size:", value=NULL, min=0),
    numericInput("delta", "Detectable treatment effect:", value=NULL),
    numericInput("alpha", "Significance level:", value=0.05, max=1, min=0),
    numericInput("sigma","Residual variance, E(U\U00B2):", value=1.00),
    helpText("At least three of the following four parameters must be specified:"),
    numericInput("prob_x1", "Frequency of exposure, P(X=1):", value=NULL, max=1, min=0),
    numericInput("prob_z1", "Frequency of instrument, P(Z=1):", value=NULL, max=1, min=0),
    numericInput("cond_z1", "Probability of exposure given the instrument Z=1, P(X=1|Z=1): ", value=NULL, max=1, min=0),
    numericInput("cond_z0", "Probability of exposure given the instrument Z=0, P(X=1|Z=0): ", value=NULL, max=1, min=0),
    submitButton("Update")
  ),
  
  mainPanel(
    p('The formula used in this power calculator is applicable for instrumental variable analysis studies using a single binary instrument Z to analyse the causal effect of a binary exposure X on a continuous outcome Y. The outcome is modelled as Y=\U03B1+\U03B2X+U, where U is a zero-mean error term containing unobserved confounders, determining both the outcome Y and the treatment X. The instrument Z affects treatment X, but is not associated with the unobserved confounders and has no direct effect on the outcome Y.'),
    tableOutput("inval"),
    verbatimTextOutput("power"),
    p('If you use this tool, please cite:'),
    p('Walker, V. M., Davies, N. M., Windmeijer, F., Burgess, S. & Martin, R. M. Power calculator for instrumental variable analysis in pharmacoepidemiology. bioRxiv 084541 (2016). doi:10.1101/084541'),
    p(a("The code used to create this app, as well as packages for use in Stata and R, can be downloaded here.",     href="https://github.com/venexia/PharmIV"))
  )
  
))