############################################################
# Data visualisation for ODCM Theme Park Queues & Weather
# Using: efteling_his_complete.csv + efteling_live_queue.csv
############################################################

# 0. Setup -------------------------------------------------

library(tidyverse)
library(lubridate)
library(readr)
library(zoo)

# ---- File paths ------------------------------------------

his_file  <- "data/efteling_his_complete.csv"
live_file <- "data/efteling_live_queue.csv"

# ---- Folder to save figures ------------------------------
if (!dir.exists("figures")) dir.create("figures")


# 1. Load and prepare data ---------------------------------

# 1.1 Historic combined data (rides + park info)
his <- read_csv(his_file) %>%
  mutate(
    date = as_date(date)
  )

# 1.1a Rides (attraction-level queues)
rides <- his %>%
  filter(!is.na(avg_queue_min))

# 1.1b Park-level (crowd + weather)
park <- his %>%
  select(
    date,
    crowd_percent,
    temperature_actual,
    rain_actual
  ) %>%
  distinct() %>%
  mutate(
    date = as_date(date),
    crowd_percent_num = as.numeric(crowd_percent),
    temp_actual_num   = as.numeric(temperature_actual),
    rain_actual_num   = as.numeric(rain_actual)
  )


# 1.2 Live API data (15-min queues)
live <- read_csv(live_file) %>%
  mutate(
    timestamp = ymd_hms(timestamp),
    wait_time = as.numeric(wait_time)
  ) %>%
  rename(ride = attraction_name)


# 2. Historic overview of average queue times --------------

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

ggsave("figures/fig_01a_daily_average_queue_raw.png",
       p_daily_queue, width = 9, height = 4.5, dpi = 300)


## 2.2 Figure 1b – 7-day rolling mean
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

ggsave("figures/fig_01b_daily_average_queue_7day.png",
       p_daily_queue_smooth, width = 9, height = 4.5, dpi = 300)


# 3. Queue pattern during the day (live data) --------------

hourly_queue <- live %>%
  mutate(hour = hour(timestamp)) %>%
  group_by(hour) %>%
  summarise(
    mean_queue = mean(wait_time, na.rm = TRUE),
    .groups = "drop"
  )

p_hourly_queue <- ggplot(hourly_queue, aes(x = hour, y = mean_queue)) +
  geom_line() +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Average Queue Pattern Across Opening Hours",
    x = "Hour of day",
    y = "Average wait (minutes)"
  ) +
  theme_minimal()

ggsave("figures/fig_02_intra_day_queue_pattern.png",
       p_hourly_queue, width = 9, height = 4.5, dpi = 300)


# 4. Weather & crowd aggregated at month level -------------

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

ggsave("figures/fig_03_monthly_crowd.png",
       p_monthly_crowd, width = 9, height = 4.5, dpi = 300)


# 4b. Monthly temperature
p_monthly_temp <- ggplot(monthly_park, aes(x = month, y = temp)) +
  geom_line(color = "tomato") +
  labs(
    title = "Average Monthly Temperature",
    x = "Month",
    y = "Temperature (°C)"
  ) +
  theme_minimal()

ggsave("figures/fig_03b_monthly_temperature.png",
       p_monthly_temp, width = 9, height = 4.5, dpi = 300)


# 4c. Monthly rainfall
p_monthly_rain <- ggplot(monthly_park, aes(x = month, y = rain)) +
  geom_line(color = "steelblue") +
  labs(
    title = "Average Monthly Rainfall",
    x = "Month",
    y = "Rain (mm)"
  ) +
  theme_minimal()

ggsave("figures/fig_03c_monthly_rain.png",
       p_monthly_rain, width = 9, height = 4.5, dpi = 300)


# 5. Monthly queue time vs crowd relationship --------------

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

ggsave("figures/fig_04_queue_vs_crowd.png",
       p_queue_vs_crowd, width = 7, height = 5, dpi = 300)


# 6. Average queue time per ride ---------------------------

p_rides <- rides %>%
  group_by(ride) %>%
  summarise(
    mean_wait = mean(avg_queue_min, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = reorder(ride, mean_wait), y = mean_wait)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Average Queue Time by Ride",
    x = "Ride",
    y = "Average wait (minutes)"
  ) +
  theme_minimal()

ggsave("figures/fig_05_average_queue_by_ride.png",
       p_rides,
       width = 9,
       height = 6,
       dpi = 300)
