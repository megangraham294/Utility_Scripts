
# Utility Scripts
Helpful scripts for the processing of root-mean-squared acoustic energy values from bat call WAV files.

![R version](https://img.shields.io/badge/R-4.5.1-6d6d6d?style=for-the-badge&logo=r&logoColor=blue) ![Python 3.11](https://img.shields.io/badge/python-3.11-blue.svg?style=for-the-badge&logo=python&logoColor=blue)

**Author:** [Mike Martinez](https://github.com/mikemartinez99?tab=repositories)

## Accessing R functions
To access these functions, clone the git repository from your terminal within a directory of your choosing. 

```shell
git clone https://github.com/megangraham294/Utility_Scripts/
```

Once cloned, you should see a folder called `Utility_Scripts`. You can now use `source()` at the top of your R script and provide the path to the `BatFunctions.R` file within the `Utility_Scripts` directory. 

## Table of Contents
-  [rmsPower](#rmspower)
-  [Batch timestamp Editing](#batch-timestamp-editing)

### rmsPower
The `rmsPower()` function processes a directory of WAV audio files, splits each recording into fixed-length time segments, and computes the Root Mean Square (RMS) energy for each segment. This is commonly used in bioacoustics (e.g., bat echolocation analysis) to quantify signal power over time. This function currently does not support multi-threading. The following libraries are required to run this function:

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

## Batch Timestamp Editing
If .WAV files have incorrect date/time-stamp information, you can edit the filenames to reflect different time-zones with `edit_dates.py`

This script takes the following arguments/flags. You can either use the --path/--hours flags or the -p/-h flags, however both arguments need to be present.

|Argument|Value|
|--------|-----|
|`--path` (-p)|String. Path to data directory.|
|`--hours` (-h)|Numeric. Number of hours to edit by (-# subtracts and +# adds)|

**Future functionality**
- Output file that maps original file names to new timestamp names



**Example Usage**

```python
#----- Subtract 5 hours from each file's timestamp in file name
python3 edit_timestamp.py \
         --path /Volumes/BatDrive/SomeFolder/ \
         --hours -5

#----- Add 5 hours from each file's timestamp in file name
python3 edit_timestamp.py \
         --path /Volumes/BatDrive/SomeFolder/ \
         --hours +5
```



