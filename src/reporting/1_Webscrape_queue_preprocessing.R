
#####################################
#PREPROCESSING WEB SCRAPED RIDE DATA#
#####################################

#Load libraries
library(tidyverse)
library(lubridate)

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

#Create a temporary data folder
dir.create("../../data/temp", recursive = TRUE)

#Save files
write_csv(his_queue, "../../data/temp/his_queue.csv")
