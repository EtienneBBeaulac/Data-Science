# library(buildings)
# library(tidyverse)
# library(dplyr)
# library(ggplot2)
# library(zoo)
# library(ggpubr)
# 
# climate_dat <- climate_zone_fips
# buildings_dat <- buildings0809
# resto_dat <- restaurants
# 
# not_restaurants <- c("development","Food preperation center", "Food Services center","bakery","Grocery","conceession","Cafeteria", "lunchroom","school","facility"," hall ","room","deli","alexander")
# standalone_retail <- c("Wine","Spirits","Liquor","Convenience","drugstore","Flying J", "Rite Aid ","walgreen ","Love's Travel ", "retail")
# full_service_type <- c("Ristorante","mexican","pizza ","steakhouse"," grill ","buffet","tavern"," bar ","waffle","italian","steak house","tuscanos","souper")
# quick_service_type <- c("coffee"," java "," Donut ","Doughnut"," burger ","Ice Cream ","custard ","sandwich ","fast food "," bagel ", "drive", "tater")
# quick_service_names <- restaurants$Restaurant[restaurants$Type %in% c("coffee","Ice Cream","Fast Food")]
# full_service_names <- restaurants$Restaurant[restaurants$Type %in% c("Pizza","Casual Dining","Fast Casual")]
# 
# #left_join buildings0809 with cliamte_zone_fips
# dat <- left_join(buildings_dat, climate_dat, by = c("FIPS.state", "FIPS.county"))
# dat_new <- dat %>%
#   filter(Type == "Food_Beverage_Service") %>%
#   mutate(date = as.Date(as.yearmon(paste(Month, Year, sep = "-"), "%m-%Y")),
#          low_ProjectTitle = str_to_lower(gsub("'", '', ProjectTitle)),
#          subgroups = case_when(grepl(paste(str_to_lower(str_trim(gsub("'", '', full_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Full Service Restaurants",
#                                grepl(paste(str_to_lower(str_trim(gsub("'", '', quick_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Quick Service Restaurants",
#                                grepl(paste(str_to_lower(str_trim(quick_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Quick Service Restaurants",
#                                grepl(paste(str_to_lower(str_trim(full_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Full Service Restaurants",
#                                grepl(paste(str_to_lower(str_trim(standalone_retail, side = "both")), collapse="|"), low_ProjectTitle) ~ "Standalone Retail",
#                                grepl(paste(str_to_lower(str_trim(not_restaurants, side = "both")), collapse="|"), low_ProjectTitle) ~ "Not Restaurants",
#                                grepl(".estaurant.*", low_ProjectTitle) & SqFt < 4000 ~ "Quick Service Restaurants",
#                                grepl(".estaurant.*", low_ProjectTitle) & SqFt >= 4000 ~ "Full Service Restaurants"))
# 
# pd <- position_dodge(0.4)
# dat_new$county_f <- factor(dat_new$County.y, levels = c('Ada ID', 'Kootenai ID', 'Canyon ID', 'Bannock ID', 'Blaine ID', 'Twin Falls ID', 'Bonner ID', 'Bonneville ID'))
# 
# dat_new %>%
#   filter(subgroups == "Full Service Restaurants" | subgroups == "Quick Service Restaurants") %>%
#   group_by(subgroups, date, county_f) %>%
#   summarise(count = n()) %>%
#   ggplot(aes(x = date, y = count, col = subgroups)) +
#   geom_point(position = pd, size = 2) +
#   geom_line(position = pd) +
#   theme(axis.text.x = element_text(angle = 90)) +
#   labs(title = "Full-service vs. quick-service restaurant construction per county in Idaho", col = "Category", y = "Number of restaurants built", x = "Month") +
#   facet_wrap(~ county_f, ncol = 4) +
#   ggsave("Case_Study_06/analysis/q1.png", height = 6, width = 12)
# 
# dat_new <- dat %>%
#   mutate(date = as.Date(as.yearmon(paste(Month, Year, sep = "-"), "%m-%Y")),
#          low_ProjectTitle = str_to_lower(gsub("'", '', ProjectTitle)),
#          subgroups = case_when(grepl(paste(str_to_lower(str_trim(gsub("'", '', full_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Restaurant",
#                                grepl(paste(str_to_lower(str_trim(gsub("'", '', quick_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Restaurant",
#                                grepl(paste(str_to_lower(str_trim(quick_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Restaurant",
#                                grepl(paste(str_to_lower(str_trim(full_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Restaurant",
#                                grepl(paste(str_to_lower(str_trim(standalone_retail, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
#                                grepl(paste(str_to_lower(str_trim(not_restaurants, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
#                                grepl(".estaurant.*", low_ProjectTitle) & SqFt < 4000 ~ "Restaurant",
#                                grepl(".estaurant.*", low_ProjectTitle) & SqFt >= 4000 ~ "Restaurant",
#                                TRUE ~ "Other"))
# 
# pd <- position_dodge(0.4)
# 
# plot1 <- dat_new %>%
#   group_by(subgroups, date) %>%
#   summarise(count = n()) %>%
#   ggplot(aes(x = date, y = count, col = subgroups)) +
#   geom_point(position = pd, size = 2) +
#   geom_smooth(position = pd) +
#   theme(axis.text.x = element_text(angle = 90)) +
#   scale_x_date(date_labels="%b %y",date_breaks  ="1 month") +
#   labs(col = "Category", y = "Construction count", x = "Month")
# 
# plot2 <- dat_new %>%
#   group_by(subgroups, date) %>%
#   summarise(count = n()) %>%
#   ggplot(aes(x = date, y = log10(count), col = subgroups)) +
#   geom_point(position = pd, size = 2) +
#   geom_smooth(position = pd) +
#   theme(axis.text.x = element_text(angle = 90)) +
#   scale_x_date(date_labels="%b %y",date_breaks  ="1 month") +
#   labs(col = "Category", y = "Construction count normalized", x = "Month")
# 
# ggarrange(plot1, plot2, common.legend = TRUE) %>%
#   annotate_figure(top = text_grob("Restaurant vs. other commercial construction during 2008-2009 in Idaho", color = "red", face = "bold", size = 14)) +
#   ggsave("Case_Study_06/analysis/q2.png", width = 12)

