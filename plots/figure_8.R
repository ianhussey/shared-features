# Open and run analysis.Rmd so that the necessary objects are present in your environment, then run this script

library(metafor)
library(tidyverse)

add_heterogeneity_metrics_to_forest <- function(fit) {
    bquote(paste("RE Model (", 
                 italic('I')^"2", " = ", .(formatC(format(round(fit$I2, 1), nsmall = 1))),
                 "%, ", italic('H')^"2", " = ", .(formatC(format(round(fit$H2, 1), nsmall = 1))), ")"))
}


setwd("~/git/shared-features-paper/plots")

pdf(NULL)
dev.control(displaylist = "enable")

par(mfrow = c(3,1))

size <- 1.1

forest(meta_results_h1_sensitivity$fitted_model,
       xlab = "Cohen's d",
       addcred = TRUE,
       atransf = FALSE,
       refline = 0,
       xlim = c(-2.5, 4.5),
       at = c(0.0, 0.5, 1, 1.5, 2.0, 2.5), 
       cex = size,
       mlab = add_heterogeneity_metrics_to_forest(meta_results_h1_sensitivity$fitted_model))
text(-2.5, 9, "Implicit Association Test", pos = 4, cex = size)
text(4.5, 9, "Cohen's d [95% CI]", pos = 2, cex = size)

forest(meta_results_h2_sensitivity$fitted_model,
       xlab = "Cohen's d",
       addcred = TRUE,
       atransf = FALSE,
       refline = 0,
       xlim = c(-2.5, 4.5),
       at = c(0.0, 0.5, 1, 1.5, 2.0, 2.5), 
       cex = size,
       mlab = add_heterogeneity_metrics_to_forest(meta_results_h2_sensitivity$fitted_model))
text(-2.5, 10, "Self-reported evaluations", pos = 4, cex = size)
text(4.5, 10, "Cohen's d [95% CI]", pos = 2, cex = size)

forest(meta_results_h3_sensitivity$fitted_model,
       xlab = "Odds Ratio",
       addcred = TRUE,
       atransf = exp,
       refline = 0, # on log odds scale
       xlim = c(-4.65, 8.3),
       at = c(log(1), log(3), log(10), log(30), log(100)), 
       cex = size,
       mlab = add_heterogeneity_metrics_to_forest(meta_results_h3_sensitivity$fitted_model))
text(-4.65, 8, "Behavioural preference", pos = 4, cex = size)
text(8.3, 8, "OR [95% CI]", pos = 2, cex = size)


p1 <- recordPlot()
invisible(dev.off())

# # display the saved plot
# grid::grid.newpage()
# p1

pdf("figure_8",
    width = 5.7, 
    height = 10)
p1
dev.off()
