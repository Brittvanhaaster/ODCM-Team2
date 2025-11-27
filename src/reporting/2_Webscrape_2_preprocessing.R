
######################################################
#PREPROCESSING WEB SCRAPED PARK INFO AND WEATHER DATA#
######################################################

#Load libraries
library(tidyverse)
library(lubridate)

#Read historical park info and weather data
raw_his_info_and_weather <- read_csv("../../data/efteling_parkinfo_all_years.csv")

#First impressions of dataset
summary(raw_his_info_and_weather)

#raw_park_info_and_weather show there are unit of analyses
#Convert these to normal numeric values
raw_his_info_and_weather <- raw_his_info_and_weather %>%
  mutate(
    crowd_percent = as.numeric(str_remove(crowd_percent, "%")),
    
    temperature_forecast = as.numeric(str_remove(temperature_forecast, "°C")),
    temperature_actual   = as.numeric(str_remove(temperature_actual, "°C")),
    
    intensity_forecast   = as.numeric(str_remove(intensity_forecast, "mm/h")),
    intensity_actual     = as.numeric(str_remove(intensity_actual, "mm/h")),
    
    wind_forecast   = as.numeric(str_remove(wind_forecast, "m/s")),
    wind_actual     = as.numeric(str_remove(wind_actual, "m/s"))
  )

#'Intensity' refers to rain but might be confusing, therefore rename this
his_info_and_weather <- raw_his_info_and_weather %>%
  rename(
    rain_forecast = intensity_forecast,
    rain_actual = intensity_actual
  )

#Save files
write_csv(his_info_and_weather, "../../data/temp/his_info_and_weather.csv")
