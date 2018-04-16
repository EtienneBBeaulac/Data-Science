library(leaflet)
library(USAboundaries)
library(buildings)
library(tidyverse)
library(geofacet)
library(sf)
library(sp)
library(geojsonio)
library(maps)

states <- st_as_sf(map("state", fill = TRUE, plot = FALSE))
map.dat <- us_states()
counties <- as(us_counties(),"Spatial")


all.permits <- permits %>%
  filter(variable == "All Permits")

single.family <- permits %>%
  filter(variable == "Single Family", year > 2005) %>% 
  mutate(name = gsub(pattern = " County", replacement = "",x = countyname))

all.multi <- permits %>%
  filter(variable == "All Multifamily")

setwd("Case_Study_11/analysis")

single.family.sum <- single.family %>% 
  group_by(StateAbbr, year) %>% 
  summarize(value = sum(value)) %>% 
  ungroup() %>% 
  filter(year > 2005)

all.permits.sum <- all.permits %>% # summarize sum by state
  group_by(StateAbbr, year) %>% 
  summarize(value = sum(value)) %>% 
  rename(value_all = value) %>% 
  inner_join(single.family.sum, by = c("StateAbbr", "year"))

states <- geojson_read("us-states.geojson", what = "sp")
class(states)

single.family.sum <- single.family.sum %>%
  left_join(map.dat %>% select(name, state_abbr), by = c("StateAbbr" = "state_abbr")) %>% 
  select(name, StateAbbr, value, year)

newobj <- sp::merge(states, single.family.sum, by = "name", duplicateGeoms = TRUE)
countiesobj <- sp::merge(counties, single.family, by = "name", duplicateGeoms = TRUE)
sp.point.df <- split(newobj, newobj$year)
counties.df <- split(countiesobj, countiesobj$year)


m <- leaflet() %>%
  setView(-96, 37.8, 4) %>%
  addTiles()

bins <- c(100, 500, 1000, 2000, 5000, 10000, 20000, 100000, 200000, Inf)

names(sp.point.df) %>%
  purrr::walk( function(df) {
    pal <- colorBin("YlOrRd", domain = sp.point.df[[df]]$value, bins = bins)
    
    m <<- m %>%
      addPolygons(data = sp.point.df[[df]],
                  group = paste(df, "States", sep = " - "),
                  fillColor = ~pal(value),
                  weight = 2,
                  opacity = 1,
                  color = "White",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  popup = sp.point.df[[df]]$name
                  ) 
  })

bins <- c(0, 10, 50, 100, 500, 1000, 5000, 10000, 50000, Inf)

names(counties.df) %>%
  purrr::walk( function(df) {
    pal <- colorBin("YlOrRd", domain = counties.df[[df]]$value, bins = bins)

    m <<- m %>%
      addPolygons(data = counties.df[[df]],
                  # label = ~as.character(value),
                  group = paste(df, "Counties", sep = " - "),
                  fillColor = ~pal(value),
                  weight = 0.7,
                  opacity = 0.7,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  popup = paste(counties.df[[df]]$state_name, paste(counties.df[[df]]$name, "County", sep = " "), sep = " - ")
                  )
  })

m %>% 
  addLayersControl(baseGroups = c(paste(names(sp.point.df), "Counties", sep = " - "), paste(names(sp.point.df), "States", sep = " - ")),
                   options = layersControlOptions(collapsed = FALSE)) 

    
    
  