# Open and run analysis.Rmd so that the necessary objects are present in your environment, then run this script

setwd("~/git/shared-features-paper/plots")

pdf(NULL)
dev.control(displaylist = "enable")

par(mfrow = c(1,1))

size <- 1.1

data_exp_2 %>%
    select(Participant, source_valence_condition, IAT_Score, EC_Effect_CS1_CS2_Difference_Score) %>%
    mutate(source_valence_condition = dplyr::recode(source_valence_condition,
                                                    CS1_Positive_CS2_Negative = "Morag positive & Struan negative",
                                                    CS2_Positive_CS1_Negative = "Morag negative & Struan positive")) %>%
    rename(`IAT D score` = IAT_Score,
           `Ratings difference score` = EC_Effect_CS1_CS2_Difference_Score) %>%
    gather(dv_modality, dv_score, c(`IAT D score`, `Ratings difference score`)) %>%
    ggplot(aes(dv_score)) +
    geom_density(adjust = 0.5) +
    facet_wrap(~dv_modality+source_valence_condition, scales = "free") +
    theme_classic() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          strip.background = element_blank(),
          panel.border = element_blank()) +
    xlab("") +
    ylab("Probability density")

p1 <- recordPlot()
invisible(dev.off())

# # display the saved plot
# grid::grid.newpage()
# p1

pdf("density_plots.pdf",
    width = 7, 
    height = 6)
p1
dev.off()
