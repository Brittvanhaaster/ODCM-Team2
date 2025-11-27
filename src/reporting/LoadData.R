
################
#LOAD LIBRARIES#
################
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)
library(purrr)
library(tibble)

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



# ================================================
# National Holidays 2023–2025
# ================================================
nl_holidays <- as.Date(c(
  # 2023
  "2023-01-01","2023-04-07","2023-04-09","2023-04-10","2023-04-27",
  "2023-05-05","2023-05-18","2023-05-28","2023-05-29","2023-12-25","2023-12-26",
  # 2024
  "2024-01-01","2024-03-29","2024-03-31","2024-04-01","2024-04-27",
  "2024-05-05","2024-05-09","2024-05-19","2024-05-20","2024-12-25","2024-12-26",
  # 2025
  "2025-01-01","2025-04-18","2025-04-20","2025-04-21","2025-04-27",
  "2025-05-05","2025-05-29","2025-06-08","2025-06-09","2025-12-25","2025-12-26"
))

# ================================================
# School Holidays 2023–2025 → Simplified to: date + is_school_holiday_any
# ================================================
school_holidays <- tribble(
  ~region, ~start, ~end,
  
  # --- 2023 ---
  "All","2022-12-24","2023-01-08",
  "Noord","2023-02-25","2023-03-05",
  "Midden","2023-02-25","2023-03-05",
  "Zuid","2023-02-18","2023-02-26",
  "All","2023-04-29","2023-05-07",
  "Noord","2023-07-22","2023-09-03",
  "Midden","2023-07-15","2023-08-27",
  "Zuid","2023-07-08","2023-08-20",
  "Noord","2023-10-21","2023-10-29",
  "Midden","2023-10-14","2023-10-22",
  "Zuid","2023-10-14","2023-10-22",
  "All","2023-12-23","2024-01-07",
  
  # --- 2024 ---
  "Noord","2024-02-17","2024-02-25",
  "Midden","2024-02-17","2024-02-25",
  "Zuid","2024-02-10","2024-02-18",
  "All","2024-04-27","2024-05-12",
  "Noord","2024-07-20","2024-09-01",
  "Midden","2024-07-13","2024-08-25",
  "Zuid","2024-07-06","2024-08-18",
  "Noord","2024-10-26","2024-11-03",
  "Midden","2024-10-19","2024-10-27",
  "Zuid","2024-10-19","2024-10-27",
  "All","2024-12-21","2025-01-05",
  
  # --- 2025 ---
  "Noord","2025-02-15","2025-02-23",
  "Midden","2025-02-15","2025-02-23",
  "Zuid","2025-02-22","2025-03-02",
  "All","2025-04-26","2025-05-11",
  "Noord","2025-07-19","2025-08-31",
  "Midden","2025-07-12","2025-08-24",
  "Zuid","2025-07-05","2025-08-17",
  "Noord","2025-10-18","2025-10-26",
  "Midden","2025-10-25","2025-11-02",
  "Zuid","2025-10-25","2025-11-02",
  "All","2025-12-20","2026-01-04"
) %>%
  mutate(
    start = as.Date(start),
    end   = as.Date(end),
    date  = map2(start, end, seq, by = "day")
  ) %>%
  unnest(date) %>%
  distinct(date) %>%
  mutate(is_school_holiday_any = TRUE)

# ================================================
# FEATURE ENGINEERING ON his_complete
# ================================================

