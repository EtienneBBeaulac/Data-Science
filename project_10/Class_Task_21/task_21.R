# library(leaflet)
# library(sf)
# library(fs)
# library(tidyverse)
# library(downloader)
# 
# setwd("Case_Study_11/Class_Task_21")
# 
# shp_path <- "https://byuistats.github.io/M335/data/shp.zip"
# wells_path <- "https://research.idwr.idaho.gov/gis/Spatial/Wells/WellConstruction/wells.zip"
# dams_path <- "https://research.idwr.idaho.gov/gis/Spatial/DamSafety/dam.zip"
# rivers_path <- "https://research.idwr.idaho.gov/gis/Spatial/Hydrography/streams_lakes/c_250k/hyd250.zip"
# 
# ### Read in .shp file
# df <- file_temp()
# uf <- path_temp("zip")
# download(shp_path, df, mode = "wb")
# unzip(df, exdir = uf)
# map.usa <- read_sf(file.path(uf, "shp"))
# file_delete(df)
# dir_delete(uf)
# 
# #### Read in wells
# df <- file_temp()
# uf <- path_temp("zip")
# download(wells_path, df, mode = "wb")
# unzip(df, exdir = uf)
# map.well <- read_sf(uf)
# file_delete(df)
# dir_delete(uf)
# 
# #### Read in dams
# df <- file_temp()
# uf <- path_temp("zip")
# download(dams_path, df, mode = "wb")
# unzip(df, exdir = uf)
# map.dam <- read_sf(uf)
# file_delete(df)
# dir_delete(uf)
# 
# #### Read in rivers
# df <- file_temp()
# uf <- path_temp("zip")
# download(rivers_path, df, mode = "wb")
# unzip(df, exdir = uf)
# map.water <- read_sf(uf)
# file_delete(df)
# dir_delete(uf)
# 
# map.idaho <- map.usa %>%
#   filter(StateName == "Idaho") %>% 
#   mutate(county = gsub(' County', '', CntyName))
# 
# map.water.idaho <- map.water %>%
#   filter(FEAT_NAME == "Snake River" | FEAT_NAME == "Henrys Fork")
# 
# map.dam.idaho <- map.dam %>%
#   filter(tolower(Source) == "snake river" | tolower(Source) == "henrys fork" & SurfaceAre >= 50)
# 
# map.well.idaho <- map.well %>% 
#   filter(tolower(CountyName) %in% tolower(map.idaho$county) & Production >= 5000)


# m <- map.idaho %>% 
#   leaflet() %>% 
#   setView(-114.7420, 44.0682, zoom = 6) %>% 
#   addTiles() 
#   # addCircles(map.dam.idaho$geometry, )

# library(USAboundaries)
# library(ggrepel)
# library(sf)
# library(ggplot2)
# library(maps)
# library(tidyverse)
# 
# states <- us_states() %>%
#   filter(name != 'Hawaii', name != 'Alaska', stusps != 'PR')
# 
# cities <- us_cities()
# biggest_cities <- cities %>%
#   group_by(state) %>%
#   arrange(desc(population)) %>% 
#   top_n(n = 3, wt = population) %>%
#   mutate(count = 1, n = cumsum(count)) %>% 
#   ungroup() %>% 
#   filter(state != 'AK', state != 'HI')

biggest_cities %>% 
  leaflet() %>% 
  setView(-95.7129, 37.0902, zoom = 4) %>% 
  addTiles() %>% 
  addCircles(lng = ~lon, lat = ~lat, weight = 1, radius = ~sqrt(population) * 30, popup = ~city)
  
