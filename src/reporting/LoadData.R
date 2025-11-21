
################
#LOAD LIBRARIES#
################

library(tidyverse)
library(lubridate)

#####################################
#PREPROCESSING WEB SCRAPED RIDE DATA#
#####################################

#Read historical queue data
raw_his_queue <- read_csv("../../data/efteling_rides_all_years.csv")

#First impressions of dataset
summary(raw_his_queue)

#Inspect on what attractions/facilities data is collected on
unique(raw_his_queue$ride)

#raw_rides already shows the correct variable classification for analyses.
#However, rides included are also related to playgrounds and other facilities
#Therefore eliminate the attractions that do NOT have a queue time
his_queue <- raw_his_queue %>%
  filter(!ride %in% c(
    "Anton Pieck Plein",
    "Archipel",
    "Badhuys indoor splash pool",
    "Diorama",
    "Efteling Museum",
    "Fairytale Forest",
    "Kindervreugd",
    "Kleuterhof",
    "Nest!",
    "Volkvanlaaf",
    "poolenspa"
  ))

######################################################
#PREPROCESSING WEB SCRAPED PARK INFO AND WEATHER DATA#
######################################################

#Read historical park info and weather data
raw_his_info_and_weather <- read_csv("../../data/efteling_parkinfo_all_years.csv")

#First impressions of dataset
summary(raw_his_info_and_weather)

#raw_park_info_and_weather show there are unit of analyses
#Convert these to normal numeric values
his_info_and_weather <- raw_his_info_and_weather %>%
  mutate(
    crowd_percent = as.numeric(str_remove(crowd_percent, "%")),
    
    temperature_forecast = as.numeric(str_remove(temperature_forecast, "°C")),
    temperature_actual   = as.numeric(str_remove(temperature_actual, "°C")),
    
    rain_forecast   = as.numeric(str_remove(intensity_forecast, "mm/h")),
    rain_actual     = as.numeric(str_remove(intensity_actual, "mm/h")),
    
    wind_forecast        = as.numeric(str_remove(wind_forecast, "m/s")),
    wind_actual          = as.numeric(str_remove(wind_actual, "m/s"))
  )

############################################
#PREPROCESSING API DATA ON LIVE QUEUE TIMES#
############################################

#Read live queue times data
raw_live_queue <- read_csv("../../data/efteling_queue_data.csv")

#First impressions of dataset
summary(raw_live_queue)

#Inspect on what attractions/facilities data is collected on
unique(raw_live_queue$attraction_name)

#raw_queue also has data on playgrounds and other facilities
#Therefore eliminate the attractions that do NOT have a queue time
raw_live_queue <- raw_live_queue %>%
  filter(!attraction_name %in% c(
    "Kleuterhof",
    "Nest!",
    "Archipel",
    "Volk van Laaf",
    "Fairytale Forest",
    "Efteling Museum",
    "Diorama",
    "Kindervreugd",
    "Anton Pieckplein"
  ))

#Convert wait_time to numeric (N/A will automatically become NA)
live_queue <- raw_live_queue %>%
  mutate(wait_time = as.numeric(wait_time))

#######
#MERGE#
#######

...
...


##################
#DATA EXPLORATION#
##################

#Of live data, calculate averages
live_queue %>%
  group_by(attraction_name, queue_type) %>%
  summarise(averagequeue = mean(wait_time, na.rm = TRUE)) %>%
  print(n = 40)



#Note; limit is set to 60 MINUTES for readability, 2 attractions have higher datapoints
his_queue %>%
  filter(!is.na(avg_queue_min)) %>%
  ggplot(aes(x = fct_reorder(ride, avg_queue_min, .fun = median, .desc = FALSE),
             y = avg_queue_min)) +
  geom_boxplot() +
  coord_flip() +
  scale_y_continuous(limits = c(0, 60)) +
  labs(x = "Ride", y = "Average Queue (min)")