his_complete <- his_complete %>%
  
  # Convert date
  mutate(date = ymd(date)) %>%
  
  # Weekend indicator
  mutate(weekday_weekend = if_else(wday(date, week_start = 1) >= 6,
                                   "weekend", "weekday")) %>%
  
  # Single rider indicator
  mutate(has_single_rider = if_else(str_detect(tolower(ride), "single"), 1, 0)) %>%
  
  # Indoor / outdoor classification
  mutate(
    indoor_outdoor = case_when(
      ride %in% c("Carnaval Festival", "Symbolica", "Villa Volta",
                  "Droomvlucht", "Fata Morgana",
                  "De Vliegende Hollander (darkride)") ~ "indoor",
      ride %in% c("Baron 1898", "Joris en de Draak", "Python",
                  "De Vliegende Hollander", "Vogel Rok Outdoor", "Max & Moritz") ~ "outdoor",
      TRUE ~ "unknown"
    )
  ) %>%
  
  # Capacity values
  mutate(
    capacity_theoretical = case_when(
      ride == "Baron 1898" ~ 1000,
      ride == "Baron 1898 Single-rider" ~ 1000,
      ride == "Carnaval Festival" ~ 1600,
      ride == "Danse Macabre" ~ 1253,
      ride == "Danse Macabre Single-rider" ~ 1253,
      ride == "De Oude Tufferbaan" ~ 1253,
      ride == "De Vliegende Hollander" ~ 1900,
      ride == "De Vliegende Hollander Single-rider" ~ 1900,
      ride == "Droomvlucht" ~ 1800,
      ride == "Fabula" ~ 1760,
      ride == "Fata Morgana" ~ 1800,
      ride == "Gondoletta" ~ 720,
      ride == "Halve Maen" ~ 1200,
      ride == "Joris en de Draak" ~ 2010,
      ride == "Joris en de Draak Single-rider" ~ 1750,
      ride == "Max & Moritz" ~ 1800,
      ride == "Max & Moritz Single-rider" ~ 1800,
      ride == "Pagode" ~ 1000,
      ride == "Piraña" ~ 2000,
      ride == "Python" ~ 1400,
      ride == "Python Single-rider" ~ 1400,
      ride == "Sirocco" ~ 1200,
      ride == "Stoomcarrousel" ~ 400,
      ride == "Stoomtrein Marerijk" ~ 400,
      ride == "Stoomtrein Ruigrijk" ~ 400,
      ride == "Symbolica" ~ 1400,
      ride == "Symbolica Single-rider" ~ 1400,
      ride == "Villa Volta" ~ 1200,
      TRUE ~ NA_real_
    )
  ) %>%
  
  # Opening year
  mutate(
    opening_year = case_when(
      ride == "Baron 1898" ~ 2015,
      ride == "Baron 1898 Single-rider" ~ 2015,
      ride == "Carnaval Festival" ~ 1984,
      ride == "Danse Macabre" ~ 2024,
      ride == "Danse Macabre Single-rider" ~ 2024,
      ride == "De Oude Tufferbaan" ~ 1969,
      ride == "De Vliegende Hollander" ~ 2007,
      ride == "De Vliegende Hollander Single-rider" ~ 2007,
      ride == "Droomvlucht" ~ 1993,
      ride == "Fabula" ~ 2019,
      ride == "Fata Morgana" ~ 1986,
      ride == "Gondoletta" ~ 1981,
      ride == "Halve Maen" ~ 1982,
      ride == "Joris en de Draak" ~ 2010,
      ride == "Joris en de Draak Single-rider" ~ 2010,
      ride == "Kinderspoor" ~ 1984,
      ride == "Max & Moritz" ~ 2020,
      ride == "Max & Moritz Single-rider" ~ 2020,
      ride == "Monorail" ~ 1990,
      ride == "Pagode" ~ 1987,
      ride == "Piraña" ~ 1983,
      ride == "Python" ~ 1981,
      ride == "Python Single-rider" ~ 1981,
      ride == "Sirocco" ~ 2022,
      ride == "Stoomcarrousel" ~ 1956,
      ride == "Stoomtrein Marerijk" ~ 1969,
      ride == "Stoomtrein Ruigrijk" ~ 1969,
      ride == "Symbolica" ~ 2017,
      ride == "Symbolica Single-rider" ~ 2017,
      ride == "Villa Volta" ~ 1996,
      TRUE ~ NA_real_
    )
  ) %>%
  
  # Add national holiday indicator
  mutate(is_holiday = date %in% nl_holidays) %>%
  
  # Join simplified school holiday table
  left_join(
    school_holidays,
    by = "date"
  ) %>%
  
  # Replace NA with FALSE
  mutate(is_school_holiday_any = replace_na(is_school_holiday_any, FALSE))