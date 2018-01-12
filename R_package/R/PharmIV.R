PharmIV <- function(n = NULL, delta = NULL, alpha = 0.05, sigma = 1.00, prob_x1 = NULL, prob_z1 = NULL, cond_z1 = NULL, cond_z0 = NULL) {

    if (is.null(n)) {
      stop("Please specify the sample size (n).")
    }

    if (is.null(delta)) {
      stop("Please specify the detectable treatment effect (delta).")
    }

    optdata <- c(prob_x1, prob_z1, cond_z1, cond_z0)
    l <- length(optdata)
    if (l < 3) {
      stop(
        "At least three of the following must be specified: P(X=1), P(Z=1), P(X=1|Z=1), P(X=1|Z=0)."
      )
    }

    if ((prob_x1 < 0 | prob_x1 > 1) && !is.null(prob_x1)) {
      stop(
        "Please specify the parameters so that P(X=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
      )
    }

    if ((prob_z1 < 0 | prob_z1 > 1) && !is.null(prob_z1)) {
      stop(
        "Please specify the parameters so that P(Z=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
      )
    }

    if ((cond_z1 < 0 | cond_z1 > 1) && !is.null(cond_z1)) {
      stop(
        "Please specify the parameters so that P(X=1||Z=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
      )
    }

    if ((cond_z0 < 0 | cond_z0 > 1) && !is.null(cond_z0)) {
      stop(
        "Please specify the parameters so that P(X=1||Z=0) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
      )
    }

    if (is.null(prob_x1)) {
      prob_x1 <- (cond_z0 * (1 - prob_z1)) + (cond_z1 * prob_z1)
    }

    if (is.null(prob_z1)) {
      prob_z1 <- (prob_x1 - cond_z0) / (cond_z1 - cond_z0)
    }

    if (is.null(cond_z1)) {
      cond_z1 <- (prob_x1 - (cond_z0 * (1 - prob_z1))) / prob_z1
    }

    if (is.null(cond_z0)) {
      cond_z0 <- (prob_x1 - (cond_z1 * prob_z1)) / (1 - prob_z1)
    }

    prob_x1_check <- ((cond_z0 * (1 - prob_z1)) + (cond_z1 * prob_z1))
    if (abs(prob_x1_check - prob_x1) > 1e-10) {
      stop(
        paste0(
          "Please specify the parameters so that P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1) is satisfied."
        )
      )
    }

    c_alpha <- (qnorm(1 - (alpha / 2)))
    x <- delta * prob_z1 * (cond_z1 - prob_x1) * sqrt(n)
    y <- sigma * sqrt(prob_z1 * (1 - prob_z1))
    p <- round(100 * ((pnorm(-c_alpha + (x / y))) + (pnorm(-c_alpha - (x / y)))), 1)

    PharmIV.data <- data.frame(
      Name = c(
        "Sample size",
        "Detectable treatment effect",
        "Significance level",
        "Residual variance",
        "Frequency of exposure, P(X=1)",
        "Frequency of instrument, P(Z=1)",
        "Probability of exposure given the instrument Z=1, P(X=1|Z=1)",
        "Probability of exposure given the instrument Z=0, P(X=1|Z=0)",
        "Power (%)"
      ),
      Value = as.character(
        c(
          n,
          delta,
          alpha,
          sigma,
          prob_x1,
          prob_z1,
          cond_z1,
          cond_z0,
          p
        )
      ),
      stringsAsFactors = FALSE
    )

    return(PharmIV.data)
  }
