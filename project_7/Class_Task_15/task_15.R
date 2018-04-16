# library(riem)
# library(ggplot2)
# library(tidyverse)
# library(dplyr)
# library(ggridges)
# library(gridExtra)
# library(knitr)
# library(lubridate)
# 
# measures <- riem_measures(station = "RXE", date_start = "2015-06-01", date_end = "2017-07-01")
# 
# new_measure <- measures %>%
#   select(station, valid, tmpf) %>%
#   mutate(weekday = wday(valid, label = TRUE), hour = hour(valid)) %>%
#   na.omit()
# 
# max_values <- new_measure %>%
#   group_by(weekday) %>%
#   summarise(tmpf = max(tmpf)) %>%
#   slice(2) %>%
#   left_join(new_measure, by = "tmpf")
# 
# new_measure %>%
#   ggplot(aes(x = weekday, y = tmpf)) +
#   geom_point(aes(col = tmpf), position = "jitter") +
#   geom_point(data = max_values, aes(x = weekday.y, y = tmpf), col = "black", size = 3) +
#   geom_hline(aes(yintercept = max(tmpf))) +
#   geom_text(aes(4, max(tmpf), label = paste(max_values$tmpf, max_values$valid, sep = "ºF on "), vjust = -0.1)) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(y = "Temperature ºF", x = "Weekday", col = "Temp") +
#   ggsave("Case_Study_08/Class_Task_15/plot1.png")
# 
# max_value <- new_measure %>%
#   filter(hour == 14) %>% 
#   group_by(hour) %>%
#   summarise(tmpf = max(tmpf)) %>%
#   left_join(new_measure, by = c("tmpf", "hour"))
# 
new_measure %>%
  ggplot(aes(x = hour, y = tmpf)) +
  geom_point(aes(col = tmpf), position = "jitter") +
  geom_point(data = max_value, aes(x = hour, y = tmpf), col = "black", size = 3) +
  geom_hline(aes(yintercept = max_value$tmpf)) +
  geom_text(aes(6, max_value$tmpf, label = paste(max_value$tmpf, max_value$valid, sep = "ºF on "), vjust = -0.1)) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(y = "Temperature ºF", x = "Hour", col = "Temp") +
  ggsave("Case_Study_08/Class_Task_15/plot2.png")
