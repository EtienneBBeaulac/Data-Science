# library(stringi)
# library(stringr)
# library(ggplot2)
# library(tidyverse)
# library(readr)
# library(dplyr)
# library(ggridges)
# library(gridExtra)
# 
# dat_ <- read_csv("Case_Study_07/Class_Task_14/lds-scriptures.csv")
# 
# dat <- dat_ %>% 
#   mutate(lower_verse = strsplit(tolower(scripture_text), " "), verse_length = sapply(lower_verse, length))
# 
# dat %>% 
#   filter(volume_id == 2 | volume_id == 3) %>% 
#   group_by(volume_title) %>% 
#   summarise(average_verse_length = mean(verse_length))

# dat %>%
#   filter(volume_id == 2 | volume_id == 3) %>%
#   mutate(jesus = sapply(sapply(lower_verse, grep, pattern = "jesus"), length)) %>% 
#   group_by(volume_title) %>% 
#   summarize(jesus_count = sum(jesus))
new_dat <- dat %>% 
  filter(volume_id == 3)

book_f <- new_dat$book_title %>% factor() %>% fct_inorder()
plot1 <- new_dat %>% 
  ggplot(aes(x = verse_length, y = book_f, fill = book_f)) +
  geom_density_ridges(rel_min_height = 0.01) +
  labs(x = "Word count per verse") +
  guides(fill = FALSE) +
  theme(axis.title.y = element_blank())

plot2 <- new_dat %>% 
  ggplot(aes(x = verse_number, y = verse_length, col = book_title)) +
  geom_point(alpha = 0.5, position = "jitter") +
  facet_wrap(~book_title, ncol = 3) +
  guides(col = FALSE) +
  labs(x = "Verse number", y = "Word count per verse")

ggarrange(plot1, plot2, ncol = 2) %>% 
  annotate_figure(top = text_grob("How does the word count distribution by verse look for each book in the Book of Mormon?", 
                                  color = "red", face = "bold", size = 14)) +
    ggsave("Case_Study_07/Class_Task_14/distribution.png", width = 12)
