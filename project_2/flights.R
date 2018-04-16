# I need dep_delay
# I need all flights before noon
# I need the best two airlines

flights_delay <- flights[complete.cases(flights$dep_delay),]

flights_box <- flights_delay %>% 
  filter(hour < 12) %>%
  group_by(carrier, origin) %>% 
  mutate(mean.delay = weighted.mean(dep_delay))

flights_delay <- flights_delay %>%
  filter(hour < 12) %>%
  group_by(hour, origin) %>%
  mutate(mean.delay = weighted.mean(dep_delay))

# flights_delay %>%
#   ggplot() +
#   geom_bar(aes(x = hour, y = mean.delay, color = origin), stat = "identity") +
#   labs(title = "Airlines with lowest departure delay times", x = "Hour", y = "Average Departure Delay") +
#   guides(color = FALSE) +
#   facet_grid(origin ~ carrier) +
#   theme_minimal() +
#   ggsave("Case_Study_03/analysis/flights01.png", width = 20)

flights_delay %>%
  ggplot() +
  geom_boxplot(data = flights_box, aes(x = hour, y = dep_delay, fill = origin, group = hour), outlier.shape = NA) +
  coord_cartesian(ylim = boxplot.stats(flights_delay$dep_delay)$stats[c(1, 5)] * 1.50) +
  geom_hline(yintercept = 0, color = "black", size = 1, linetype = "dotted") +
  labs(title = "Airlines with lowest departure delay times", subtitle = "Gaps in the graph indicates lack of data", x = "Hour", y = "Average Departure Delay") +
  guides(fill = FALSE, color = FALSE) +
  facet_grid(origin ~ carrier, scales = "free") +
  theme_bw() +
  ggsave("Case_Study_03/analysis/flights01_new.png", width = 20)
  

# Arr_delay
# Origin
# "DL" carrier

# flights_new <- flights[complete.cases(flights$arr_delay),]
# 
# flights_new %>%
#   filter(carrier == "DL") %>%
#   group_by(carrier, hour) %>%
#   mutate(mean.dl.flight = weighted.mean(arr_delay)) %>%
#   filter(arr_delay < 300) %>%
#   ggplot() +
#   geom_point(aes(x = hour + (minute / 60), y = arr_delay, color = origin), alpha = 0.1, position = "jitter") +
#   geom_hline(yintercept = 0, color = "black", linetype = "dotted", size = 1) +
#   geom_smooth(aes(x = hour + (minute / 60), y = mean.dl.flight), color = "black", size = 1) +
#   labs(title = "Arrival delay for Delta Airlines flights", subtitle = "Compared between airports", color = "Delay", x = "Hour", y = "Arrival Delay (minutes)") +
#   scale_x_discrete(limits = seq(6, 22, 2)) +
#   scale_y_discrete(limits = seq(-50, 300, 50)) +
#   guides(color = FALSE) +
#   facet_grid(~ origin) +
#   theme_bw() +
#   ggsave("Case_Study_03/analysis/flights02.png", width = 10, height = 5)



