
#####################
#FEATURE ENGINEERING#
#####################

#Load libraries
library(tidyverse)
library(lubridate)

#Read in dataset
efteling_his_merged <- read_csv("../../data/final/efteling_his_merged.csv")

#As an additional bonus to the cleaned and aligned datasets from step 5, this scripts provides feature 
#engineering variables that could be of potential interest when analysing the datasets. Although the
#code could be incorporated into big chunks, the choice has been made to split this, to allow
#future researchers to assess which variables they wish to add depending on the research question.

###########################################

#1
#Weekend variable
efteling_his_merged <- efteling_his_merged %>% mutate(
  
  #Ensure date is recognised as a date
  date = ymd(date),
  
  #Add variable
  weekday_weekend = ifelse(wday(date, week_start = 1) >= 6, "weekend", "weekday")
)
  
###########################################

#2
#Single rider simplification
efteling_his_merged <- efteling_his_merged %>% mutate(
  
  # Single rider indicator
  has_single_rider = if_else(str_detect(tolower(ride), "single"), 1, 0)
)

###########################################

#3
# Ride indication
efteling_his_merged <- efteling_his_merged %>% mutate(
  
    # Indoor / outdoor classification
    indoor_outdoor = case_when(
      ride %in% c("Carnaval Festival", "Droomvlucht", "Fabula", 
                  "Fata Morgana", "Stoomcarrousel", "Symbolica", 
                  "Symbolica Single-rider", "Villa Volta", "Vogel Rok",
                  "Danse Macabre", "Danse Macabre Single-rider") ~ "indoor",
      ride %in% c("Baron 1898", "Baron 1898 Single-rider", 
                  "De Oude Tufferbaan", "De Vliegende Hollander",
                  "De Vliegende Hollander Single-rider", "Gondoletta",
                  "Halve Maen", "Joris en de Draak", 
                  "Joris en de Draak Single-rider", "Kinderspoor",
                  "Max & Moritz", "Max & Moritz Single-rider", 
                  "Monorail", "Pagode", "Piraña", "Python", 
                  "Python Single-rider", "Sirocco", "Stoomtrein Marerijk",
                  "Stoomtrein Ruigrijk") ~ "outdoor"
    )
  )

###########################################

#4
# Ride capacity
efteling_his_merged <- efteling_his_merged %>% mutate(
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
      ride == "Kinderspoor" ~ 320,
      ride == "Max & Moritz" ~ 1800,
      ride == "Max & Moritz Single-rider" ~ 1800,
      ride == "Monorail" ~ 50,
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
      ride == "Vogel Rok" ~ 1600,
      TRUE ~ NA_real_
    )
  )

###########################################

#5
#Opening year
efteling_his_merged <- efteling_his_merged %>% 
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
      ride == "Vogel Rok" ~ 1998
    )
  )
  
###########################################

#6
#Holidays
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
  mutate(is_school_holiday_any = TRUE)  # This line creates the column

# Holiday feature engineering
efteling_his_merged <- efteling_his_merged %>%
  
  # Join school holidays
  left_join(school_holidays, by = "date") %>%
  
  # Add holiday indicators
  mutate(
    # National holiday indicator
    is_holiday = date %in% nl_holidays,
    
    # Replace NA in school holiday with FALSE
    is_school_holiday_any = replace_na(is_school_holiday_any, FALSE)
  )

###########################################

#Sanity check to see if there are missing values on newly created dataset
colSums(is.na(efteling_his_merged))

#Save file
write_csv(efteling_his_merged, "../../data/final/efteling_his_complete.csv")
