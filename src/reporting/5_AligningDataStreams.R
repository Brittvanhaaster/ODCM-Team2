
################################################
#ALIGNING WEBSCRAPE AND API DATA WITH EACHOTHER#
################################################

#Load libraries
library(tidyverse)
library(lubridate)

#Read in data
his_merged <- read_csv("../../data/his_merged.csv")
live_queue <- read_csv("../../data/live_queue.csv")

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
his_merged <- his_merged %>%
  mutate(ride = case_when(
    ride == "Droomvlucht Regular Queue" ~ "Droomvlucht",
    TRUE ~ ride
  ))

#Checkup: Verify whether the historical and API data have data on the SAME attractions
unique(live_queue$attraction_name) %>% sort()
unique(his_merged$ride) %>% sort()

#Save files
write_csv(live_queue, "../../data/efteling_live_queue.csv")
write_csv(his_merged, "../../data/efteling_his_merged.csv")