# dat_new <- dat %>%
#   filter(Type == "Food_Beverage_Service") %>%
#   mutate(date = as.Date(as.yearmon(paste(Month, Year, sep = "-"), "%m-%Y")),
#          low_ProjectTitle = str_to_lower(gsub("'", '', ProjectTitle)),
#          subgroups = case_when(grepl(paste(str_to_lower(str_trim(gsub("'", '', full_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
#                                grepl(paste(str_to_lower(str_trim(gsub("'", '', quick_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Fast Food",
#                                grepl(paste(str_to_lower(str_trim(quick_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Fast Food",
#                                grepl(paste(str_to_lower(str_trim(full_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
#                                grepl(paste(str_to_lower(str_trim(standalone_retail, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
#                                grepl(paste(str_to_lower(str_trim(not_restaurants, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
#                                grepl(".estaurant.*", low_ProjectTitle) & SqFt < 4000 ~ "Fast Food",
#                                grepl(".estaurant.*", low_ProjectTitle) & SqFt >= 4000 ~ "Other")) %>%
#   filter(subgroups == "Fast Food") %>%
#   complete(County.y, Year) %>%
#   replace_na(list(Value1000 = 0))
# 
# myplots <- lapply(split(dat_new, dat_new$Year), function(x){
#   if (unique(x$Year) == "2008") {
#     x$county_f <- factor(x$County.y, levels = c('Ada ID', 'Kootenai ID', 'Canyon ID', 'Bannock ID', 'Bonner ID', 'Blaine ID', 'Twin Falls ID'))
#   } else {
#     x$county_f <- factor(x$County.y, levels = c('Ada ID', 'Canyon ID', 'Blaine ID', 'Kootenai ID', 'Bannock ID', 'Twin Falls ID', 'Bonner ID'))
#   }
# 
#   sum_dat <- x %>%
#     group_by(Year, county_f) %>%
#     summarise(cost = sum(Value1000)) %>%
#     ungroup() %>%
#     arrange(desc(cost)) %>%
#     mutate(ordered_id = 1:n())
# 
#   x %>%
#     ggplot(aes(x = county_f, y = Value1000, col = county_f)) +
#     geom_point(size = 4) +
#     geom_point(data = sum_dat, size = 6, shape = 1, aes(y = cost)) +
#     labs(x = "County", y = "Expenditure per 1k", title = unique(x$Year), col = "County", subtitle = "Empty circle denotes total expenditure") +
#     ylim(0, 2500)
# })
# 
# library(gridExtra)
# 
# plot <- do.call(grid.arrange, c(myplots, ncol = 2))


dat_new <- dat %>%
  filter(County.y == "Ada ID") %>%
  mutate(date = as.Date(as.yearmon(paste(Month, Year, sep = "-"), "%m-%Y")),
         low_ProjectTitle = str_to_lower(gsub("'", '', ProjectTitle)),
         subgroups = case_when(grepl(paste(str_to_lower(str_trim(gsub("'", '', full_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
                               grepl(paste(str_to_lower(str_trim(gsub("'", '', quick_service_names), side = "both")), collapse="|"), low_ProjectTitle) ~ "Fast Food",
                               grepl(paste(str_to_lower(str_trim(quick_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Fast Food",
                               grepl(paste(str_to_lower(str_trim(full_service_type, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
                               grepl(paste(str_to_lower(str_trim(standalone_retail, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
                               grepl(paste(str_to_lower(str_trim(not_restaurants, side = "both")), collapse="|"), low_ProjectTitle) ~ "Other",
                               grepl(".estaurant.*", low_ProjectTitle) & SqFt < 4000 ~ "Fast Food",
                               grepl(".estaurant.*", low_ProjectTitle) & SqFt >= 4000 ~ "Other",
                               TRUE ~ "Other"))

pd <- position_dodge(0.4)

plot1 <- dat_new %>%
  group_by(subgroups, date) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = date, y = count, col = subgroups)) +
  geom_point(size = 2) +
  geom_smooth() +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_x_date(date_labels="%b %y",date_breaks  ="1 month") +
  labs(col = "Category", y = "Construction count", x = "Month")

plot2 <- dat_new %>%
  group_by(subgroups, date) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = date, y = log10(count), col = subgroups)) +
  geom_point(size = 2) +
  geom_smooth() +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_x_date(date_labels="%b %y",date_breaks  ="1 month") +
  labs(col = "Category", y = "Construction count normalized", x = "Month")

ggarrange(plot1, plot2, common.legend = TRUE) %>%
  annotate_figure(top = text_grob("Fast-food vs. other commercial construction in Ada county during 2008-2009 in Idaho", color = "red", face = "bold", size = 14)) +
  ggsave("Case_Study_06/analysis/q4.png", width = 12)
