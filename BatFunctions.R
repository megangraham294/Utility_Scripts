#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ READ ME ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#
# Title: Bat_Functions.R
# Author: Mike Martinez
# Lab: Kloepper
# Date Created: July 20th, 2025
#
# Changelog: 
#   Sunday July 27th, 2025: 
#     - Changed short name to just file basename to avoid malformed output path
#     - Preallocated vector in inner loop to prevent re-reading growing vector into memory with each iteration
#     - Added progress bar for aesthetics 
#     - Added tryCatch block to skip corrupted files
#     - Added check to not re-run files that were already processed
#       
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----- Load required libraries
library(data.table)
library(seewave)
library(tuneR)
library(tools)

rmsPower <- function(dataDir, 
                     segmentDuration, 
                     fileType,
                     samplingRate, 
                     bwFilterFrom, 
                     bwFilterTo,
                     outputDir) {

  #----- Check raw data dir exists
  if (!dir.exists(dataDir)) {
    stop("ERROR: Data directory does not exist!")
  } else {
    message("Locating data dir...")
  }
  
  #-----Add gain offset var
  #----- Check output directory exists, if not, create
  if (!dir.exists(outputDir)) {
    message(paste0("Creating output directory: ", outputDir))
    dir.create(outputDir)
  } else {
    message("Output directory already exists.")
  }
  
  #----- List files
  dataFiles <- list.files(dataDir,
                          pattern = fileType,
                          full.names = TRUE,
                          recursive = TRUE)
  
  #----- Print logging
  message("#------------------------------------------#")
  message(paste0("Starting rmsPower with ", length(dataDir), " files."))
  message("#------------------------------------------#")
  
  #----- Precompute total number of segments
  totalSegments <- 0
  for (file in dataFiles) {
    waveHeader <- tryCatch({
      tuneR::readWave(file, header = TRUE)
    }, error = function(e) {
      warning(paste("Skipping header read error:", file))
      return(NULL)
    })
    if (is.null(waveHeader)) next
    dur <- waveHeader$samples / waveHeader$sample.rate
    totalSegments <- totalSegments + floor(dur / segmentDuration)
  }
  
  if (totalSegments == 0) {
    message("No valid segments found across files.")
    return(invisible(NULL))
  }
  
  #----- Initialize progress bar for total segments
  pb <- txtProgressBar(min = 0, max = totalSegments, style = 3)
  progress <- 0
  
  #----- Iterate through the files
  for (f in seq_along(dataFiles)) {
    i <- dataFiles[f]
    message(paste0("Processing", i))
    
    #== Generate short name
    short_name <- tools::file_path_sans_ext(basename(i))
    
    #== Specify output file name
    out_file <- file.path(outputDir, paste0(short_name, "_RMSPower_1Second.csv"))
    if (file.exists(out_file)) {
      message(paste("File already exists. Skipping:", out_file))
      next
    }
    
    #== Check that file does not throw bin error (most likely empty)
    raw.wav <- tryCatch({
      tuneR::readWave(i)
    }, error = function(e) {
      if (grepl("non-conformable arguments", e$message)) {
        warning(paste("Skipping file due to readBin error:", i))
      } else {
        warning(paste("Skipping file due to unknown error:", i, "\nError:", e$message))
      }
      return(NULL)
    })
    
    if (is.null(raw.wav)) {
      next
    }
    
    #== Filter the WAV file
    wav <- bwfilter(raw.wav, 
                    f = samplingRate,
                    from = bwFilterFrom,
                    to = bwFilterTo,
                    bandpass = T,
                    output = "Wave") 
    
    #== Calculate number of segments
    num_segments <- floor(duration(wav) / segmentDuration) 
    message(paste0("Number of segments: ", num_segments))
    
    #== Create a vector of length number of segments
    rmsenergy <- numeric(num_segments) 
    
    #== Iterate through the segments
    for (j in 1:num_segments) {
      
      #== Calculate metrics
      start_time <- (j - 1)*segmentDuration
      end_time <- j * segmentDuration
      segment <- wav[round(start_time*samplingRate):round(end_time*samplingRate)]
      MLV <- (segment@left)/32768
      rms_energy <- rms(MLV)
      rel_rmsenergy <- 10*log((rms_energy/1), base=10) #change to 20log
      #add gain here 
      rmsenergy[j] <- rel_rmsenergy
      
      #== Update progress bar per segment
      progress <- progress + 1
      setTxtProgressBar(pb, progress)
    }
    
    #== Save results
    data.table::fwrite(data.table::data.table(rmsenergy), out_file)
    message(paste0("Output saved to ", outputDir))
  }
  
  #----- Close progress bar
  close(pb)
}



