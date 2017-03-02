library(shiny)

shinyServer(function(input, output) {

  datasetInput <- reactive({
    data.frame(n=input$n, delta=input$delta, alpha=input$alpha, sigma=input$sigma, prob_x1=input$prob_x1, prob_z1=input$prob_z1, cond_z1=input$cond_z1, cond_z0=input$cond_z0)
    })

  output$inval <- renderTable({
    datainput <- datasetInput()
    if (is.na(datainput$prob_x1)) {
      datainput$prob_x1 <- (datainput$cond_z0*(1-datainput$prob_z1)) + (datainput$cond_z1*datainput$prob_z1)
    }
    else if (is.na(datainput$prob_z1)) {
      datainput$prob_z1 <- (datainput$prob_x1 - datainput$cond_z0)/(datainput$cond_z1 - datainput$cond_z0)
    }
    else if (is.na(datainput$cond_z1)) {
      datainput$cond_z1 <- (datainput$prob_x1 - (datainput$cond_z0*(1-datainput$prob_z1)))/datainput$prob_z1
    }
    else if (is.na(datainput$cond_z0)) {
      datainput$cond_z0 <- (datainput$prob_x1 - (datainput$cond_z1*datainput$prob_z1))/(1-datainput$prob_z1)
    }

    PharmIV.data <- data.frame(
      Name = c("Sample size",
               "Detectable treatment effect",
               "Significance level",
               "Residual variance",
               "Frequency of exposure, P(X=1)",
               "Frequency of instrument, P(Z=1)",
               "Probability of exposure given the instrument Z=1, P(X=1|Z=1)",
               "Probability of exposure given the instrument Z=0, P(X=1|Z=0)"
               ),
      Value = as.character(c(sprintf("%.0f",round(datainput$n,0)),
                            sprintf("%.3f",round(datainput$delta,3)),
                            sprintf("%.3f",round(datainput$alpha,3)),
                            sprintf("%.3f",round(datainput$sigma,3)),
                            sprintf("%.3f",round(datainput$prob_x1,3)),
                            sprintf("%.3f",round(datainput$prob_z1,3)),
                            sprintf("%.3f",round(datainput$cond_z1,3)),
                            sprintf("%.3f",round(datainput$cond_z0,3))
                             )),
      stringsAsFactors = FALSE)
  })


  output$power <- renderText({

    datainput <- datasetInput()
    if (is.na(datainput$prob_x1)) {
      datainput$prob_x1 <- (datainput$cond_z0*(1-datainput$prob_z1)) + (datainput$cond_z1*datainput$prob_z1)
    }
    else if (is.na(datainput$prob_z1)) {
      datainput$prob_z1 <- (datainput$prob_x1 - datainput$cond_z0)/(datainput$cond_z1 - datainput$cond_z0)
    }
    else if (is.na(datainput$cond_z1)) {
      datainput$cond_z1 <- (datainput$prob_x1 - (datainput$cond_z0*(1-datainput$prob_z1)))/datainput$prob_z1
    }
    else if (is.na(datainput$cond_z0)) {
      datainput$cond_z0 <- (datainput$prob_x1 - (datainput$cond_z1*datainput$prob_z1))/(1-datainput$prob_z1)
    }

    c_alpha <- (qnorm(1-(datainput$alpha/2)))
    x <- datainput$delta*datainput$prob_z1*(datainput$cond_z1-datainput$prob_x1)*sqrt(datainput$n)
    y <- datainput$sigma*sqrt(datainput$prob_z1*(1-datainput$prob_z1))
    p <- round(100*((pnorm(-c_alpha+(x/y)))+(pnorm(-c_alpha-(x/y)))),1)
    prob_x1_check <- ((datainput$cond_z0*(1-datainput$prob_z1)) + (datainput$cond_z1*datainput$prob_z1))

    if ((rowSums(is.na(datainput)))>1) {
      paste0("Please specify the parameters.")
    }
    else if (is.na(datainput$n)) {
      paste0("Please specify the sample size.")
    }
    else if (is.na(datainput$delta)) {
      paste0("Please specify the detectable treatment effect.")
    }
    else if (datainput$prob_x1<0 | datainput$prob_x1>1){
      paste0("Please specify the parameters so that P(X=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1).")
    }
    else if (datainput$prob_z1<0 | datainput$prob_z1>1){
      paste0("Please specify the parameters so that P(Z=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1).")
    }
    else if (datainput$cond_z1<0 | datainput$cond_z1>1){
      paste0("Please specify the parameters so that P(X=1||Z=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1).")
    }
    else if (datainput$cond_z0<0 | datainput$cond_z0>1){
      paste0("Please specify the parameters so that P(X=1||Z=0) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1).")
    }
    else if (abs(prob_x1_check-datainput$prob_x1)>1e-10) {
      paste0("Please specify the parameters so that P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1) is satisfied.")
    }
    else {
      paste0("Power is ",sprintf("%.1f",p),"%")
    }
  })

  })
