## Practical Project Analysis

#load packages
library(readr)

# Load data
setwd("//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project")

Latency_Estimation_RIDE <- read_csv("//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/Tables_and_Plots/Tables_and_Plots/Results_RIDE_Latency.csv")
Latency_Estimation_ML <- read_csv("//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/Tables_and_Plots/Tables_and_Plots/Results_Maximum_Likelihood_Latency.csv")
Latency_Estimation_PP <- read_csv("//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/Tables_and_Plots/Tables_and_Plots/Results_Filtering_and_Peak_Picking.csv")
Latency_Estimation_TM <- read_csv("//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/Tables_and_Plots/Tables_and_Plots/Results_Template_Matching_Latency.csv")


library(corrplot)

reference = c('CSD', 'REST', 'average', 'linkedMastoids')
elec_group = c('elec_group_1_', 'elec_group_2_', 'elec_group_3_', 'elec_group_4_')
stimuli = c('F', 'H')
difficultness = c('easy', 'difficult')

# creating correlation table for RIDE
i = 0;
corr= c()
ci_low = c()
ci_up = c()
p_value = c()
for (ref in 1:4){
  for (elec in 1:4){
    for (stim in 1:2){
      for (diff in 1:2){
        i=i+1
        final_RIDE = Latency_Estimation_RIDE[Latency_Estimation_RIDE$reference == reference[ref] & Latency_Estimation_RIDE$electrode_groups == elec_group[elec] & Latency_Estimation_RIDE$stimulus== stimuli[stim] & Latency_Estimation_RIDE$difficulty== difficultness[diff],]
        results <- cor.test(final_RIDE$latency, final_RIDE$reaction_time)
        remove(final_RIDE)
        corr[i]=results$estimate
        ci_low[i] = results$conf.int[1]
        ci_up[i] = results$conf.int[2]
        p_value[i] = results$p.value
      }
    }
  }
}
final = data.frame(STA = rep('RIDE'), reference = rep(c('CSD', 'REST', 'average', 'linkedMastoids'), each=16),electrode = rep(c('elec_group_1_', 'elec_group_2_', 'elec_group_3_', 'elec_group_4_'), each = 4), stimulus = rep(c('F', 'H'), each = 2), difficulty = rep(c('easy', 'difficult')), corr, ci_low, ci_up, p_value)
remove(results)
# creating correlation table for ML
i = 0;
corr= c()
ci_low = c()
ci_up = c()
p_value = c()
for (ref in 1:4){
  for (elec in 1:4){
    for (stim in 1:2){
      for (diff in 1:2){
        i=i+1
        final_ML = Latency_Estimation_ML[Latency_Estimation_ML$reference == reference[ref] & Latency_Estimation_ML$electrode_groups == elec_group[elec] & Latency_Estimation_ML$stimulus== stimuli[stim] & Latency_Estimation_ML$difficulty== difficultness[diff],]
        results <- cor.test(final_ML$latency, final_ML$reaction_time)
        remove(final_ML)
        corr[i]=results$estimate
        ci_low[i] = results$conf.int[1]
        ci_up[i] = results$conf.int[2]
        p_value[i] = results$p.value
      }
    }
  }
}
final_2 = data.frame(STA = rep('ML'), reference = rep(c('CSD', 'REST', 'average', 'linkedMastoids'), each=16),electrode = rep(c('elec_group_1_', 'elec_group_2_', 'elec_group_3_', 'elec_group_4_'), each = 4), stimulus = rep(c('F', 'H'), each = 2), difficulty = rep(c('easy', 'difficult')),  corr, ci_low, ci_up, p_value)
remove(results)
# creating correlation table for PP
i = 0;
corr= c()
ci_low = c()
ci_up = c()
p_value = c()
for (ref in 1:4){
  for (elec in 1:4){
    for (stim in 1:2){
      for (diff in 1:2){
        i=i+1
        final_PP = Latency_Estimation_PP[Latency_Estimation_PP$reference == reference[ref] & Latency_Estimation_PP$electrode_groups == elec_group[elec] & Latency_Estimation_PP$stimulus== stimuli[stim] & Latency_Estimation_PP$difficulty== difficultness[diff],]
        results <- cor.test(final_PP$latency, final_PP$reaction_time)
        remove(final_PP)
        corr[i]=results$estimate
        ci_low[i] = results$conf.int[1]
        ci_up[i] = results$conf.int[2]
        p_value[i] = results$p.value
      }
    }
  }
}
final_3 = data.frame(STA = rep('PP'), reference = rep(c('CSD', 'REST', 'average', 'linkedMastoids'), each=16),electrode = rep(c('elec_group_1_', 'elec_group_2_', 'elec_group_3_', 'elec_group_4_'), each = 4), stimulus = rep(c('F', 'H'), each = 2), difficulty = rep(c('easy', 'difficult')), corr, ci_low, ci_up, p_value)
remove(results)
# creating correlation table for TM
i = 0;
corr= c()
ci_low = c()
ci_up = c()
p_value = c()
for (ref in 1:4){
  for (elec in 1:4){
    for (stim in 1:2){
      for (diff in 1:2){
        i=i+1
        final_TM = Latency_Estimation_TM[Latency_Estimation_TM$reference == reference[ref] & Latency_Estimation_TM$electrode_groups == elec_group[elec] & Latency_Estimation_TM$stimulus== stimuli[stim] & Latency_Estimation_TM$difficulty== difficultness[diff],]
        results <- cor.test(final_TM$latency, final_TM$reaction_time)
        remove(final_TM)
        corr[i]=results$estimate
        ci_low[i] = results$conf.int[1]
        ci_up[i] = results$conf.int[2]
        p_value[i] = results$p.value
      }
    }
  }
}
final_4 = data.frame(STA = rep('TM'), reference = rep(c('CSD', 'REST', 'average', 'linkedMastoids'), each=16),electrode = rep(c('elec_group_1_', 'elec_group_2_', 'elec_group_3_', 'elec_group_4_'), each = 4), stimulus = rep(c('F', 'H'), each = 2), difficulty = rep(c('easy', 'difficult')),  corr, ci_low, ci_up, p_value)
remove(results)
# concatenate into 1 df
final_final = rbind(final, final_2, final_3, final_4)
write.csv(final_final, file = "//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/correlation_results_withCI.csv", row.names = F)
install.packages('xlsx')     
library(xlsx)  
write.xlsx(final_final, file = "//daten.w2kroot.uni-oldenburg.de/home/kafu3624/Desktop/Practical_Project/correlation_results_withCI.xlsx", row.names = F)
