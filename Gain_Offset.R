#-----Script to adjust gain from ML to M 
#-----Megan Graham 102425

#-----Load Libraries 
library(tidyverse)

#-----Point to folders with subfolders
#parent_dir <- "/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_WP_082125_AM77_ML_SnakeBat/RMS_Power/PAB_WP_082125_AM77_ML.RMS_Power"


#Get full file paths
#all_subfolders <- list.dirs(parent_dir, recursive = TRUE)


#create output folder
#output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/GainCorrected"
#dir.create(output_folder, showWarnings = FALSE)

#-----loop through directories. 
#go into main folder and open the first subfolder 
#within that folder, open the first csv
#then find the AdjustedValues column and add 6.3 to all non-zero values (if/else =/= 0)
#go into the next csv and repeat in all csvs in folder 
#when all csvs in that folder are complete, output a daily summary file with the new values in AdjustedValues summed across all csvs

#for dir in all folders within the directory
#for (dir in all_subfolders) {
  #list the files in the first folder 
 # files <- list.files(dir) %>% 
    #read in the csvs
 #   my_data <- read.csv(files) %>% 
      #find and select the total adj rmse column
#      select(total_adj_rmse) %>% 
      #if the values in that column are more than zero
#      if (total_adj_rmse > 0) {
        #then create a new column that contains the adjusted value +6.3
#        mutate(gainAdj = )
 #     }
#}


#-----Lets try again 
#11/13/25

# Set the folder where your CSVs are
input_folder <- ("/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_BB_2025_SnakeBat/Total_RMSE/PAB_BB_2025_Total_RMSE_East/PAB_BB_052925_AM68_ML_LGE_East.RMS_Power")
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/GainAdjusted"


# Create output folder if it doesn't exist
dir.create(output_folder, showWarnings = FALSE)

# List all CSV files in that folder
listoffiles <- list.files(input_folder,full.names = TRUE)


# Loop through each CSV file
for (file in listoffiles) {
  mydata <- read.csv(file)
  mydata$AdjustedValue <- as.numeric(mydata$AdjustedValue)
  # Read the file
  if ("AdjustedValue" %in% names(mydata)) {
    mydata$AdjustedValue_adj <- mydata$AdjustedValue + 6.3
  } else {
    warning(paste("No AdjustedValue Column:", file))
  }
    
  
   # new_col <- apply(mydata, 1, gainAdj)
  #  cbind(mydata, gainAdj = new_col)
  outfile <- paste0(output_folder, paste0("GainAdj", basename(file)))
  
  write.csv(mydata$AdjustedValue_adj, file = outfile, row.names = FALSE)
}



#-----Troubleshooting for loop 

#mydata <- read.csv("/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_BB_2025_SnakeBat/Total_RMSE/PAB_BB_2025_Total_RMSE_East/PAB_BB_052925_AM68_ML_LGE_East.RMS_Power/20250529_total_RMSE.csv")


#gainAdj = function(x,output) {
#  rmsEnergy = x[1]
#  x + 6.3
#  return(rmsEnergy)
#}
#new_col <- apply(mydata, 1, gainAdj)
#cbind(mydata, gainAdj = new_col)



# Take 3 
# 111925

# Set the folder where your CSVs are
input_folder <- ("/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_BB_2025_SnakeBat/Total_RMSE/PAB_BB_2025_Total_RMSE_East/PAB_BB_052925_AM68_ML_LGE_East.RMS_Power")
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/GainAdjusted"


# Create output folder if it doesn't exist
dir.create(output_folder, showWarnings = FALSE)

# List all CSV files in that folder
listoffiles <- list.files(input_folder,full.names = TRUE)


# Loop through each CSV file
for (file in listoffiles) {
  mydata <- read.csv(file)
  mydata$AdjustedValue <- mydata$AdjustedValue + 6.3
  mydata$rmsEnergy <- mydata$rmsEnergy + 6.3
  mydata$total_raw_rmse <- sum(mydata$rmsEnergy)
  mydata$total_adj_rmse <- sum(mydata$AdjustedValue)

  
  outfile <- paste0(output_folder, paste0(basename(file)))
  
  write.csv(mydata, file = outfile, row.names = FALSE)
}


