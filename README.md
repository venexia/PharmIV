# PharmIV

This respository supplies the tools necessary to calculate the power of an instrumental variable analysis study using a single binary instrument Z to analyse the causal effect of a binary exposure X on a continuous outcome Y in the context of pharmacoepidemiology. If you use this material, please cite:

Walker, V. M., Davies, N. M., Windmeijer, F., Burgess, S. & Martin, R. M. Power calculator for instrumental variable analysis in pharmacoepidemiology. bioRxiv 084541 (2016). doi:10.1101/084541

## R_package

This folder contains the R package to calculate the power of an instrumental variable analysis study using a single binary instrument Z to analyse the causal effect of a binary exposure X on a continuous outcome Y. The syntax for this package is as follows:

```
PharmIV(n = NULL, delta = NULL, alpha = 0.05, sigma = 1.00, prob_x1 = NULL, prob_z1 = NULL, cond_z1 = NULL, cond_z0 = NULL)
```

## Shiny

This folder contains the code to produce the power calculator Shiny app. The app is avaliable at: https://venexia.shinyapps.io/PharmIV/. 

## Stata_package

This folder contains the Stata package to calculate the power of an instrumental variable analysis study using a single binary instrument Z to analyse the causal effect of a binary exposure X on a continuous outcome Y. The syntax for this package is as follows:

```
PharmIV, n(numlist) delta(numlist) alpha(numlist) sigma(numlist) prob_x1(numlist) prob_z1(numlist) cond_z1(numlist) cond_z0(numlist) 
```

## Stata_paper

This folder contains the code to reproduce the paper "Power calculator for instrumental variable analysis in pharmacoepidemiology".

