# library(rio)
# library(tidyverse)
# library(dplyr)
# library(ggplot2)
# library(haven)
# library(foreign)
# library(measurements)
# 
# tubingen_height = openxlsx::read.xlsx(xlsxFile = "https://byuistats.github.io/M335/data/heights/Height.xlsx", startRow = 3, colNames = TRUE, rowNames = FALSE, skipEmptyRows = TRUE, skipEmptyCols = TRUE)
# bavaria_conscr = read_dta("https://byuistats.github.io/M335/data/heights/germanconscr.dta")
# bavaria_prison = read_dta("https://byuistats.github.io/M335/data/heights/germanprison.dta")
# bavaria_se = read.dbf("Case_Study_05/analysis/B6090.DBF")
# bls = read_csv("https://github.com/hadley/r4ds/raw/master/data/heights.csv")
# national = read.spss("http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav", to.data.frame=TRUE)
# 
# 
# tubingen_dat <- tubingen_height %>%
#   select(Code, `Continent,.Region,.Country`, ends_with("0"), -`1800`, -`2010`) %>%
#   rename(region = `Continent,.Region,.Country`, code = Code) %>%
#   gather(year, height, 3:20) %>%
#   filter(!is.na(height)) %>%
#   separate(year, c("century", "decade_year"), remove = FALSE, sep = 2) %>%
#   rename(year_full = year, height.cm = height) %>%
#   separate(decade_year, c("decade", "year"), sep = 1) %>%
#   mutate(height.in = conv_unit(height.cm, "cm", "inch"))
# 
# bavaria_conscr_dat <- bavaria_conscr %>%
#   select(-co, -age, -gebger) %>%
#   rename(birth_year = bdec, height.cm = height) %>%
#   mutate(height.in = conv_unit(height.cm, "cm", "inch")) %>%
#   mutate(birth_year = as.numeric(birth_year)) %>%
#   mutate(study_id = "b19")
# 
# bavaria_prison_dat <- bavaria_prison %>%
#   select(-co, -age) %>%
#   rename(birth_year = bdec, height.cm = height) %>%
#   mutate(height.in = conv_unit(height.cm, "cm", "inch")) %>%
#   mutate(birth_year = as.numeric(birth_year)) %>%
#   mutate(study_id = "g18")
# 
# 
# bavaria_se_dat <- bavaria_se %>%
#   select(GEBJ, CMETER) %>%
#   rename(birth_year = GEBJ, height.cm = CMETER) %>%
#   mutate(height.cm = as.numeric(height.cm), height.in = conv_unit(height.cm, "cm", "inch")) %>%
#   mutate(birth_year = as.numeric(birth_year)) %>%
#   mutate(study_id = "g19")
# 
# 
# bls_dat <- bls %>%
#   select(height) %>%
#   rename(height.in = height) %>%
#   mutate(birth_year = 1950, height.cm = conv_unit(height.in, "inch", "cm")) %>%
#   mutate(birth_year = as.numeric(birth_year)) %>%
#   mutate(study_id = "us20")
# 
# 
# national_dat <- national %>%
#   select(DOBY, RT216I, RT216F) %>%
#   rename(birth_year = DOBY, height.in = RT216I, height.ft = RT216F) %>%
#   mutate(birth_year = paste(19, birth_year, sep = ""),
#          height.cm = conv_unit(height.in, "inch", "cm") + conv_unit(height.ft, "ft", "cm"),
#          height.in = height.in + conv_unit(height.ft, "ft", "cm")) %>%
#   mutate(birth_year = as.numeric(birth_year)) %>%
#   filter(!is.na(birth_year)) %>%
#   mutate(study_id = "w20") %>%
#   select(-height.ft)
# 
# 
# complete_dat <- bind_rows(bavaria_conscr_dat, bavaria_prison_dat, bavaria_se_dat, bls_dat, national_dat)
# 
# 
# saveRDS(complete_dat, "Case_Study_05/analysis/row_combined.rds")
# saveRDS(tubingen_dat, "Case_Study_05/analysis/world_country_est.rds")
# tubingen_dat.ger <- tubingen_dat %>%
#   filter(region == "Germany")
# 
# tubingen_dat %>%
#   ggplot(aes(x = year_full, y = height.in, shape = century)) +
#   geom_point(alpha = 0.5, aes(col = "Other")) +
#   geom_point(data = tubingen_dat.ger, aes(col = region), size = 3) +
#   geom_line(data = tubingen_dat.ger, aes(group = 1)) +
#   labs(title = "Heights in Germany and the World", x = "Year", y = "Height inches", col = "Region", shape = "Century") +
#   theme(legend.position = "top") +
#   scale_color_manual(values=c('black','grey')) +
#   ggsave("Case_Study_05/analysis/germ_heights.png", width = 10)
# 
# ordered_dat <- complete_dat %>%
#   filter(birth_year > 1500) %>%
#   group_by(study_id) %>%
#   arrange(birth_year) %>%
#   summarise(min_year = min(birth_year))

