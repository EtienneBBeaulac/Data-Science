library(riem)
library(ggplot2)
library(tidyverse)
library(dplyr)
library(ggridges)
library(gridExtra)
library(knitr)
library(lubridate)
library(readr)


dat <- read_csv("https://byuistats.github.io/M335/data/Walmart_store_openings.csv")

states <- tbl_df(state.abb) %>% 
  mutate(state_area = state.area, state_name = state.name, state_region = state.region)

# new_dat <- dat %>% 
#   mutate(new_time = with_tz(mdy(OPENDATE), "America/Denver")) %>% 
#   left_join(states, by = c("STRSTATE" = "value")) %>% 
#   mutate(state_order = fct_reorder(STRSTATE, new_time, fun = min, .desc = TRUE))
# 
# new_dat %>% 
#   ggplot() +
#   geom_histogram(aes(x = new_time, fill = state_region), binwidth = 365) + 
#   facet_grid(state_order~.) +
#   scale_fill_manual(values = c("#f97306", "#3f9b0b", "#d5b60a", "#0485d1")) +
#   theme_minimal() +
#   ggsave("test.png", height = 25)

df <- new_dat %>% 
  mutate(year = year(new_time)) %>% 
  complete(year, STRSTATE) %>% 
  group_by(year, STRSTATE, state_region, state_order) %>% 
  summarize(year_total = n()) %>% 
  ungroup() %>% 
  group_by(STRSTATE) %>% 
  mutate(cum_sum = cumsum(year_total))

df %>% 
  ggplot(aes(x = year, y = cum_sum, col = state_region)) +
  geom_point() +
  geom_line() +
  facet_grid(state_order~.) +
  scale_fill_manual(values = c("#f97306", "#3f9b0b", "#d5b60a", "#0485d1")) +
  theme_minimal() +
  ggsave("test.png", height = 25)