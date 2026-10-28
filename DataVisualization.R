#1/2/25
#Script to vizualize RMS amp over the summer 

#-----Load Libraries 

library(tidyverse)
library(ggrepel)

#-----Load Data 

my_data_WP <- read.csv("/Volumes/NHBAT3/PAB_WP_2026/results/WP_2026_all_samples_nightly_totals.csv")

my_data_BB <- read.csv("/Volumes/NHBAT3/PAB_BB_2026/Results/PAB_BB_2026_results/nightly_totals_back.csv")

manual_counts_BB_2026 <- read.csv("/Volumes/NHBAT3/PAB_BB_2026/Results/PAB_BB_2026_results/manual_counts_BB_2026.csv")

my_data_TO <- read.csv("/Volumes/NHBAT3/PAB_TO_2026/Analysis/PAB_TO_2026_all_samples_totals_BothSide.csv")

thermal_counts_TO <- read.csv("/Volumes/NHBAT3/PAB_TO_2026/Analysis/Counts/PAB_TO_2026_ThermCount.csv")

manual_counts_TO <- read.csv("/Volumes/NHBAT3/PAB_TO_2026/Analysis/Counts/PAB_TO_2026_ManualCount_BothSides.csv")

manual_counts_WP_2025 <- read.csv("/Users/megangraham/Desktop/PAB_WP_2025_ManCounts.csv")

fullData <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals/2025_DailyTotals/PAB_AllSites_2025.csv")

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

# Sinlge graphic
ggplot(my_data_WP, aes(x = Julian, y = total_adj_rmse, color = "red")) + 
  theme_bw(base_size = 28.5) +
  geom_point(size = 2.5, color = "black", shape = 21) + 
  geom_smooth(method = "gam", color = "blue") +
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
        plot.background = element_rect(color = "white"))
        #plot.background = element_rect(fill = "transparent", color = NA))
#ggsave("/Volumes/NHBat/PAB_NHBat/Analysis/Plots_2025/TO_Graphic.png", width = 12, height = 8)
ggsave("/Users/megangraham/Desktop/WP2026_Graphic.png", width = 12, height = 8)


# Simple graphic, good for posters
ggplot(my_data_BB, aes(x = Julian, y = total_adj_rmse)) + 
  geom_point(size = 2.5) + 
  geom_smooth(method = "gam", linewidth = 2) +
  theme_classic(base_size = 28.5) +
  labs(x = "Julian Date", y = "RMS Amplitude (V)")
ggsave("/Users/megangraham/Desktop/BB2026_PosterGraphic.png", width = 12, height = 8)

#Single graphic with counts

#----- Plotting function
myPlot <- function(rmsData, manualData, scale_factor) {
  x <- ggplot() +
    geom_point(data = rmsData, aes(x = Julian, y = total_adj_rmse), size = 2.5, 
               color ="black", shape = 21) +
    geom_smooth(data = rmsData, aes(x = Julian, y = total_adj_rmse), method = "gam") +
    
    # Thermal counts
    geom_point(data = manualData, 
               aes(x = Julian, y = ManualCount * scale_factor),
               size = 2.5,
               color = "red",
               shape = 21) +
    facet_grid(~Site) +
    
    # Thermal count labels
    geom_text_repel(
      data = manualData,
      aes(x = Julian, y = ManualCount * scale_factor, label = ManualCount),
      color = "red",
      size = 5,
      fontface = "bold") +
    scale_y_continuous(name = "RMS Amplitude (V)", sec.axis = sec_axis(~ . / scale_factor,
                                                                       name = "Manual Counts")) +
    labs(x = "Julian Date") +
    theme_classic()
  
  return(x)
  
}

myPlot(my_data_BB, manual_counts_BB_2026, 300)


