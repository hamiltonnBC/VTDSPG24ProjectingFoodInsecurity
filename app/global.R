# global.R
#setwd("..")


#forecasting
# forecastingVariables <- read.csv("src/forecasting/SWVA_ForecastingYearsDataFrame.R")
# 
# forecastingVariablesMaps <- read.csv("src/forecasting/lassoAndGraphsFromMia.R")

install.packages("shiny.shiny.semantic")
# Load libraries
library(rsconnect)
library(shiny)
library(shinydashboard)
library(readxl)
library(leaflet)
library(dplyr)
library(tigris)
library(readxl)
library(fontawesome)
library(ggplot2)
library(gridExtra)
library(sf)
library(tidyr)
library(png)
library(plotly)
library(leaflet.extras)
library(readr)

########################################################################################################################################################################################################
# Read CSV files for the Data side bar tab - SWVA censusData
#allData <- read.csv("/Users/hamiltonn/VTDSPG2024FI/app/data/SWVA_ACS_MMG.csv")
#allData <- read.csv("data/SWVA10_27.csv")
GeoID_SW_VA <- c(
  "51005", "51019", "51021", "51023", "51027", "51035", "51045", "51051", "51063", "51067", "51071",
  "51077", "51089", "51105", "51121", "51141", "51143", "51155",
  "51161", "51167", "51169", "51173", "51185", "51191", "51195", "51197", "51520",
  "51580", "51590", "51640", "51690", "51720", "51750", "51770", "51775", "51515"#this one 2010-2013
)

# XGBoost Code
#allData <- read_csv("data/USAForecasted_xgResults_df.csv")
#allData <- allData %>% filter(GEOID %in% GeoID_SW_VA)

#allData <- read_csv("data/oldDraftSWVA10_27.csv")
#======= Below is main code

#allData <- read_csv("data/USAForecasted_xgResults_df.csv")
#allData <- allData %>% filter(GEOID %in% GeoID_SW_VA)
# SWVA <- read.csv("data/USAForecasted_xgResults_df.csv")
# SWVA <- SWVA %>% select(GEOID, Year, Predicted_FI_Rate)
# SWVA <- SWVA %>% filter(GEOID %in% GeoID_SW_VA)

# write.csv(SWVA, file = "data/SWVA10_27.csv", row.names = FALSE)

allData <- read_csv("data/SWVA10_27.csv")
# >>>>>>> main end

 #read in for plotly
SWVA_Plotly <- read.csv("data/countyForecastPlotlyFile.csv")

SWVA_total_per_year <- read_csv("data/SWVA_total_per_year.csv")
all_VA_total_per_year <- read_csv("data/all_VA_total_per_year.csv")
unitedStates_total_per_year <- read_csv("data/unitedStates_total_per_year.csv")
appalachia_total_per_year <- read_csv("data/appalachia_total_per_year.csv")
# Define GeoIDs for Southwest VA counties

# FIRST MAP ########################################################################################################################################################################################################

# Read the GeoJSON files as spatial data
geojson_path_2010 <- "data/shape_file_counties2020.geojson"
geojson_path_2020 <- "data/shape_file_counties2020.geojson"

counties2010 <- st_read(geojson_path_2010)
# rename GEOID10 column to GEOID
#counties2010 <- counties2010 %>%
  #rename(GEOID = GEOID10) %>%
  #rename(NAMELSAD = NAMELSAD10)
counties2020 <- st_read(geojson_path_2020)
countiesAftertracts <- st_read(geojson_path_2020)

("data/shape_file_counties2010.csv")

# Read the geocoded farmers market data from the CSV file
#geocoded_data <- read.csv("data/farmersMarketsSelectedGeocodes.csv")
#geocoded_data$FNAP <- ifelse(!is.na(geocoded_data$FNAP), "Accepts SNAP", "Does not accept SNAP")
#geocoded_data$acceptedpayment <- ifelse(!is.na(geocoded_data$acceptedpayment), "Accepts Credit/Debit", "Does not accept Credit/Debit")

# Read the grocery and dollar store data from the Excel file
#grocery_dollar_stores_SWVA <- read_excel("data/Grocery_DollarStoresInSWVA.xlsx", sheet = 2)

library(readr)
library(readr)
Distributor_Store_Market_Map_Data <- read_csv("data/Distributor_Store_Market_Map_Data2.csv")

# Preprocess the coordinates for grocery and dollar stores
#grocery_dollar_stores_SWVA <- grocery_dollar_stores_SWVA %>%
  #separate(Coordinates, into = c("lat", "lon"), sep = ", ") %>%
  #mutate(lat = as.numeric(lat), lon = as.numeric(lon))

Distributor_Store_Market_Map_Data <- Distributor_Store_Market_Map_Data %>% 
  mutate(lat = as.numeric(lat), lon = as.numeric(lon))

Distributor_Store_Market_Map_Data <- Distributor_Store_Market_Map_Data %>% 
  mutate(Type = as.character(Type))


df_Pantry <- data.frame()
df_Grocery <- data.frame()
df_Dollar <- data.frame()
df_Farmers <- data.frame()

# Iterate over each unique value in 'Type' column
unique_types <- unique(Distributor_Store_Market_Map_Data$Type)
for (t in unique_types) {
  # Subset dataframe for current type
  subset_df <- Distributor_Store_Market_Map_Data[Distributor_Store_Market_Map_Data$Type == t, ]
  
  # Assign subset dataframe to appropriate dataframe based on 'Type'
  if (t == 'P') {
    df_Pantry <- subset_df
  } else if (t == 'G') {
    df_Grocery <- subset_df
  } else if (t == 'D') {
    df_Dollar <- subset_df
  } else if (t == 'F') {
    df_Farmers <- subset_df
  }
}

# Create custom icons
farmerMarketIcon <- makeIcon(
  iconUrl = "www/farmerMarkets.png",
  iconWidth = 25, iconHeight = 41,
  iconAnchorX = 12, iconAnchorY = 41
)

foodStoreIcon <- makeIcon(
  iconUrl = "www/allStores.png",
  iconWidth = 25, iconHeight = 41,
  iconAnchorX = 12, iconAnchorY = 41
)

# Get the unique years from the data frame
unique_years <- unique(allData$Year)

# Set the fixed color range
color_range <- c(4, 30)
color_range_numeric <- as.numeric(color_range)


# Create a color palette with the fixed color range
county_colors <- colorNumeric(palette = "YlOrRd", domain = color_range)

########################################################################################################################################################################################################

#below section is for changes map  ########################################################################################################################################################################################################


allData <- allData %>%
  arrange(GEOID, Year) %>%
  group_by(GEOID) %>%
  mutate(FI_Rate_Change = Predicted_FI_Rate - lag(Predicted_FI_Rate))

########################################################################################################################################################################################################

costPerMeal_FI_Rate <- read.csv("data/costPerMeal_FI_Rate.csv")
#VA10_27 <- read_csv("~/Desktop/DSPG Project/DataFilesFinal/stateAllYears/VA10_27.csv")

########################################################################################################################################################################################################

#unique_names <- unique(allData$NAME)
