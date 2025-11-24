############################################################
# Data visualisation for ODCM Theme Park Queues & Weather
# Script: data_visualisation.R
# Purpose: Produce figures for Chapter 5 (Data inspection)
############################################################

# 0. Setup -------------------------------------------------

# Install packages once if needed:
# install.packages(c("tidyverse", "lubridate", "zoo"))

library(tidyverse)
library(lubridate)
library(readr)
library(zoo)

# ---- File paths (relative to project root) ---------------
# Your CSVs are in src/reporting. If you move them to /data,
# just change "src/reporting/" to "data/" below.

rides_file  <- "data/efteling_rides_all_years.csv"
park_file   <- "data/efteling_parkinfo_all_years.csv"
live_file   <- "data/efteling_queue_data.csv"

# ---- Folder to save figures ------------------------------
# Creates "figures" folder if it doesn't exist yet
if (!dir.exists("figures")) dir.create("figures")


# 1. Load and prepare data ---------------------------------

# 1.1 Rides (historic attraction-level queues)
rides <- read_csv(rides_file) %>%
  mutate(
    date = as_date(date)   # ensure Date class
  )
# expected cols: date, park_id, ride, avg_queue_min, max_queue_min, uptime_pct


# 1.2 Park info (crowd + weather, day level)
park <- read_csv(park_file) %>%
  mutate(
    date = as_date(date),
    # strip units and convert to numeric
    crowd_percent_num = parse_number(crowd_percent),
    temp_actual_num   = parse_number(temperature_actual),
    rain_actual_num   = parse_number(intensity_actual)
  )
# expected cols include: crowd_percent, temperature_actual, intensity_actual


# 1.3 Live API data (15-min queues)
live <- read_csv(live_file) %>%
  mutate(
    # parse timestamp and wait_time safely
    timestamp = ymd_hms(timestamp),
    wait_time = parse_double(wait_time, na = c("N/A", "NA", ""))
  )
# expected cols include: timestamp, wait_time, ride, status, queue_type, ...


# 2. Historic overview of average queue times --------------
#    Figure 1a: noisy daily average queue time
#    Figure 1b: smoothed 7-day rolling mean (clearer)

daily_queue <- rides %>%
  group_by(date) %>%
  summarise(
    mean_queue = mean(avg_queue_min, na.rm = TRUE),
    .groups = "drop"
  )

## 2.1 Figure 1a – raw daily series
p_daily_queue <- ggplot(daily_queue, aes(x = date, y = mean_queue)) +
  geom_line() +
  labs(
    title = "Daily Average Queue Time Over Time",
    x = "Date",
    y = "Average wait (minutes)"
  ) +
  theme_minimal()

print(p_daily_queue)

ggsave("figures/fig_01a_daily_average_queue_raw.png",
       p_daily_queue, width = 9, height = 4.5, dpi = 300)


## 2.2 Figure 1b – 7-day rolling mean (smoothed)
daily_queue_smooth <- daily_queue %>%
  arrange(date) %>%
  mutate(
    mean_queue_7day = rollmean(mean_queue, k = 7, fill = NA, align = "right")
  )

p_daily_queue_smooth <- ggplot(daily_queue_smooth,
                               aes(x = date, y = mean_queue_7day)) +
  geom_line() +
  labs(
    title = "Smoothed Daily Average Queue Time (7-day Rolling Mean)",
    x = "Date",
    y = "Average wait (minutes)"
  ) +
  theme_minimal()

print(p_daily_queue_smooth)

ggsave("figures/fig_01b_daily_average_queue_7day.png",
       p_daily_queue_smooth, width = 9, height = 4.5, dpi = 300)


# 3. Queue pattern during the day (live data) --------------
#    Figure 2 – intra-day average queue pattern

hourly_queue <- live %>%
  mutate(hour = hour(timestamp)) %>%
  group_by(hour) %>%
  summarise(
    mean_queue = mean(wait_time, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(!is.na(hour))

p_hourly_queue <- ggplot(hourly_queue, aes(x = hour, y = mean_queue)) +
  geom_line() +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Average Queue Pattern Across Opening Hours",
    x = "Hour of day",
    y = "Average wait (minutes)"
  ) +
  theme_minimal()

print(p_hourly_queue)

ggsave("figures/fig_02_intra_day_queue_pattern.png",
       p_hourly_queue, width = 9, height = 4.5, dpi = 300)


# 4. Weather & crowd aggregated at month level -------------
#    Figure 3 – average monthly crowd percentage

monthly_park <- park %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(month) %>%
  summarise(
    crowd = mean(crowd_percent_num, na.rm = TRUE),
    temp  = mean(temp_actual_num,   na.rm = TRUE),
    rain  = mean(rain_actual_num,   na.rm = TRUE),
    .groups = "drop"
  )

p_monthly_crowd <- ggplot(monthly_park, aes(x = month, y = crowd)) +
  geom_line() +
  labs(
    title = "Average Monthly Crowd Percentage",
    x = "Month",
    y = "Crowd (%)"
  ) +
  theme_minimal()

print(p_monthly_crowd)

ggsave("figures/fig_03_monthly_crowd.png",
       p_monthly_crowd, width = 9, height = 4.5, dpi = 300)

#    Figure 3b – average monthly temperature
p_monthly_temp <- ggplot(monthly_park, aes(x = month, y = temp)) +
  geom_line(color = "tomato") +
  labs(
    title = "Average Monthly Temperature",
    x = "Month",
    y = "Temperature (°C)"
  ) +
  theme_minimal()

print(p_monthly_temp)

ggsave("figures/fig_03b_monthly_temperature.png",
       p_monthly_temp, width = 9, height = 4.5, dpi = 300)

#    Figure 3c – average monthly rainfall intensity
p_monthly_rain <- ggplot(monthly_park, aes(x = month, y = rain)) +
  geom_line(color = "steelblue") +
  labs(
    title = "Average Monthly Rainfall Intensity",
    x = "Month",
    y = "Rain (mm/hour)"
  ) +
  theme_minimal()

print(p_monthly_rain)

ggsave("figures/fig_03c_monthly_rain.png",
       p_monthly_rain, width = 9, height = 4.5, dpi = 300)


# 5. Monthly queue time vs crowd relationship --------------
#    Figure 4 – relationship between crowd and queue

monthly_rides <- daily_queue %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(month) %>%
  summarise(
    mean_queue = mean(mean_queue, na.rm = TRUE),
    .groups = "drop"
  )

monthly_joined <- monthly_rides %>%
  left_join(monthly_park, by = "month")

p_queue_vs_crowd <- ggplot(monthly_joined,
                           aes(x = crowd, y = mean_queue)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Monthly Relationship Between Crowd Level and Queue Time",
    x = "Crowd (%)",
    y = "Average queue time (minutes)"
  ) +
  theme_minimal()

print(p_queue_vs_crowd)

ggsave("figures/fig_04_queue_vs_crowd.png",
       p_queue_vs_crowd, width = 7, height = 5, dpi = 300)

