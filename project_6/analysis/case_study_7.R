# library(stringi)
# library(stringr)
# library(ggplot2)
# library(tidyverse)
# library(readr)
# library(dplyr)
# library(ggridges)
# library(gridExtra)
# library(downloader)
# library(gsubfn)
# 
# # To get the standard works data
# download("http://scriptures.nephi.org/downloads/lds-scriptures.csv.zip", "docs/data/scriptures.zip", mode = "wb")
# unzip("docs/data/scriptures.zip", exdir = file.path(getwd(),"docs/data"))
# file.remove("docs/data/scriptures.zip")
# scriptures <- read_csv("docs/data/lds-scriptures.csv") %>%
#   filter(volume_id == 3)
# 
# # to get the Savior names
# bmnames <- read_rds(gzcon(url("https://byuistats.github.io/M335/data/BoM_SaviorNames.rds")))
# 
# bom <- gsub("[^a-zA-Z ]", "", paste(scriptures$scripture_text, collapse = ' '))
# index = 1;
# new_names = c()
# for (i in bmnames$name) {
#   new_names <- c(new_names, paste0("name", index))
#   bom <- str_replace_all(bom, i, paste0("name", index))
#   index <- index + 1
# }
# 
# names_vector <- strapply(bom, paste(new_names, collapse = '|'))
# bom_splits <- strsplit(bom, split = paste(new_names, collapse = '|'))
# 
# bom_df <- data.frame(bom_splits)
# colnames(bom_df) <- "words"
# name_codes_df <- data.frame(new_names)
# colnames(name_codes_df) <- "name_codes"
# name_codes_df["names"] <- bmnames$name
# bom_df <- bom_df %>%
#   mutate(count = str_count(words, "\\w+"))
# bom_df <- bom_df[-1,]
# bom_df["name_codes"] <- names_vector
# 
# bom_df <- left_join(bom_df, name_codes_df)
# 
# # Average word count between Savior names
# mean(bom_df$count)
# 
# plot1 <- bom_df %>%
#   ggplot(aes(x = count)) +
#   geom_histogram() +
#   stat_bin(aes(y=..count.., label=..count..), geom="text", vjust=-.5) %>% 
#   labs(x = "Words between Savior mentions", y = "Count")
# 
# bom_df %>%
#   ggplot(aes(x = names, y = count)) +
#   geom_point(position = "jitter") +
#   theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
#   labs(x = "Savior names", y = "Number of words in after name until next name")
#   ggsave("Case_Study_07/analysis/plot2.png", width = 12)
# 
t <- tableGrob(bom_df %>%
               group_by(names) %>%
               summarise(average_words = mean(count), count = n()))
ggsave("Case_Study_07/analysis/table2.png", t, width = 6, height = 28, limitsize = FALSE)
# 
# ggsave("Case_Study_07/analysis/plot1.png", plot1)

