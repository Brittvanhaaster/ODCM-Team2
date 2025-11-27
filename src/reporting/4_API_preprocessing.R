
############################################
#PREPROCESSING API DATA ON LIVE QUEUE TIMES#
############################################

#Load libraries
library(tidyverse)
library(lubridate)

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

#Save file
write_csv(live_queue, "../../data/live_queue.csv")
