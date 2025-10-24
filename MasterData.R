#-----Load libraries
library(dplyr)
library(lubridate)

#Define paths
folder1 <- "/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_TO_2025_SnakeBat/PAB_TO_2025_Side2_use/Total_RMSE/PAB_TO_052725_AM76_M_LGE_Side2.RMS_Power"
folder2 <- "/Volumes/NHBat/PAB_NHBat/Analysis/SnakeBatOutputs/PAB_TO_2025_SnakeBat/PAB_TO_2025_Side2_use/Total_RMSE/PAB_TO_081925_AM76_M_side2.RMS_Power"

#Get full file paths
listoffiles1 <- list.files(folder1, full.names = TRUE)
listoffiles2 <- list.files(folder2, full.names = TRUE)

#Combine
allfiles <- c(listoffiles1, listoffiles2)

#create output folder
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/cleaned"
dir.create(output_folder, showWarnings = FALSE)

#loop through files
for (filename in allfiles) {
  mydata <- read.csv(filename, stringsAsFactors = FALSE)
  fileName <- basename(filename)
  #print(fileName)
    mydata_clean <- mydata %>%
      select(date, total_raw_rmse, total_adj_rmse) %>%
      mutate(
        date = as.Date(as.character(date), format = "%Y%m%d"),
        julian = yday(date)
      )
    # Create output filename with "clean" at end
    outfile <- paste0(output_folder, paste0("clean_", basename(filename)))
    
    write.csv(mydata_clean, file = outfile, row.names = FALSE)
  }

#-----concatenate all daily total outputs
clean_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/cleaned/PAB_TO_2025_Side1_cleaned"
clean_files <- list.files(clean_folder, full.names = TRUE)

clean_output <- "/Volumes/NHBat/PAB_NHBat/Analysis/DailyTotals"
dir.create(clean_output, showWarnings = FALSE)

#for loop 

for (cleanfilename in clean_files){
  mydailytotals <- read.csv(cleanfilename, stringsAsFactors = FALSE)
  fileNameClean <- basename(cleanfilename)
  mydailytotals_clean <- mydailytotals %>% 
    head(mydailytotals [1,])
}