scale_factor <- 300
ggplot() +
  geom_point(data = my_data_BB, aes(x = Julian, y = total_adj_rmse), size = 2.5, 
             color ="black", shape = 21) +
  geom_smooth(data = my_data_BB, aes(x = Julian, y = total_adj_rmse), method = "gam") +
  
  # Thermal counts
  geom_point(data = manual_counts_BB_2026, 
             aes(x = Julian, y = ManualCount * scale_factor),
    size = 2.5,
    color = "red",
    shape = 21) +
  facet_grid(~Site) +
  
  # Thermal count labels
  geom_text_repel(
    data = manual_counts_BB_2026,
    aes(x = Julian, y = ManualCount * scale_factor, label = ManualCount),
    color = "red",
    size = 5,
    fontface = "bold") +
  scale_y_continuous(name = "RMS Amplitude (V)", sec.axis = sec_axis(~ . / scale_factor,
      name = "Manual Counts")) +
  labs(x = "Julian Date") +
  theme_classic()
 


#plot.background = element_rect(fill = "transparent", color = NA))
#ggsave("/Volumes/NHBat/PAB_NHBat/Analysis/Plots_2025/TO_Graphic.png", width = 12, height = 8)
ggsave("/Users/megangraham/Desktop/BB2026_ManCountsGraphic.png", width = 12, height = 8)                 

#faceted counts graph

fullData$Site <- factor(
  fullData$Site,
  levels = c(
    "Willard Pond Barn",
    "Tolman Barn",
    "Brown Barn"
  )
)

# Set the scaling factor between counts and RMS
scale_factor <- 100

ggplot(fullData, aes(x = Julian)) + 
  
  # RMS data
  geom_point(
    aes(y = total_adj_rmse),
    size = 2.5,
    color = "black",
    shape = 21
  ) + 
  
  geom_smooth(
    aes(y = total_adj_rmse),
    method = "gam"
  ) +
  
  # Count data
  geom_point(
    aes(y = Count * scale_factor),
    size = 2.5,
    color = "red",
    shape = 21
  ) +
  
  #facet_grid(~Site, scales = "free_y") +
  
  geom_text_repel(
    data = fullData,
    aes(
      x = Julian,
      y = Count * scale_factor,
      label = Count
    ),
    color = "red",
    size = 5,
    fontface = "bold"
  ) +
  
  # Primary y-axis = RMS
  # Secondary y-axis = Count
  scale_y_continuous(
    name = "RMS Amplitude (V)",
    sec.axis = sec_axis(
      ~ . / scale_factor,
      name = "Bat Count"
    )
  ) +
  facet_grid(~Site, scales = "free_y") +
  labs(
    x = "Julian Date"
  ) +
  
  theme_bw(base_size = 28.5) +
  
  theme(
    strip.text = element_text(face = "bold"),
    axis.title = element_text(face = "bold"),
    strip.background = element_rect("white"),
    legend.position = "none",
    panel.grid.minor = element_blank(), 
    panel.grid.major = element_blank(),
    panel.background = element_rect(
      fill = "transparent",
      color = NA
    ),
    plot.background = element_rect(
      fill = "transparent",
      color = NA
    )
  )

ggsave("/Users/megangraham/Desktop/Combined_Plot2025_Counts.png",
  width = 14,
  height = 8)

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
ggsave("/Users/megangraham/Desktop/WP_Graphic.png", width = 5, height = 6)

##Same as above, without coloring 

xmin_all <- min(my_data_TO$Julian, na.rm = TRUE)
xmax_all <- max(my_data_TO$Julian, na.rm = TRUE)
ymin_all <- min(my_data_TO$total_adj_rmse, na.rm = TRUE)
ymax_all <- max(my_data_TO$total_adj_rmse, na.rm = TRUE)

ggplot(my_data_TO, aes(x = Julian, y = total_adj_rmse, color = "red")) +
  #geom_rect(aes(xmin = -Inf, xmax = 183, ymin = -Inf, ymax = Inf) +
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
  
ggsave("/Users/megangraham/Desktop/TO_Graphic.png", width = 9, height = 10)
