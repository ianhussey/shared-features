

results_for_meta_analysis_h1_sensitivity <- read.csv("../plots/results_for_meta_analysis_h1_sensitivity.csv")
results_for_meta_analysis_h2_sensitivity <- read.csv("../plots/results_for_meta_analysis_h2_sensitivity.csv")
results_for_meta_analysis_h3_sensitivity <- read.csv("../plots/results_for_meta_analysis_h3_sensitivity.csv")

meta_results_h1_sensitivity <- 
  meta_analysis_workflow(data              = results_for_meta_analysis_h1_sensitivity,
                         effect_size_label = "Cohen's d",
                         exp_estimates     = FALSE,
                         reference_line    = 0)

meta_results_h2_sensitivity <- 
  meta_analysis_workflow(data              = results_for_meta_analysis_h2_sensitivity,
                         effect_size_label = "Cohen's d",
                         exp_estimates     = FALSE,
                         reference_line    = NULL)

meta_results_h3_sensitivity <- 
  meta_analysis_workflow(data              = results_for_meta_analysis_h3_sensitivity,
                         effect_size_label = "Odds Ratio",
                         exp_estimates     = TRUE,
                         reference_line    = 0)

