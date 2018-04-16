setwd("Case_Study_10/Class_Task_20")
library(sf)
library(fs)
library(tidyverse)
library(downloader)

shp_path <- "https://byuistats.github.io/M335/data/shp.zip"
wells_path <- "https://research.idwr.idaho.gov/gis/Spatial/Wells/WellConstruction/wells.zip"
dams_path <- "https://research.idwr.idaho.gov/gis/Spatial/DamSafety/dam.zip"
rivers_path <- "https://research.idwr.idaho.gov/gis/Spatial/Hydrography/streams_lakes/c_250k/hyd250.zip"

### Read in .shp file
df <- file_temp()
uf <- path_temp("zip")
download(shp_path, df, mode = "wb")
unzip(df, exdir = uf)
map.usa <- read_sf(file.path(uf, "shp"))
file_delete(df)
dir_delete(uf)

#### Read in wells
df <- file_temp()
uf <- path_temp("zip")
download(wells_path, df, mode = "wb")
unzip(df, exdir = uf)
map.well <- read_sf(uf)
file_delete(df)
dir_delete(uf)

#### Read in dams
df <- file_temp()
uf <- path_temp("zip")
download(dams_path, df, mode = "wb")
unzip(df, exdir = uf)
map.dam <- read_sf(uf)
file_delete(df)
dir_delete(uf)

#### Read in rivers
df <- file_temp()
uf <- path_temp("zip")
download(rivers_path, df, mode = "wb")
unzip(df, exdir = uf)
map.water <- read_sf(uf)
file_delete(df)
dir_delete(uf)

map.idaho <- map.usa %>%
  filter(StateName == "Idaho") %>% 
  mutate(county = gsub(' County', '', CntyName))

map.water.idaho <- map.water %>%
  filter(FEAT_NAME == "Snake River" | FEAT_NAME == "Henrys Fork")

map.dam.idaho <- map.dam %>%
  filter(tolower(Source) == "snake river" | tolower(Source) == "henrys fork" & SurfaceAre >= 50)

map.well.idaho <- map.well %>% 
  filter(tolower(CountyName) %in% tolower(map.idaho$county) & Production >= 5000)

my_proj <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=-114 +y_0=44 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"
map.well.idaho_sr <- map.well.idaho %>% st_transform(crs = my_proj)
map.idaho_sr <- map.idaho %>% st_transform(crs = my_proj)
map.water.idaho_sr <- map.water.idaho %>% st_transform(crs = my_proj)
map.dam.idaho_sr <- map.dam.idaho %>% st_transform(crs = my_proj)


ggplot() +
  geom_sf(data = map.idaho_sr, fill = NA, show.legend = 'point', inherit.aes = FALSE, col = 'grey50') +
  geom_sf(data = map.water.idaho_sr %>% filter(FEAT_NAME == "Snake River"), fill = NA, show.legend = 'point', inherit.aes = FALSE, col = 'dodgerblue4', size = 2) +
  geom_sf(data = map.water.idaho_sr %>% filter(FEAT_NAME == "Henrys Fork"), fill = NA, show.legend = 'point', inherit.aes = FALSE, col = 'navyblue', size = 2) +
  geom_sf(data = map.dam.idaho_sr, fill = NA, show.legend = 'point', inherit.aes = FALSE, col = 'darkorchid4') +
  geom_sf(data = map.well.idaho_sr, fill = NA, show.legend = 'point', inherit.aes = FALSE, col = 'red') +
  theme_light() +
  ggsave("plot.png")




