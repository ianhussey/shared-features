# open and run plots.Rmd, then make your viewer pain tall and narrow sized, then run this script. Save the plot as a 5' by 10' pdf. 

par(mfrow = c(3,1))

size <- 1.1

forest(meta_results_h1_sensitivity$fitted_model,
       xlab = NULL,
       addcred = TRUE,
       atransf = FALSE,
       refline = 0,
       xlim = c(-1.1, 3.5),
       at = c(0.0, 0.5, 1, 1.5, 2.0), 
       cex = size)
text(-1.1, 9, "Implicit Association Test", pos = 4, cex = size)
text(3.5, 9, "Cohen's d [95% CI]", pos = 2, cex = size)

forest(meta_results_h2_sensitivity$fitted_model,
       xlab = NULL,
       addcred = TRUE,
       atransf = FALSE,
       refline = 0,
       xlim = c(-1.1, 3.5),
       at = c(0.0, 0.5, 1, 1.5, 2.0), 
       cex = size)
text(-1.1, 10, "Self-reported evaluations", pos = 4, cex = size)
text(3.5, 10, "Cohen's d [95% CI]", pos = 2, cex = size)

forest(meta_results_h3_sensitivity$fitted_model,
       xlab = NULL,
       addcred = TRUE,
       atransf = exp,
       refline = 0, # on log odds scale
       xlim = c(-2.7, 8.5),
       at = c(log(1), log(3), log(10), log(30), log(100)), 
       cex = size)
text(-2.7, 8, "Behavioural preference", pos = 4, cex = size)
text(8.5, 8, "OR [95% CI]", pos = 2, cex = size)
