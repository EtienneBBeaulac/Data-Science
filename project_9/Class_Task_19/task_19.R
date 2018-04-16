library(USAboundaries)
library(ggrepel)
library(sf)
library(ggplot2)
library(maps)
library(tidyverse)

states <- us_states() %>%
  filter(name != 'Hawaii', name != 'Alaska', stusps != 'PR')

cities <- us_cities()
biggest_cities <- cities %>%
  group_by(state) %>%
  arrange(desc(population)) %>% 
  top_n(n = 3, wt = population) %>%
  mutate(count = 1, n = cumsum(count)) %>% 
  ungroup() %>% 
  filter(state != 'AK', state != 'HI')


ggplot() +
  geom_sf(data = states, fill = NA, show.legend = 'point') +
  geom_point(data = biggest_cities, aes(x = lon, y = lat, col = n)) +
  geom_label_repel(data = biggest_cities %>% filter(n == 1), aes(x = lon, y = lat, col = n, label = city), col= 'blue') +
  theme_light() +
  guides(col = FALSE) +
  theme(panel.grid.minor = element_line(colour = "gray87", size = 5)) +
  ggsave('Case_Study_10/Class_Task_19/plot.png', width = 12)
  