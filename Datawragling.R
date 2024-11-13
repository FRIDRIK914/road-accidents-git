library(shiny)
library(dplyr)
library(ggmap)
library(ggplot2)
library(sf)
library(leaflet)
library(leafem)
library(bslib)
library(bsicons)
library(plotly)
library(stringr)
library(tidyr)
# Register Google Maps API key
ggmap::register_google(key = "*********", write = TRUE)


# Load data
data <- read.csv2("roadtrafficaccidentlocations.csv")

# Create an 'sf' object with LV95 coordinates
sf_lv95 <- st_as_sf(data, coords = c("AccidentLocation_CHLV95_E", "AccidentLocation_CHLV95_N"), crs = 2056)

# Transform LV95 to WGS84 (EPSG:4326)
sf_wgs84 <- st_transform(sf_lv95, crs = 4326)

# Extract the transformed coordinates
df_wgs84 <- st_coordinates(sf_wgs84)

# Combine the WGS84 coordinates with the original dataset
data <- cbind(data, df_wgs84)

# Rename columns and select relevant columns
data <- data %>% 
  rename(Latitude = Y, Longitude = X) %>%
  select(-AccidentType, -RoadType, -CantonCode, -AccidentWeekDay)

# Set factor variables
data <- data %>% mutate(across(
  c(
    AccidentType_en, AccidentSeverityCategory_en, AccidentInvolvingPedestrian,
    AccidentInvolvingBicycle, AccidentInvolvingMotorcycle, RoadType_en,
    AccidentYear, AccidentMonth, AccidentMonth_en, AccidentWeekDay_en,
    AccidentHour_text
  ),
  as.factor
))

# Create new factor variable for accident involvement
data <- data %>%
  mutate(
    AccidentInvolving = case_when(
      AccidentInvolvingPedestrian == TRUE & AccidentInvolvingBicycle == TRUE ~ "Pedestrian and Bicycle",
      AccidentInvolvingPedestrian == TRUE & AccidentInvolvingMotorcycle == TRUE ~ "Pedestrian and Motorcycle",
      AccidentInvolvingBicycle == TRUE & AccidentInvolvingMotorcycle == TRUE ~ "Bicycle and Motorcycle",
      AccidentInvolvingPedestrian == TRUE ~ "Pedestrian",
      AccidentInvolvingBicycle == TRUE ~ "Bicycle",
      AccidentInvolvingMotorcycle == TRUE ~ "Motorcycle",
      TRUE ~ "Car"
    )
  ) %>% mutate(AccidentInvolving = as.factor(AccidentInvolving))








# Define a function to get the full address information
get_full_address <- function(lat, lon) {
# Reverse geocode to get detailed address components
  result <- revgeocode(
    location = c(as.numeric(lon), as.numeric(lat)),  # Ensure numeric input
    output = "address",
    source = "google"
  )
  
  return(result)  # Return the full result for later extraction
}

# Use mapply to apply the function to each row without changing data types
data$full_address <- mapply(get_full_address, data$Latitude, data$Longitude, SIMPLIFY = FALSE)

data$street_address <- sapply(data$full_address, function(address) {
  strsplit(address, ",")[[1]][1]  # Extract part before the first comma (street address)
})

data$postcode <- sapply(data$full_address, function(address) {
  # Use regex to find a 5-digit code that starts with "8"
  postal_code <- str_extract(address, "\\b8\\d{3}\\b")
  return(postal_code)
})

data$full_address <- sapply(data$full_address, toString)

write.csv(data, "caraccidents.csv", row.names = FALSE)
