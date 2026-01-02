#1/2/25
#Script to vizualize RMS amp over the summer 

#-----Load Libraries 

library(tidyverse)

#-----Load Data 

my_data <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_BB_2025_BothSides_GainAdj.csv")

#-----Build the Plot 

ggplot(my_data, aes(x = Julian, y = total_adj_rmse)) + 
  geom_point() + 
  geom_smooth(method = "gam") +
  theme_classic() +
  labs(x = "Julian Date", y = "RMS Amplitude (V)")
  