library(ggplot2)
library(tidyverse)
# library(ourworldindata::financing_healthcare)
library(dplyr)

dat <- ourworldindata::financing_healthcare

dat <- dat %>% 
  filter(year >= 1800 & year <= 1960)

min_dat <- dat %>% 
  select(continent, year, child_mort)

dat_filter <- dat %>%
  select(continent, year, child_mort) %>% 
  group_by(continent, year) %>% 
  summarise(child_mort = weighted.mean(child_mort)) %>% 
  na.omit()

dat_mean <- dat %>% 
  select(year, child_mort) %>% 
  group_by(year) %>% 
  summarise(child_mort = weighted.mean(child_mort)) %>% 
  na.omit()

dat_filter %>% 
  ggplot(aes(x = year, y = child_mort, label = "")) +
  geom_area(position = 'identity', alpha = 0.5, color = 'red', aes(fill = continent)) +
  geom_line(data = dat_mean) +
  facet_grid(~continent) +
  labs(title = "Child mortality per continent", y = "Child mortality per year", x = "Year", fill = "Continent") +
  ggsave("child_mort.png", width = 15)