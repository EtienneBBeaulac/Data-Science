library(tidyverse)
library(ggplot2)
library(dplyr)

dat <- read_csv("https://github.com/fivethirtyeight/guns-data/raw/master/full_data.csv")

clean_dat <- dat %>% 
  select("X1", "year", "month", "intent", "police", "sex", "age", "race", "place", "education")

clean_dat$intent <- factor(clean_dat$intent, levels = c("Undetermined", "Accidental", "Homicide", "Suicide"))
clean_dat$race <- factor(clean_dat$race, levels = c("White", "Black", "Hispanic", "Asian/Pacific Islander", "Native American/Native Alaskan"))
# clean_dat$month <- as.numeric(as.character(clean_dat$month))

# clean_dat <- clean_dat %>% 
#   mutate(season = case_when(month <= 3 ~ "Winter", month <= 6 ~ "Spring", month <= 9 ~ "Summer", month <= 12 ~ "Fall"))

# filter(clean_dat, !is.na(intent), !is.na(season)) %>%
#   ggplot(aes(x = education)) +
#   geom_bar(aes(fill = factor(intent))) +
#   geom_text(stat = 'count', aes(label = factor(..count..)), hjust = -0.1) +
#   coord_flip() +
#   scale_y_continuous(breaks = seq(0, 60000, 5000)) +
#   scale_fill_brewer(palette = 4) +
#   facet_grid(race ~ season) +
#   theme_grey() +
#   theme(legend.position = "top") +
#   guides(fill = guide_legend(reverse=T, title.position = "top", title.hjust = 0.5)) +
#   labs(title = "Gun deaths in America", x = "Education Level", y = "Number of deaths", fill = "Intent") +
#   ggsave("Case_Study_04/analysis/guns_seasons_education.png", width = 17, height = 10)

filter(clean_dat, !is.na(intent), !is.na(age)) %>%
  mutate(age_group = case_when(age < 18 ~ "0-18", age < 35 ~ "18-35", age < 55 ~ "35-55", age >= 55 ~ "55+")) %>% 
  group_by(month, intent, race, age_group) %>% 
  summarize(death_count = n()) %>% 
  ggplot(aes(x = month, y = death_count, col = intent, group = intent)) +
  geom_line() +
  geom_point() +
  # geom_bar(aes(fill = factor(intent))) +
  # geom_text(stat = 'count', aes(label = factor(..count..)), hjust = -0.1) +
  # coord_flip() +
  # scale_y_continuous(breaks = seq(0, 60000, 5000)) +
  # scale_fill_brewer(palette = 4) +
  facet_grid(race ~ age_group, scales = "free_y") +
  theme_grey() +
  theme(legend.position = "top", plot.title = element_text(hjust = 0.5, size = 22)) +
  # guides(fill = guide_legend(reverse=T, title.position = "top", title.hjust = 0.5)) +
  labs(title = "Gun deaths in America", x = "Month", y = "Number of deaths", col = "Intent") +
  ggsave("Case_Study_04/analysis/guns_good.png", width = 14, height = 10)

# filter(clean_dat, !is.na(intent)) %>%
#   ggplot(aes(x = sex)) +
#   geom_bar(aes(fill = factor(intent))) +
#   geom_text(stat = 'count', aes(label = factor(..count..)), hjust = -0.1) +
#   coord_flip() +
#   scale_y_continuous(breaks = seq(0, 60000, 5000)) +
#   scale_fill_brewer(palette = 4) +
#   facet_wrap(~ race, ncol = 1) +
#   theme_grey() +
#   theme(legend.position = "top") +
#   guides(fill = guide_legend(reverse=T, title.position = "top", title.hjust = 0.5)) +
#   labs(title = "Gun deaths in America", x = "Sex", y = "Number of deaths", fill = "Intent") +
#   ggsave("Case_Study_04/analysis/guns_copy.png", width = 17, height = 10)

  