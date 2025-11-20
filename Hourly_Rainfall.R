library(httr)
library(jsonlite)
library(lubridate)
library(dplyr)

# Portsmouth, NH coordinates
LATITUDE <- 43.0718
LONGITUDE <- -70.7626

get_sunset_times <- function(lat, lon, year, month) {
  sunset_data <- list()
  days_in_month <- days_in_month(as.Date(paste(year, month, "01", sep="-")))
  
  for (day in 1:days_in_month) {
    date_str <- sprintf("%d-%02d-%02d", year, month, day)
    url <- sprintf("https://api.sunrise-sunset.org/json?lat=%f&lng=%f&date=%s&formatted=0",
                   lat, lon, date_str)
    
    response <- GET(url)
    data <- fromJSON(content(response, "text"))
    
    if (data$status == "OK") {
      sunset_utc <- ymd_hms(data$results$sunset, tz="UTC")
      sunset_local <- with_tz(sunset_utc, "America/New_York")
      sunset_data[[date_str]] <- sunset_local
    }
  }
  
  return(sunset_data)
}

get_hourly_rainfall <- function(lat, lon, year, month) {
  start_date <- sprintf("%d-%02d-01", year, month)
  days_in_month <- days_in_month(as.Date(start_date))
  end_date <- sprintf("%d-%02d-%02d", year, month, days_in_month)
  
  url <- "https://api.open-meteo.com/v1/forecast"
  response <- GET(url, query = list(
    latitude = lat,
    longitude = lon,
    hourly = "precipitation",
    start_date = start_date,
    end_date = end_date,
    timezone = "America/New_York"
  ))
  
  data <- fromJSON(content(response, "text"))
  
  df <- data.frame(
    datetime = ymd_hms(data$hourly$time),
    precipitation_mm = data$hourly$precipitation
  )
  
  return(df)
}

calculate_rainfall_after_sunset <- function(rainfall_df, sunset_times) {
  results <- list()
  
  for (date_str in names(sunset_times)) {
    sunset_time <- sunset_times[[date_str]]
    end_time <- sunset_time + minutes(75)  # 1.25 hours = 75 minutes
    
    # Filter rainfall data for this time window
    rainfall_window <- rainfall_df %>%
      filter(datetime >= sunset_time & datetime <= end_time)
    
    total_rainfall <- sum(rainfall_window$precipitation_mm, na.rm = TRUE)
    
    results[[date_str]] <- data.frame(
      date = date_str,
      sunset_time = format(sunset_time, "%Y-%m-%d %H:%M:%S"),
      end_time_1.25hr_post_sunset = format(end_time, "%Y-%m-%d %H:%M:%S"),
      total_rainfall_mm = round(total_rainfall, 2)
    )
  }
  
  return(bind_rows(results))
}

# Main execution
cat("Fetching sunset times for Portsmouth, NH in May 2025...\n")
sunset_times <- get_sunset_times(LATITUDE, LONGITUDE, 2025, 5)

cat("Fetching hourly rainfall data...\n")
rainfall_df <- get_hourly_rainfall(LATITUDE, LONGITUDE, 2025, 5)

cat("Calculating rainfall totals for sunset to 1.25 hours post-sunset window...\n")
results_df <- calculate_rainfall_after_sunset(rainfall_df, sunset_times)

# Save to CSV
output_file <- "portsmouth_nh_rainfall_may2025.csv"
write.csv(results_df, output_file, row.names = FALSE)

cat(sprintf("\nData saved to %s\n", output_file))
cat("\nPreview of results:\n")
print(head(results_df, 10))
cat(sprintf("\nTotal days: %d\n", nrow(results_df)))
cat(sprintf("Total rainfall during sunset windows: %.2f mm\n", sum(results_df$total_rainfall_mm)))