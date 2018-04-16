# words over time, possibly correlate with events?

library(tidyverse)
library(ggplot2)
library(dplyr)

# Read in the data
dat_cacao <- read_csv("data/flavors_of_cacao.csv")         # CHOCOLATE
# dat_candy <- read_csv("data/candy.csv")                  # CANDY
# dat_ufo <- read_csv("data/ufo-sightings/scrubbed.csv")   # UFO

# Clean up cacao
dat_cacao <- dat_cacao[-c(1),] # Remove first row, repeat of column names
dat_cacao <- subset(dat_cacao, select = -REF)
dat_cacao$`Cocoa\nPercent` <- as.numeric(sub("%", "", dat_cacao$`Cocoa\nPercent`))
dat_cacao$Rating <- as.numeric(dat_cacao$Rating)
colnames(dat_cacao) <- c("Maker", "Bar", "Year", "Percent", "Location", "Rating", "Type", "Origin")

dat_cacao.mean_rating_year <- dat_cacao %>% 
  group_by(Year) %>% 
  summarise(Rating = mean(Rating)) %>% 
  ungroup()

dat_cacao.mean_rating_percent <- dat_cacao %>% 
  group_by(Percent) %>% 
  summarise(Rating = mean(Rating))

# I'm thinking of displaying the amount of cacao vs the rating, maybe facetted per country?
dat_cacao %>%
  ggplot(aes(x = Percent, y = Rating)) +
  geom_density2d(color = "brown") +
  labs(title = "Highest rated percentage of cacao in chocolate", x = "Percent Cacao") +
  ggsave("cacao_rating_percent_density.png")

dat_cacao.mean_rating_year %>% 
  ggplot(aes(x = Year, y = Rating)) +
  geom_point() +
  labs(title = "Highest rating of chocolate per year", x = "Year") +
  ggsave("cacao_rating_year.png")

dat_cacao.mean_rating_percent %>% 
  ggplot(aes(x = Percent, y = Rating, color = Percent)) +
  geom_text(aes(label = Percent)) +
  labs(title = "Highest rating of chocolate per percent cacao", x = "Percent Cacao") +
  ggsave("cacao_rating_percent.png")

# Clean up candy

# Clean up ufo