#1/2/25
#Script to vizualize RMS amp over the summer 

#-----Load Libraries 

library(tidyverse)

#-----Load Data 

my_data_WP <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_WP_Master_GainAdj.csv")

my_data_BB <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_BB_2025_BothSides_GainAdj.csv")

my_data_TO <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_TO_BothSides_GainAdj.csv")

#-----Build the Plot 

ggplot(my_data, aes(x = Julian, y = total_adj_rmse)) + 
  geom_point() + 
  geom_smooth(method = "gam") +
  theme_classic() +
  labs(x = "Julian Date", y = "RMS Amplitude (V)")

my_data_WP$Site <- "Willard Pond"
my_data_BB$Site <- "Bonnie Brown"
my_data_TO$Site <- "Tollman"
fullData <- as.data.frame(rbind(rbind(my_data_WP, my_data_BB), my_data_TO))
write.csv(fullData, file = "/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_AllSites_2025.csv")

# Example of all sites  on one
ggplot(fullData, aes(x = Julian, y = total_adj_rmse, color = Site)) + 
  geom_point() + 
  geom_smooth(method = "gam") +
  theme_classic() +
  labs(x = "Julian Date", y = "RMS Amplitude (V)")

#faceted plot 
fullData$Site <- factor(fullData$Site, levels = c("Willard Pond", "Tollman", "Bonnie Brown"))
ggplot(fullData, aes(x = Julian, y = total_adj_rmse, color = Site)) + 
  theme_bw(base_size = 28.5) +
  geom_point(size = 2.5, color = "black", shape = 21) + 
  geom_smooth(method = "gam") +
  facet_grid(~Site) +
  labs(x = "Julian Date", 
       y = "RMS Amplitude (V)",
       color = "") +
  theme(strip.text = element_text(face = "bold"),
        axis.title = element_text(face = "bold"),
        strip.background = element_rect("white"),
        legend.position = "none",
        panel.grid.minor = element_blank(), 
        panel.grid.major = element_blank())
ggsave("/Volumes/NHBat/PAB_NHBat/Analysis/Plots_2025/Combined_Plot.png", width = 14, height = 8)


  