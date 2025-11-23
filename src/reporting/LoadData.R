
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
    "Droomvlucht VR",
    "Efteling Museum",
    "Fairytale Forest",
    "Kindervreugd",
    "Kleuterhof",
    "Nest!",
    "The Six Swans",
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
raw_live_queue <- raw_live_queue %>%
  mutate(wait_time = as.numeric(wait_time))

#The timestamp is accidentally at UTC timezone, while it should be UTC+1. Adjust this with;
live_queue <- raw_live_queue %>%
  mutate(timestamp = timestamp + hours(1))

####################################################
#PREPROCESSING DATA FROM THE PERSPECTIVE OF MERGING#
####################################################

#The live dataset has Single-rider as a seperate column and not added to the attraction name
#In order to have a composite key for merging, the following code adds this
live_queue <- live_queue %>%
  mutate(attraction_name = if_else(queue_type == "SINGLE_RIDER",
                                   paste(attraction_name, "Single-rider"),
                                   attraction_name))

#There are inconsistencies in naming the steam train attraction. This is fixed with
live_queue <- live_queue %>%
  mutate(attraction_name = case_when(
    attraction_name == "Stoomtrein - Oost" ~ "Stoomtrein Ruigrijk",
    attraction_name == "Stoomtrein - Marerijk" ~ "Stoomtrein Marerijk",
    TRUE ~ attraction_name
  ))

#In the historical dataset, one ride has a different name, which is modified with this code
his_queue <- his_queue %>%
  mutate(ride = case_when(
    ride == "Droomvlucht Regular Queue" ~ "Droomvlucht",
    TRUE ~ ride
  ))

#Checkup: Verify whether the historical and API data have data on the SAME attractions
unique(live_queue$attraction_name) %>% sort()
unique(his_queue$ride) %>% sort()

#############################
#MERGING THE WEBSCRAPED DATA#
#############################

#Merge the web scraped datasets
his_complete <- his_queue %>%
  left_join(his_info_and_weather, by = "date")

#################
#FILE MANAGEMENT#
#################

#Remove raw files for clarity while data exploring
rm(raw_his_info_and_weather, raw_his_queue, raw_live_queue)

#Potentially remove the seperate web scraped files
rm(his_info_and_weather, his_queue)

#Save the definitive datafiles locally
write_csv(his_complete, "../../data/efteling_his_complete.csv")
write_csv(live_queue, "../../data/efteling_live_queue.csv")

##################
#DATA EXPLORATION#
##################

#Summarise definitive datasets
summary(his_complete)
summary(live_queue)

#Of live data, calculate average queue time
live_queue %>%
  group_by(attraction_name, queue_type) %>%
  summarise(averagequeue = mean(wait_time, na.rm = TRUE)) %>%
  arrange(desc(averagequeue)) %>%
  print(n = 31)

#Graph for average historical queue time per attraction
his_complete %>%
  filter(!is.na(avg_queue_min)) %>%
  #Note; single-rider queues are not included
  filter(!grepl("Single-rider", ride)) %>%
    ggplot(aes(x = fct_reorder(ride, avg_queue_min, .fun = median, .desc = FALSE),
             y = avg_queue_min)) +
  geom_boxplot() +
  coord_flip() +
  #Note; limit is set to 60 MINUTES for readability, 2 attractions have higher datapoints
  scale_y_continuous(limits = c(0, 60), breaks = seq(0, 60, by = 5)) +
  labs(x = "Ride", y = "Average Queue (min)")

#Queue pattern identification for one particular ride
live_queue %>%
  filter(attraction_name == "Danse Macabre") %>%
  filter(queue_type == "STANDBY") %>%
  mutate(hour = hour(timestamp) + minute(timestamp)/60) %>%
  ggplot(aes(x = hour, y = wait_time)) +
  geom_smooth(method = "loess", span = 0.3, se = TRUE, color = "blue", fill = "lightblue") +
  scale_x_continuous(breaks = 8:22, limits = c(8, 22)) +
  labs(
    title = "Queue Pattern for Danse Macabre Throughout the Day",
    x = "Hour of Day",
    y = "Wait Time (minutes)"
  ) +
  theme_minimal()

#Overview of weather conditions and crowd percentage aggregated to month level
his_complete %>%
  distinct(date, .keep_all = TRUE) %>%
  mutate(month = month(date, label = TRUE, abbr = FALSE)) %>%
  group_by(month) %>%
  summarise(
    avg_crowd_percent = mean(crowd_percent, na.rm = TRUE),
    avg_temp_actual = mean(temperature_actual, na.rm = TRUE),
    avg_rain_actual = mean(rain_actual, na.rm = TRUE),
    avg_wind_actual = mean(wind_actual, na.rm = TRUE)
  ) %>%
  arrange(month)

#Exploration of average queue time and crowd on a month level
his_complete %>%
  filter(!is.na(avg_queue_min)) %>%
  mutate(month = month(date, label = TRUE, abbr = FALSE)) %>%
  group_by(month) %>%
  summarise(
    avg_crowd_percent = mean(crowd_percent, na.rm = TRUE),
    avg_queue_time = mean(avg_queue_min, na.rm = TRUE)
  ) %>%
  arrange(month)


#more to come...