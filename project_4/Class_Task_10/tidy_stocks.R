library(rio)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(gridExtra)


csv_file <- import("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv")

dat <- csv_file %>% 
  separate(contest_period, c("monthyear_start", "monthyear_end")) %>% 
  separate(monthyear_end, c("month_end", "year_end"), sep = -5) %>% 
  na.omit()
  
dat$month_end[dat$month_end == "Dec"] <- "December"
dat$year_end[dat$year_end == "Dec"] <- "1993"
dat$month_end[dat$month_end == "1993"] <- "December"


dat <- dat %>% mutate(period = case_when(month_end == "January" | month_end == "February" | month_end == "March" | month_end == "April" | month_end == "May" | month_end == "June" ~ "First",
                                  month_end == "July" | month_end == "August" | month_end == "September" | month_end == "October" | month_end == "November" | month_end == "December" ~ "Second")) %>% 
  group_by(year_end, variable, period) %>% 
  summarise(half_year_val = sum(value))

dat <- dat[-c(1, 3, 5),] %>% na.omit()

plt <- dat %>% 
  ggplot(aes(x = year_end, y = half_year_val, group = variable, col = variable)) +
  geom_line() +
  geom_point(size = 3) +
  facet_grid(~ period) +
  labs(title = "Stock returns per year",
       subtitle = "Split into periods of 6 months every year",
       x = "Year", y = "Returns", col = "Stock")

djia_dat <- dat[ which(dat$variable == 'DJIA'), ]
djia_dat$variable <- NULL

names(djia_dat) <- c("Year", "Period", "Returns")
tt <- ttheme_default(colhead=list(fg_params = list(parse=TRUE)))
tbl <- tableGrob(djia_dat, rows=NULL, theme=tt)
grid <- grid.arrange(plt, tbl, nrow=1, layout_matrix = rbind(c(1, 1, 1, 2),
                                                     c(1, 1, 1, 2)))
  ggsave("Case_Study_05/Class_Task_10/tidy_stocks.png", plot = grid, width = 15)