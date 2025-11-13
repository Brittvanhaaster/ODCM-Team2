#Load library
library(tidyverse)

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