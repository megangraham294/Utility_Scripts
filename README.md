# Utility Scripts
Helpful scripts for the processing of root-mean-squared acoustic energy values from bat call WAV files.

## Accessing these functions
To access these functions, clone the git repository from your terminal within a directory of your choosing. 

```shell
git clone https://github.com/megangraham294/Utility_Scripts/
```

Once cloned, you should see a folder called `Utility_Scripts`. You can now use `source()` at the top of your R script and provide the path to the `BatFunctions.R` file within the `Utility_Scripts` directory. 

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




