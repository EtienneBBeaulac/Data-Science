# library(tidyverse)
# library(ggplot2)
# library(dplyr)
# library(directlabels)

suicide_data <- read_csv("Case_Study_03/Class_Task_06/suicide-rates-by-country.csv")

colnames(suicide_data)[colnames(suicide_data) == "suicide rate (age-adjusted suicides per 100,000 people)"] <- "Suicides"
colnames(suicide_data)[colnames(suicide_data) == "Entity"] <- "Country"
countries_order <- c("Russia", "Japan", "Sweden", "United States", "Nigeria", "United Kingdom", "Brazil")

suicide_data %>% 
  filter(suicide_data["Country"] == "Russia" | 
         suicide_data["Country"] == "Japan" | 
         suicide_data["Country"] == "Sweden" | 
         suicide_data["Country"] == "United States" | 
         suicide_data["Country"] == "Nigeria" | 
         suicide_data["Country"] == "United Kingdom" | 
         suicide_data["Country"] == "Brazil") %>% 
  ggplot(size = 0.8, aes(x = Year, y = Suicides, color = Country)) +
  geom_line() + 
  geom_point() + 
  scale_color_discrete(guide = 'none') +
  scale_y_continuous(breaks = seq(0, 35, 5)) +
  scale_x_continuous(breaks = seq(1950, 2009, 10), expand = c(0, 10)) +
  labs(title = "Suicide rates by country", 
       subtitle = "Suicides per 100,000 people per year. The rate is adjusted for the changing age structure of the population.") +
  geom_dl(aes(label = Country), method = list(dl.trans(x = x + 0.5), "last.points", cex = 0.8)) +
  geom_dl(aes(label = Country), method = list(dl.trans(x = x - 0.5), "first.points", cex = 0.8)) +
  theme_minimal() +
  ggsave('Case_Study_03/Class_Task_06/suicide-rates.png', width = 10)
  