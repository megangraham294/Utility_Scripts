#-----Script to adjust gain from ML to M 
#-----Megan Graham 102425

#-----Load Libraries 
library(tidyverse)

#-----Point to folders with subfolders
parent_dir <- "/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_WP_052825_AM77_M_LGE_SnakeBat/RMS_Power/PAB_WP_052825_AM77_M_LGE.RMS_Power"


#Get full file paths
all_subfolders <- list.dirs(parent_dir, recursive = TRUE)


#create output folder
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/GainCorrected"
dir.create(output_folder, showWarnings = FALSE)

#-----loop through directories. 
#go into main folder and open the first subfolder 
#within that folder, open the first csv
#then find the AdjustedValues column and add 6.3 to all non-zero values (if/else =/= 0)
#go into the next csv and repeat in all csvs in folder 
#when all csvs in that folder are complete, output a daily summary file with the new values in AdjustedValues summed across all csvs

