#Load library
library(tidyverse)


##################
#WEBSCRAPING PART#
##################

#Inspect dataset to get an impression of what it looks like
efteling_metadata <- read_csv("efteling_metadata_all.csv")
efteling_rides <- read_csv("efteling_rides_all.csv")


#Some graphs
efteling_rides %>% 
  group_by(ride = "Joris en de Draak") %>%
  summarise(queue = mean(avg_queue_min, na.rm = TRUE))

#How many rides
unique(efteling_rides$ride)
#some things in here are not rides in the park, such as poolenspa, what do we do with that?


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
