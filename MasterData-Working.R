#-----Load libraries
library(dplyr)
library(lubridate)


#----------------------------------------#
# MOVE FILES TO ONE FOLDER
#----------------------------------------#

#----- Define paths (f1 scrambled)
folder1 <- "/Volumes/NHBat/PAB_NHBat/Analysis/Master_Analysis/01_GainAdj/PAB_BB_052925_AM68_M_GainAdj/Total_RMSE/PAB_BB_052925_AM68_ML_LGE.RMS_Power"
folder2 <- "/Volumes/NHBat/PAB_NHBat/Analysis/Master_Analysis/00_Non_GainAdj/00_PAB_BB_2025_SnakeBat/Total_RMSE/PAB_BB_2025_Total_RMSE_East/PAB_BB_082025_AM68_M_LGE_East.RMS_Power"

#----- Get full file paths
listoffiles1 <- list.files(folder1, full.names = TRUE)
listoffiles2 <- list.files(folder2, full.names = TRUE)

#----- Combine file lists into one vector
allfiles <- c(listoffiles1, listoffiles2)

#----- Create output folder
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/DailyOutputs/PAB_BB_2025_EastSide_Daily_Outputs_May_Aug/"
if (!dir.exists(output_folder)) {
  dir.create(output_folder)
}

#----- Loop through files
for (filename in allfiles) {
  mydata <- read.csv(filename, stringsAsFactors = FALSE)
  fileName <- basename(filename)
  
  #== Get Julian date using base R
  mydata_clean <- mydata[,colnames(mydata) %in% c("date", "total_raw_rmse", "total_adj_rmse")]
  mydata_clean$julian <- yday(mydata_clean$date)
  #print(fileName) # Commented out bc tidyverse was changing something and producing NA
    #mydata_clean <- mydata %>%
      #select(date, total_raw_rmse, total_adj_rmse) %>%
      #mutate(
        #date = as.Date(as.character(date), format = "%Y%m%d"),
        #julian = yday(date))
  
    #== Create output filename with "clean" at end
    outfile <- paste0(output_folder, paste0("clean_", basename(filename)))
    
    write.csv(mydata_clean, file = outfile, row.names = FALSE)
}

#----------------------------------------#
# In development
#----------------------------------------#


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