medians <- complete_dat %>%
  filter(birth_year > 1500 & height.cm < 300 & height.cm > 0 & study_id != "") %>%
  group_by(study_id, birth_year) %>%
  summarise(height.median = median(height.cm))

complete_dat$study_id_f <- factor(complete_dat$study_id, levels = c('g19', 'g18', 'b19', 'us20', 'w20'))

complete_dat %>%
  filter(birth_year > 1500 & height.cm < 220 & height.cm > 0) %>%
  ggplot() +
  geom_jitter(aes(x = birth_year, y = height.cm, col = study_id), alpha = 0.2) +
  geom_smooth(data = medians, aes(x = birth_year, y = height.median)) +
  labs(title = "Height over the centuries", x = "Year", y = "Height in cm", col = "Study ID") +
  facet_grid(~study_id_f) +
  ggsave("Case_Study_05/analysis/height_new.png", width = 12)
# 
# geom_boxplot() +
# scale_x_continuous(limits = c(1710, 1990)) +
# scale_y_continuous(limits = c(150, 180)) +
# facet_grid(~study_id)

# complete_dat %>% 
#   mutate(decades = case_when(birth_year < 1710 ~ 1710, birth_year < 1720 ~ 1720, birth_year < 1730 ~ 1730,
#                              birth_year < 1740 ~ 1740, birth_year < 1750 ~ 1750, birth_year < 1760 ~ 1760,
#                              birth_year < 1770 ~ 1770, birth_year < 1780 ~ 1780, birth_year < 1790 ~ 1790,
#                              birth_year < 1800 ~ 1800, birth_year < 1810 ~ 1810, birth_year < 1820 ~ 1820,
#                              birth_year < 1830 ~ 1830, birth_year < 1840 ~ 1840, birth_year < 1850 ~ 1850,
#                              birth_year < 1870 ~ 1870, birth_year < 1880 ~ 1880, birth_year < 1890 ~ 1890,
#                              birth_year < 1900 ~ 1900, birth_year < 1910 ~ 1910, birth_year < 1920 ~ 1920,
#                              birth_year < 1930 ~ 1930, birth_year < 1940 ~ 1940, birth_year < 1950 ~ 1950,
#                              birth_year < 1960 ~ 1960, birth_year < 1970 ~ 1970, birth_year < 1980 ~ 1980,
#                              birth_year < 1990 ~ 1990)) %>% 
#   group_by(decades, study_id) %>% 
#   summarise(mean.height = mean(height.cm)) %>% 
#   ggplot(aes(x = decades, y = mean.height, col = study_id)) +
#   geom_point(position = "jitter") +
#   scale_x_continuous(limits = c(1710, 1990)) +
#   scale_y_continuous(limits = c(160, 180))
# 
# 
# complete_dat %>% 
#   filter(birth_year > 1600) %>% 
#   mutate(decades = case_when(birth_year < 1710 ~ 1710, birth_year < 1720 ~ 1720, birth_year < 1730 ~ 1730,
#                              birth_year < 1740 ~ 1740, birth_year < 1750 ~ 1750, birth_year < 1760 ~ 1760,
#                              birth_year < 1770 ~ 1770, birth_year < 1780 ~ 1780, birth_year < 1790 ~ 1790,
#                              birth_year < 1800 ~ 1800, birth_year < 1810 ~ 1810, birth_year < 1820 ~ 1820,
#                              birth_year < 1830 ~ 1830, birth_year < 1840 ~ 1840, birth_year < 1850 ~ 1850,
#                              birth_year < 1870 ~ 1870, birth_year < 1880 ~ 1880, birth_year < 1890 ~ 1890,
#                              birth_year < 1900 ~ 1900, birth_year < 1910 ~ 1910, birth_year < 1920 ~ 1920,
#                              birth_year < 1930 ~ 1930, birth_year < 1940 ~ 1940, birth_year < 1950 ~ 1950,
#                              birth_year < 1960 ~ 1960, birth_year < 1970 ~ 1970, birth_year < 1980 ~ 1980,
#                              birth_year < 1990 ~ 1990)) %>%
#   group_by(decades, study_id) %>% 
#   summarise(median.height = median(height.cm)) %>% 
#   ggplot(aes(x = decades, y = median.height, col = study_id)) +
#   geom_point(position = "jitter", size = 3) +
#   facet_wrap(~study_id) +
#   labs(title = "Median height over the centuries", x = "Year", y = "Median height in cm", col = "Study ID") +
#   guides(col = FALSE) +
#   ggsave("Case_Study_05/analysis/height.png")
