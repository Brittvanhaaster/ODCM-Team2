
#############################
#MERGING THE WEBSCRAPED DATA#
#############################

#Load libraries
library(tidyverse)
library(lubridate)

#Read data
his_info_and_weather <- read_csv("../../data/his_info_and_weather.csv")
his_queue <- read_csv("../../data/his_queue.csv")

#Merge the web scraped datasets
his_merged <- his_queue %>%
  left_join(his_info_and_weather, by = "date")

#Save file
write_csv(his_merged, "../../data/his_merged.csv")
