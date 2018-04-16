util <- read_csv("https://byuistats.github.io/M335/data/building_utility_values.csv", 
                  col_types = cols(timestamp = col_datetime(format = "%m%.%d%.%Y %H:%M"),
                                   startdate = col_date(format = "%m%.%d%.%Y"),
                                   enddate = col_date(format = "%m%.%d%.%Y")))
# sub_util <- util[grep("water|time|building|date", names(util))]

sub_util <- util %>% 
  select(contains("date"), contains("time"), contains("water"), contains("building")) %>% 
  separate(building_id, c("state", "building_id"), sep = 2) %>% 
  separate(enddate, c("year", "month", "day"), remove = FALSE, sep = "-")

buildings_per_state <- sub_util %>% 
  group_by(state) %>% 
  summarize(build_count = n_distinct(building_id))

sub_util %>% 
  group_by(building_id, month, year, state) %>% 
  filter(!is.na(total_potable_water_gal)) %>% 
  summarize(gallons_time = sum(total_potable_water_gal)) %>% 
  ggplot(aes(x = month, y = gallons_time)) +
  geom_line(aes(col = year))