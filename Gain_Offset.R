#-----Script to adjust gain from ML to M 
#-----Megan Graham 112025



# Set the folder where your CSVs are
input_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_TO_2025_SnakeBat/PAB_TO_2025_Side1_use/Total_RMSE/PAB_TO_052725_AM71_ML_LGE_side1.RMS_Power"
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/GainAdjusted/PAB_TO_2025/"


# Create output folder if it doesn't exist
dir.create(output_folder, showWarnings = FALSE)

# List all CSV files in that folder
listoffiles <- list.files(input_folder,full.names = TRUE)


# Loop through each CSV file
for (file in listoffiles) {
  mydata <- read.csv(file)
   #if the value is 0, keep it zero, otherwise add 6.3
  mydata$AdjustedValue <- ifelse(mydata$AdjustedValue == 0,
                                 0,
                                 mydata$AdjustedValue + 6.3)
  
  mydata$rmsEnergy <- ifelse(mydata$rmsEnergy == 0,
                             0,
                             mydata$rmsEnergy + 6.3)
  
  #sum values
  mydata$total_raw_rmse <- sum(mydata$rmsEnergy)
  mydata$total_adj_rmse <- sum(mydata$AdjustedValue)


  outfile <- paste0(output_folder, paste0("_test",(basename(file))))
  
  write.csv(mydata, file = outfile, row.names = FALSE)
}



