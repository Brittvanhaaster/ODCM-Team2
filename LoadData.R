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
