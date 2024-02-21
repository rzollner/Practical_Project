#Specification curve code:


rm(list=ls())

# load libraries
library(dplyr)
library(dbplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(ggpubr)
# load data
correlation_results <- read_csv("//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/correlation_results_withCI.csv")

## create subsets of data, calculate Rank and order:
  # for whole data set
coefficients_df <- correlation_results %>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

  # only face data
face_df <- correlation_results %>%
  filter(stimulus=="F")%>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

  # only house data
house_df <- correlation_results %>%
  filter(stimulus=="H")%>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

  # only house with easy condition data
house_easy_df <- correlation_results %>%
  filter(stimulus=="H" & difficulty=="easy")%>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

  # only house with difficult condition data
house_diff_df <- correlation_results %>%
  filter(stimulus=="H" & difficulty=="difficult")%>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

  # only face with difficult condition data
face_diff_df <- correlation_results %>%
  filter(stimulus=="F" & difficulty=="difficult")%>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

  # only face with easy condition data
face_easy_df <- correlation_results %>%
  filter(stimulus=="F" & difficulty=="easy")%>%
  arrange(desc(corr)) %>%
  mutate(Rank = row_number())

# create list of all data frames
all_data <- list(coefficients_df, face_df, house_df, house_easy_df, house_diff_df, face_diff_df, face_easy_df)

# set other parameters
desired_order <- c("RIDE", "ML", "PP", "TM", "CSD", "REST", "average", "linkedMastoids", "elec_group_1_", "elec_group_2_", "elec_group_3_", "elec_group_4_")
title_list <- c("All", "Face", "House", "House_easy", "House_difficult", "Face_difficult", "Face_easy")
###############################################################################################
# for loop to create specification curve for each data frame
for (ndata in 1:7){
  
  # calculate median
  median_coefficient <- median(all_data[[ndata]]$corr, na.rm = TRUE)

  # Generate specification curve plot
  spec_curve_plot <- ggplot(all_data[[ndata]], aes(x = Rank, y = corr)) +
    geom_ribbon(aes(ymin = ci_low, ymax = ci_up), alpha = 0.2) +
    geom_line()+
    geom_point(aes(color = p_value < 0.05)) +
    scale_color_manual(values = c('FALSE' = 'black', 'TRUE' = 'green')) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "blue") +
    geom_hline(yintercept = median_coefficient, linetype = "dashed", color = "red") +
    labs(
      title = paste("Specification Curve", title_list[ndata]),
      x = "Models ranked in order of correlation Estimate",
      y = "Correlation Estimate"
    ) +
    theme_minimal() +
    theme(legend.position = "none")
  print(spec_curve_plot)
  
  # Prepare data for pipeline decisions using the same Rank
  pipeline_decisions <- all_data[[ndata]] %>%
    select(Rank, STA, reference, electrode) %>%
    pivot_longer(cols = c(STA, reference, electrode), 
                 names_to = "DecisionType", values_to = "Decision") %>%
    mutate(Decision = factor(Decision, levels = desired_order))
  
  # Plot pipeline decisions
  pipeline_decision_plot <- ggplot(pipeline_decisions, aes(x = Rank, y = Decision)) +
    geom_tile(aes(fill = DecisionType), width = 1, height = 0.3) +
    scale_fill_viridis_d() +
    theme_minimal() +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.title.x = element_blank(),
      legend.position = "none"
    ) +
    labs(y = "Pipeline Decision")
  print(pipeline_decision_plot)
  
  # Combine plots vertically
  figure <- ggarrange(spec_curve_plot, pipeline_decision_plot,
                      labels = c("A", "B"),
                      ncol = 1, nrow = 2)
  figure
  
  
  # Save the combined plot
  ggsave(paste0("spec_curve_", title_list[ndata], ".png"), figure, width = 12, height = 8)
  remove(figure, pipeline_decision_plot, pipeline_decisions, spec_curve_plot, median_coefficient)
}





