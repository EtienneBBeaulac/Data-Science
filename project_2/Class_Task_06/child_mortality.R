# library(ggplot2)
data <- ourworldindata::child_mortality

filter_data <- data[complete.cases(data[ , 1:5]),] %>%  
  filter(year > 1825) %>% 
  group_by(continent, year) %>% 
  mutate(weight.rate = weighted.mean(child_mort))

filter_data %>% 
  group_by(year) %>% 
  mutate(weight.mean.rate = weighted.mean(weight.rate)) %>% 
  ggplot() +
  geom_smooth(color = 'black', size = 2, aes(y = weight.mean.rate, x = year)) +
  geom_smooth(aes(y = weight.rate, x = year, color = continent)) +
  labs(title = "World Child Mortality Rates", subtitle = "Average child mortality rate per continent", y = "Average Child Mortality Rate", x = "Year", color = "Area") +
  theme_minimal() +
  ggsave('Case_Study_03/Class_Task_06/child-rates.png', width = 10)