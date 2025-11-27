##################
#DATA EXPLORATION#
##################

#Summarise definitive datasets
summary(his_complete)
summary(live_queue)

#Of live data, calculate average queue time
live_queue %>%
  group_by(attraction_name, queue_type) %>%
  summarise(averagequeue = mean(wait_time, na.rm = TRUE)) %>%
  arrange(desc(averagequeue)) %>%
  print(n = 31)

#Graph for average historical queue time per attraction
his_complete %>%
  filter(!is.na(avg_queue_min)) %>%
  #Note; single-rider queues are not included
  filter(!grepl("Single-rider", ride)) %>%
  ggplot(aes(x = fct_reorder(ride, avg_queue_min, .fun = median, .desc = FALSE),
             y = avg_queue_min)) +
  geom_boxplot() +
  coord_flip() +
  #Note; limit is set to 60 MINUTES for readability, 2 attractions have higher datapoints
  scale_y_continuous(limits = c(0, 60), breaks = seq(0, 60, by = 5)) +
  labs(x = "Ride", y = "Average Queue (min)")

#Queue pattern identification for one particular ride
live_queue %>%
  filter(attraction_name == "Danse Macabre") %>%
  filter(queue_type == "STANDBY") %>%
  mutate(hour = hour(timestamp) + minute(timestamp)/60) %>%
  ggplot(aes(x = hour, y = wait_time)) +
  geom_smooth(method = "loess", span = 0.3, se = TRUE, color = "blue", fill = "lightblue") +
  scale_x_continuous(breaks = 8:22, limits = c(8, 22)) +
  labs(
    title = "Queue Pattern for Danse Macabre Throughout the Day",
    x = "Hour of Day",
    y = "Wait Time (minutes)"
  ) +
  theme_minimal()

#Overview of weather conditions and crowd percentage aggregated to month level
his_complete %>%
  distinct(date, .keep_all = TRUE) %>%
  mutate(month = month(date, label = TRUE, abbr = FALSE)) %>%
  group_by(month) %>%
  summarise(
    avg_crowd_percent = mean(crowd_percent, na.rm = TRUE),
    avg_temp_actual = mean(temperature_actual, na.rm = TRUE),
    avg_rain_actual = mean(rain_actual, na.rm = TRUE),
    avg_wind_actual = mean(wind_actual, na.rm = TRUE)
  ) %>%
  arrange(month)

#Exploration of average queue time and crowd on a month level
his_complete %>%
  filter(!is.na(avg_queue_min)) %>%
  mutate(month = month(date, label = TRUE, abbr = FALSE)) %>%
  group_by(month) %>%
  summarise(
    avg_crowd_percent = mean(crowd_percent, na.rm = TRUE),
    avg_queue_time = mean(avg_queue_min, na.rm = TRUE)
  ) %>%
  arrange(month)