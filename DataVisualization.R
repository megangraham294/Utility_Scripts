#1/2/25
#Script to vizualize RMS amp over the summer 

#-----Load Libraries 

library(tidyverse)

#-----Load Data 

my_data_WP <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_WP_Master_GainAdj.csv")

my_data_BB <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_BB_2025_BothSides_GainAdj.csv")

my_data_TO <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_TO_BothSides_GainAdj.csv")

#-----Build the Plot 

#ggplot(my_data, aes(x = Julian, y = total_adj_rmse)) + 
#  geom_point() + 
 # geom_smooth(method = "gam") +
  #theme_classic() +
  #labs(x = "Julian Date", y = "RMS Amplitude (V)")

my_data_WP$Site <- "Willard Pond Barn"
my_data_BB$Site <- "Brown Barn"
my_data_TO$Site <- "Tolman Barn"
fullData <- as.data.frame(rbind(rbind(my_data_WP, my_data_BB), my_data_TO))
write.csv(fullData, file = "/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/PAB_AllSites_2025.csv")

# Example of all sites  on one
ggplot(fullData, aes(x = Julian, y = total_adj_rmse, color = Site)) + 
  geom_point() + 
  geom_smooth(method = "gam") +
  theme_classic() +
  labs(x = "Julian Date", y = "RMS Amplitude (V)")

#faceted plot 
fullData$Site <- factor(fullData$Site, levels = c("Willard Pond Barn", "Tolman Barn", "Brown Barn"))
ggplot(fullData, aes(x = Julian, y = total_adj_rmse, color = "red")) + 
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
        panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA))
#ggsave("/Volumes/NHBat/PAB_NHBat/Analysis/Plots_2025/Combined_Plot_NoColor.png", width = 14, height = 8)
ggsave("/Users/megangraham/Desktop/Combined_Plot.png", width = 14, height = 8)

# Willard graphic
ggplot(my_data_BB, aes(x = Julian, y = total_adj_rmse, color = "red")) + 
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
        panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "transparent", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA))
#ggsave("/Volumes/NHBat/PAB_NHBat/Analysis/Plots_2025/BB_Graphic.png", width = 12, height = 8)
ggsave("/Users/megangraham/Desktop/BB_Graphic.png", width = 8, height = 8)



# Pre-calculate limits once (cleaner + safer)
# Pre-calculate limits
xmin_all <- min(my_data_WP$Julian, na.rm = TRUE)
xmax_all <- max(my_data_WP$Julian, na.rm = TRUE)
ymin_all <- min(my_data_WP$total_adj_rmse, na.rm = TRUE)
ymax_all <- max(my_data_WP$total_adj_rmse, na.rm = TRUE)

ggplot(my_data_WP, aes(x = Julian, y = total_adj_rmse, color = "red")) +
  geom_rect(aes(xmin = -Inf, xmax = 183, ymin = -Inf, ymax = Inf),
            fill = "#A8D8A8", inherit.aes = FALSE) +
  
  # 180–185 (existing blue)
  geom_rect(aes(xmin = 183, xmax = 195, ymin = -Inf, ymax = Inf),
            fill = "#9ECBE6", inherit.aes = FALSE) +
  
  # >202 (red)
  geom_rect(aes(xmin = 195, xmax = Inf, ymin = -Inf, ymax = Inf),
            fill = "#E6A3A3", inherit.aes = FALSE) +
  geom_point(size = 2.5, color = "black", shape = 21) + 
  geom_smooth(method = "gam") +
  facet_grid(~Site) +
  scale_y_continuous(expand = expansion(mult = c(0.08, 0.02))) +
  coord_cartesian(expand = FALSE, ylim = c(0,30000)) +
  theme_bw(base_size = 20) +
  labs(
    x = "Julian Date",
    y = "RMS Amplitude (V)") +
  theme(
    strip.text = element_text(face = "bold"),
    axis.title = element_text(face = "bold"),
    strip.background = element_rect(fill = "white"),
    legend.position = "none",
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA))
ggsave("/Users/megangraham/Desktop/WP_Graphic.png", width = 10, height = 6)


