library(Lahman)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(blscrapeR)
library(ggpubr)

# I will need Master, Salaries, CollegePlaying, and Schools

dat <- CollegePlaying %>% 
  select(-yearID) %>%  
  inner_join(Schools %>% 
               filter(state == "UT") %>% 
               select(schoolID, name_full)) %>% 
  inner_join(Master %>%
               select(playerID, nameGiven)) %>% 
  inner_join(Salaries %>% 
               select(playerID, salary, yearID), by="playerID") %>% 
  inner_join(inflation_adjust(2017) %>% 
               mutate(yearID = as.numeric(year)) %>% 
               select(adj_value, yearID)) %>% 
  mutate(adj_salary = salary / adj_value) %>% 
  select(nameGiven, yearID, name_full, adj_salary) %>% 
  rename(player = nameGiven, year = yearID, school = name_full, salary = adj_salary) %>% 
  group_by(player, school) %>% 
  summarise(salary.max = max(salary)) %>% 
  ungroup() %>% 
  arrange(desc(salary.max)) %>% 
  mutate(ordered_id = 1:n())

dat$player <- reorder(dat$player, dat$ordered_id)

plot1 <- dat %>% 
  ggplot(aes(x = player, y = salary.max/1000000, col = school)) +
  geom_point(size = 3) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "Players", y = "Salary (Millions)", col = "School")

plot2 <- dat %>% 
  ggplot(aes(x = school, y = salary.max/1000000, col = school)) +
  geom_point(size = 3, position = "jitter") +
  theme(axis.text.x = element_text(angle = 90), axis.title.y = element_blank()) +
  guides(fill = FALSE) +
  labs(x = "Schools")

ggarrange(plot1, plot2, common.legend = TRUE) %>% 
  annotate_figure(top = text_grob("Baseball Player Salaries from Utah Colleges", color = "red", face = "bold", size = 14)) +
  ggsave("Case_Study_06/Class_Task_11/baseball.png")

