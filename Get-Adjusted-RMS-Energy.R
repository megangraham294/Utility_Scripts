#------------------------------------------------------------------------------#
#
# Adjusted Willard Outputs
# July 29th, 2025
#
# Modifying column names so they say "rmsEnergy" and then calculate min value
# of each set of data and add abs(min value) to the rest of the data.
#
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# LOAD LIBRARIES AND SET PATHS
#------------------------------------------------------------------------------#

library(dplyr)

#----- Set path to working directory
setwd("~/Desktop/WilliardPond/WilliardPond_Outputs_2025/")

#------------------------------------------------------------------------------#
# LIST OUTPUT FOLDERS NESTED IN THE WORKING DIRECTORY
#------------------------------------------------------------------------------#

#----- List the folders within your working directory (ignoring the first entry which is your wd)
outputDirs <- list.dirs("./")[-1]

#----- Split based on formatting
noFormatting <- outputDirs[1:2]
formatting <- outputDirs[3:4]

#------------------------------------------------------------------------------#
# LOOP THROUGH THE DIRECTORIES THAT NEED FORMATTING TO MATCH THE OTHERS
#------------------------------------------------------------------------------#

#== Pseudocode:
# 1. Go into the directory
# 2. List the files in the folder
# 3. Read in the files iteratively
# 4. Apply formatting
# 5. Re-save the csv


#----- Iterate over the 2 folders that need formatting
for (i in noFormatting) {
  #== Debug
  message(i)
  
  #== List the files in the directory
  files <- list.files(i, full.names = TRUE)
  #print(files)
  
  #----- Within each folder, iterate over the files contained in that folder
  for (j in files) {
    
    #== Read in the file
    curFile <- read.csv(j)
  
    
    #== Change the colnames
    colnames(curFile) <- c("X", "rmsEnergy")
    
    #== Re-save the csv
    write.csv(curFile, j)
    
  }
}


#------------------------------------------------------------------------------#
# DO THE CALCULATION
#------------------------------------------------------------------------------#

####### we ran with just one folder to test, looked like outputDirs[1]. 
# exampleFolder <- outputDirs[1]

####### for each iteration in exampleFolder, give the file path of the first value, in this case it is the first folder in the directory. 

for (i in exampleFolder) {
  
  message(i)
  
  ####### list the file names with the path in the directory 
  files <- list.files(i, full.names = TRUE)
  print(files)
  
  for (j in files) {
    
    curFile <- read.csv(j, row.names = 1) 
    curFile <- na.omit(curFile)
    #----- Sanity checks
    #columns <- colnames(curFile)
    #print(columns)
    
    #----- Remove column X (redundant with row names of dataframe) + sanity check
    curFile$X <- NULL
    #columns <- colnames(curFile)
    #print(columns)
    
    #------ find the min value in RMSenergy column 
    
    minValue <- min(curFile$rmsEnergy)
    
    #print(minValue)
    
    #----- turn the min value into absolute value
    
    absValue <- abs(minValue) 
    
    #print(absValue)
    
    #----- assign a new column called AdjustedValue and add the absolute value to the rmsEnergy column
    curFile$AdjustedValue <- absValue+curFile$rmsEnergy
    
    #print(colnames(curFile))
    #print(head(curFile$AdjustedValue))
    
    write.csv(curFile, file = j)

  }
  
  
}

#------------------------------------------------------------------------------#
# APPLY LOOP TO THE REST OF THE DATA, EXCLUDING THE FOLDER WE TESTED ON
#------------------------------------------------------------------------------#

#----- Since different output folders have slightly different formatting, we 
# needed to add some conditional statements to ensure the loop would work on all 
# folder. See below.

data <- outputDirs[2:4]
for (i in data) {
  
  message(i)
  
  ####### list the file names with the path in the directory 
  files <- list.files(i, full.names = TRUE)
  print(files)
  
  for (j in files) {
    
    curFile <- read.csv(j) 
    curFile <- na.omit(curFile)
    #----- Sanity checks
    #columns <- colnames(curFile)
    #print(columns)
    
    #----- If there is a column "X", remove it, or else continue
    if ("X" %in% colnames(curFile)) {
      curFile$X <- NULL
    }
    
    #----- If there is a column "X.1", set these as rownames and then remove, or else continue
    if ("X.1" %in% colnames(curFile)) {
      rownames(curFile) <- curFile$X.1
      curFile$X.1 <- NULL
    } 
    
    #----- If the rms data is stored in rmsenergy (lowercase e), change the column name to rmsEnergy, or else continue
    if ("rmsenergy" %in% colnames(curFile)) {
      colnames(curFile) <- c("rmsEnergy")
    } else {
      message("Column name is already rmsEnergy with a capital E. ")
    }
    
    #columns <- colnames(curFile)
    #print(columns)
    
    #------ find the min value in RMSenergy column 
    
    minValue <- min(curFile$rmsEnergy)
    
    #print(minValue)
    
    #----- turn the min value into absolute value
    
    absValue <- abs(minValue) 
    
    #print(absValue)
    
    #----- assign a new column called AdjustedValue and add the absolute value to the rmsEnergy column
    curFile$AdjustedValue <- absValue+curFile$rmsEnergy
    
    #print(colnames(curFile))
    #print(head(curFile$AdjustedValue))
    
    write.csv(curFile, file = j)
    
  }
  
  
}




