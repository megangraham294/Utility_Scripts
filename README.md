# Utility Scripts
Helpful scripts for the processing of root-mean-squared acoustic energy values from bat call WAV files.

## Table of Contents
-  [rmsPower](#rmsPower)


### rmsPower
A function to calculate root-mean-squared acoustic energy values from bat call WAV files. Simply source the function script in your R code. This function requires the following R libraries

1. data.table 
2. seewave
3. tuneR
4. tools

|Argument|Value|
|--------|-----|
|`dataDir`|String. Path to data directory. Ensure directory path ends in "/" or use `file.path`|
|`segmentDuration`|Numeric. Length of each audio segment in seconds (default = 1)|
|`fileType`|String. One of ".WAV" or ".wav"|
|`samplingRate`|Numeric. Number of samples per segment, measured in Hz|
|`bwFilterFrom`|Numeric. Lower band-pass filtering bound passed to `from` argument of `seewave::bwfilter`|
|`bwFilterTo`|Numeric. Upper band-pass filtering bound passed to `to` argument of `seewave::bwfilter`|
|`outputDir`|String. Path to where outputs should be directed. User can specify a new directory or a pre-existing directory. Ensure path ends in "/" or use `file.path`|


**Example Usage**

```r

#----- Load libraries
library(data.table)
library(seewave)
library(tuneR)
library(tools)

#----- Source code
source("~/Desktop/UtilityScripts/BatFunctions.R")

#----- Set working directory
setwd("~/Desktop/myFiles/")

#----- Run the function
rmsPower(dataDir = ".",
         segmentDuration = 1,
         fileType = ".WAV",
         samplingRate = 250000,
         bwFilterFrom = 35000, 
         bwFilterTo = 70000,
         outputDir = "/Users/megangraham/Desktop/")
```




