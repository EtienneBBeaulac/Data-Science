library(USAboundaries)
library(buildings)
library(tidyverse)
library(geofacet)
library(sf)

map.dat <- us_states()

all.permits <- permits %>%
  filter(variable == "All Permits")

single.family <- permits %>%
  filter(variable == "Single Family")

all.multi <- permits %>%
  filter(variable == "All Multifamily")

setwd("Case_Study_10/analysis")

single.family.sum <- single.family %>% 
  group_by(StateAbbr, year) %>% 
  summarize(value = sum(value))

all.permits.sum <- all.permits %>% # summarize sum by state
  group_by(StateAbbr, year) %>% 
  summarize(value = sum(value)) %>% 
  rename(value_all = value) %>% 
  inner_join(single.family.sum, by = c("StateAbbr", "year"))

plot1 <- all.permits.sum %>% 
  ggplot() +
  geom_rect(aes(xmin=2007, xmax=2010, ymin=0, ymax=Inf), fill = "pink") +
  geom_point(aes(x = year, y = value_all), size = 0.5) +
  geom_line(aes(x = year, y = value_all)) +
  labs(title = "Total permits per state from 1980-2010", subtitle = "Mortgage Crisis highlighted in pink, y-scale varies") +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  facet_geo(~StateAbbr, grid = "us_state_grid2", scale = "free_y")

plot2 <- all.permits.sum %>% 
  ggplot() +
  geom_rect(aes(xmin=2007, xmax=2010, ymin=0, ymax=Inf), fill = "pink") +
  geom_point(aes(x = year, y = value_all), size = 0.5, col = "grey") +
  geom_line(aes(x = year, y = value_all), col = "grey") +
  geom_point(aes(x = year, y = value), size = 0.5) +
  geom_line(aes(x = year, y = value)) +
  labs(title = "Total permits vs single permits per state from 1980-2010", subtitle = "Mortgage Crisis highlighted in pink, y-scale varies") +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  facet_geo(~StateAbbr, grid = "us_state_grid2", scale = "free_y")

plot3 <- all.permits.sum %>% 
  filter(StateAbbr == "FL" || StateAbbr == "CA" || StateAbbr == "ID" || StateAbbr == "AZ") %>% 
  ggplot() +
  geom_rect(aes(xmin=2007, xmax=2010, ymin=0, ymax=Inf), fill = "pink") +
  geom_point(aes(x = year, y = value_all, col = StateAbbr), size = 0.5, alpha = 0.5) +
  geom_line(aes(x = year, y = value_all, col = StateAbbr), alpha = 0.5, linetype = "dashed") +
  geom_point(aes(x = year, y = value, col = StateAbbr), size = 0.5) +
  geom_line(aes(x = year, y = value, col = StateAbbr)) +
  labs(title = "Total permits vs single permits in select states from 1980-2010", subtitle = "Mortgage Crisis highlighted in pink, y-scale varies") +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

plot4 <- all.permits.sum %>% 
  filter(year >= 2004) %>% 
  ggplot() +
  geom_rect(aes(xmin=2007, xmax=2010, ymin=0, ymax=Inf), fill = "pink") +
  geom_point(aes(x = year, y = value_all), size = 0.5, col = "grey") +
  geom_line(aes(x = year, y = value_all), col = "grey") +
  geom_point(aes(x = year, y = value), size = 0.5) +
  geom_line(aes(x = year, y = value)) +
  labs(title = "Total permits vs single permits per state from 2004-2010", subtitle = "Mortgage Crisis highlighted in pink, y-scale varies") +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x = element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  facet_geo(~StateAbbr, grid = "us_state_grid2", scale = "free_y")

ggsave("plot1.png", plot = plot1, width = 14, height = 7)
ggsave("plot2.png", plot = plot2, width = 14, height = 7)
ggsave("plot3.png", plot = plot3, width = 14, height = 7)
ggsave("plot4.png", plot = plot4, width = 14, height = 7)

