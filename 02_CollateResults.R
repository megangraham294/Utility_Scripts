#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ READ ME ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#
# Title: 02_CollateResults.R
# Author: Mike Martinez and Megan Graham
# Lab: Kloepper
# Date Created: Aug 3rd, 2025
#
# SubTasks:
#create single new file with: Date column, Total RMS from day, Total adjusted RMS from day
#       
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
setwd("~/Desktop/WilliardPond/WilliardPond_Outputs_2025")

#-----Create vector listing the directories. use [-1] to remove root path as a vector element
allOutputs <- list.dirs("~/Desktop/WilliardPond/WilliardPond_Outputs_2025")[-1]

#----- We need to separate by gain (ask PI about this)

#-----Create vectors containing the folders from 05/28 and 07/10
rmsenergy0528 <- allOutputs[1:2]
rmsenergy0710 <- allOutputs[3:4]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# CREATE EMPTY LISTS TO STORE THE DATA WITHIN EACH SET OF OUTPUT FOLDERS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

rms0528List <- list()
#-----Create a vector called date, containing the date of the files we are working on 
date <- c("052825")

for(i in rmsenergy0528){
  print(i)
  
  files <- list.files(i,full.names=TRUE) 
  #print(files)
  
  #-----iterate through each file in the i-th directory
  for (j in files) {
    print(j)
    #read in the j-th dataframe as x
    x <- read.csv(j, header=TRUE)
    #check dimensions of the j-th dataframe
    print(dim(x))
    
    #if the number of rows in a file equals zero, skip that file and keep going
    if (nrow(x) == 0) {
      message(paste(j, " has 0 rows."))
      next()
    }
    
    #-----create a new column called date.   
    x$date <- date
    #print(colnames(x))
    #print(unique(x$date))
    
    #-----Add dataframe to list
    rms0528List[[j]] <- x
  }
}



#combine all dataframes 0528 top to bottom. ie put all together, saved in new data-frame
full0528 <- do.call(rbind, rms0528List)

#----- Create a new column for the sum of raw RMSE
full0528$total_raw_rmse <- sum(full0528$rmsEnergy)

#----- Create a new column for the sum of the adj. RMSE
full0528$total_adj_rmse <- sum(full0528$AdjustedValue)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# FUNCTIONIZE WHAT WE JUST DID
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----- Structure of a function:
# functionName <- function(x,y, .....) # x,y,z are arguments. The same way read.csv() is a function with arguments

#----- This function takes 2 arguments:
# 1: dataDir which is a vector of directory paths, which should all have data from 1 specific date
# 2: The date as a string (i.e, encased in " ") which will populate a "date" column in each data frame
# This function add a date column, summed raw RMSE column and summed adj. RMSE column
# This function ASSUMES your data has the following names already present: rmsEnergy and AdjustedValue

calcTotalRMSE <- function(dataDirs, date) {
  #----- Create empy list to store data
  dataList <- list()
  
  #-----Create a vector called date, containing the date of the files we are working on 
  date <- c(date)
  
  #----- Iterate through the folders in the dataDirs
  for(i in dataDirs){
    print(i)
    
    #----- List each file in the directory
    files <- list.files(i, full.names=TRUE) 
    #print(files)
    
    #-----iterate through each file in the i-th directory
    for (j in files) {
      print(j)
      
      #----- Read in the j-th dataframe as x
      x <- read.csv(j, header=TRUE)
      
      #----- Optional debugging sanity checks
      #check dimensions of the j-th dataframe
      #print(dim(x))
      
      #----- Check that each dataframe has at least 1 row of data, skip empty dataframes
      if (nrow(x) == 0) {
        message(paste(j, " has 0 rows."))
        next()
      }
      
      #----- Check that column names needed for summation are present part 1
      neededCols1 <- c("rmsEnergy")
      if (!neededCols %in% colnames(x)) {
        stop("rmsEnergy missing in data")
      } 
      
      #----- Check that column names needed for summation are present part 2
      neededCols2 <- c("AjustedValue")
      if (!neededCols %in% colnames(x)) {
        stop("AjustedValue missing in data")
      } 
      
      
      
      
      
      #-----create a new column called date.   
      x$date <- date
      #print(colnames(x))
      #print(unique(x$date))
      
      #-----Add dataframe to list
      dataList[[j]] <- x
    }
  }
  
  fullResults <- do.call(rbind, dataList)
  
  fullResults$total_raw_rmse <- sum(fullResults$rmsEnergy)
  
  #----- Create a new column for the sum of the adj. RMSE
  fullResults$total_adj_rmse <- sum(fullResults$AdjustedValue)
  
  
  
  return(fullResults)
  
}



