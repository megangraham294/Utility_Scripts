# Sum Energy extraction for PAB – last updated 10/1/25 by RJ Trent

# Load required packages
library(seewave)
library(tuneR)

# Set working directory to folder containing raw .WAV files
folder <- "/Volumes/NHBat/PAB_NHBat/PAB_TO_2025/PAB_TO_052725/AMs/PAB_TO_052725_AM71_ML_LGE"
output_folder <- "/Volumes/NHBat/PAB_NHBat/Analysis/GainAdjusted/PAB_TO_2025/test"
# Get list of all .WAV files (including in subfolders)
# Make sure that capitalization scheme of .wav extension matches pattern defined below
file_names <- list.files(path = folder, pattern = "*.WAV", full.names = TRUE, recursive = TRUE)

# Clear environment and run garbage collection
rm()
gc()

# Define analysis parameters
segment_duration <- 1        # in seconds
sampling_rate <- 192000      # in Hz

# Define amplitude range based on audio format
max_bit <- 1
min_bit <- -1
# Uncomment below if using 16-bit format instead of floating point
# max_bit <- 32767
# min_bit <- -32768

# Process each file
for (file_name in file_names) {
  
  # Read audio file
  raw.wav <- readWave(file_name)
  
  # Remove file extension for naming outputs
  short_name <- tools::file_path_sans_ext(file_name)
  
  # Apply band-pass filter around frequency range of interest
  wav <- bwfilter(raw.wav, f = sampling_rate,
                  from = 38000, # lower limit of bandpass filter
                  to = 76000, # upper limit of bandpass filter
                  bandpass = TRUE,
                  output = "Wave")
  
  # Optionally save filtered audio file
  # writeWave(wav, filename = paste0(short_name, "_filtered.wav"))
  
  # Determine number of segments based on duration and segment length
  num_segments <- floor(duration(wav) / segment_duration)
  #rmsenergy <- c()
  sumenergy <- c()
  
  # Calculate RMS power for each segment
  for (i in 1:num_segments) {
    start_time <- (i - 1) * segment_duration
    end_time <- i * segment_duration
    segment <- wav[round(start_time * sampling_rate):round(end_time * sampling_rate)]
    
    # Normalize segment to -1 to 1 range
    MLV <- segment@left / 32768
    
    # Compute RMS energy and convert to decibels relative to max (1)
    #rms_energy <- rms(MLV)
    #rel_rmsenergy <- 20 * log10(rms_energy / 1)
    
    # Sums the absolute value of the voltage in the waveform
    sum_energy <- sum(abs(MLV))
    
    # Store result
    #rmsenergy <- c(rmsenergy, rel_rmsenergy)
    sumenergy <- c(sumenergy, sum_energy)
  }
  
  # Save Sum Energy results as CSV
  outfile <- paste0(output_folder, paste0("_test",as.character((basename(file_name)))), paste0(".csv"))
  
  write.csv(sumenergy, file = outfile, row.names = FALSE)
}

