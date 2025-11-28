#Load libraries
library(tidyverse)
library(lubridate)

#################
#FILE MANAGEMENT#
#################

#After running the previous 5 steps, there is a lot of data.
#This script removes the unnecessary files
rm(list = ls())

#This is the definitive data
efteling_live_queue <- read_csv("../../data/final/efteling_live_queue.csv")
efteling_his_merged <- read_csv("../../data/final/efteling_his_merged.csv")
efteling_his_complete <- read_csv("../../data/final/efteling_his_complete.csv") #Includes feature engineering
