#Load library
library(tidyverse)


##################
#WEBSCRAPING PART#
##################


# Combined ride wait-time dataset (uit jouw scraper)
efteling_rides <- read_csv("efteling_rides_all_years.csv")

# Combined park info dataset (crowd, weather, events)
efteling_parkinfo <- read_csv("efteling_parkinfo_all_years.csv")

##################
# BASIC INSPECTION
##################

glimpse(efteling_rides)
glimpse(efteling_parkinfo)

# Example: mean wait time for one ride
efteling_rides %>% 
  filter(ride == "Joris en de Draak") %>%
  summarise(avg_queue = mean(avg_queue_min, na.rm = TRUE))

# Unique rides
unique_rides <- unique(efteling_rides$ride)
length(unique_rides)

#############################
# IDENTIFY NON-ATTRACTIONS
#############################

# Parkinfo contains the “true” list of attractions.
non_attractions <- efteling_rides %>%
  filter(!ride %in% efteling_parkinfo$ride) %>%
  distinct(ride)

non_attractions

##########
#API PART#
##########

test <- read_csv("efteling_queue_data.csv")

#Convert wait_time to numeric (N/A will automatically become NA)
test <- test %>%
  mutate(wait_time = as.numeric(wait_time))

#Now calculate averages
test %>%
  group_by(attraction_name, queue_type) %>%
  summarise(averagequeue = mean(wait_time, na.rm = TRUE)) %>%
  print(n = 40)















#Load raw data 
raw_weather <- read_csv("Temp/efteling_parkinfo_all_years.csv")
raw_rides <- read_csv("Temp/efteling_rides_all_years.csv")


#Convert the things behind the values so these become numeric
weather <- raw_weather %>%
  mutate(
    crowd_percent = as.numeric(str_remove(crowd_percent, "%")),
    
    temperature_forecast = as.numeric(str_remove(temperature_forecast, "°C")),
    temperature_actual   = as.numeric(str_remove(temperature_actual, "°C")),
    
    rain_forecast   = as.numeric(str_remove(intensity_forecast, "mm/h")),
    rain_actual     = as.numeric(str_remove(intensity_actual, "mm/h")),
    
    wind_forecast        = as.numeric(str_remove(wind_forecast, "m/s")),
    wind_actual          = as.numeric(str_remove(wind_actual, "m/s"))
  )

#Select only attractions that HAVE a queue time
rides <- raw_rides %>%
  filter(ride %in% c(
    "Baron 1898",
    "Baron 1898 Single-rider",
    "Carnaval Festival",
    "De Oude Tufferbaan",
    "De Vliegende Hollander",
    "De Vliegende Hollander Single-rider",
    "Droomvlucht",
    "Droomvlucht VR",
    "Fabula",
    "Fata Morgana",
    "Gondoletta",
    "Halve Maen",
    "Joris en de Draak",
    "Joris en de Draak Single-rider",
    "Kinderspoor",
    "Max & Moritz",
    "Max & Moritz Single-rider",
    "Monorail",
    "Pagode",
    "Piraña",
    "Python",
    "Python Single-rider",
    "Sirocco",
    "Stoomcarrousel",
    "Stoomtrein Marerijk",
    "Stoomtrein Ruigrijk",
    "Symbolica",
    "Symbolica Single-rider",
    "The Six Swans",
    "Villa Volta",
    "Vogel Rok",
    "Droomvlucht Regular Queue",
    "Danse Macabre",
    "Danse Macabre Single-rider"
  ))

#Merge the weather and ride file based on the data
efteling_dataset <- rides %>%
  left_join(weather, by = "date")

#Check if the dataset has missing values
colSums(is.na(efteling_dataset))



library(lubridate)

# Assuming your dataset is called 'weather'
efteling_dataset <- efteling_dataset %>%
  mutate(date = as.Date(date))  # convert to Date if not already



#Note; limit is set to 60 for readability, 2 attractions have higher datapoints
efteling_dataset %>%
  filter(!is.na(avg_queue_min)) %>%
  ggplot(aes(x = fct_reorder(ride, avg_queue_min, .fun = median, .desc = FALSE),
             y = avg_queue_min)) +
  geom_boxplot() +
  coord_flip() +
  scale_y_continuous(limits = c(0, 60)) +
  labs(x = "Ride", y = "Average Queue (min)")


