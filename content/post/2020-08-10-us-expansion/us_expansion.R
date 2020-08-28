library(USAboundaries)
library(dplyr)
library(ggplot2)
library(gganimate)
library(tigris)
library(sf)
library(ggspatial)
library(viridis)
options(tigris_class = "sf")
options(gganimate.dev_args = list(width = 700, height = 600))

albers_projection <- paste0(
  "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 ",
  "+lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 ",
  "+datum=NAD83 +units=m +no_defs"
)

states_us <- state_codes$state_name[-c(52:69)]
continental_us <- state_codes$state_name[-c(2, 12, 52:69)]


#dates <- seq(as.Date("1820-09-03"), as.Date("1860-12-31"), by = "years")
dates <- seq(as.Date("1783-09-03"), as.Date("2000-12-31"), by = "years")
maps <- lapply(dates, function(date) {
  map <- us_states(map_date = date, resolution = "high",
                   states = continental_us)
  map$states <- TRUE
  map$year <- date
  map
}) %>%
  bind_rows()

historical_events <- function(frame) {
  year <- 1783 + (frame - 1)
  event <- case_when(
    year <= 1803 ~ "Organization of territory after Revolutionary War",
    year <= 1819 ~ "Purchase of Louisiana and Spanish Cession",
    year <= 1845 ~ "Northwest expansion (inc. Trial of Tears)",
    year <= 1861 ~ "Mexican-American War and Southwest expansion",
    year <= 1865 ~ "Civil War",
    year <= 1897 ~ "Reconstruction and western statehood",
    year <= 1945 ~ "Pacific and Caribbean expansion (not included)",
    year <= 2000 ~ "Present day"
  )
  return(event)
}

alaska <- ggplot(data = filter(maps, name == "Alaska")) +
  geom_sf(color = "black", aes(fill = terr_type)) +
  coord_sf(crs = st_crs(3467), xlim = c(-2400000, 1600000),
           ylim = c(200000, 2500000), expand = FALSE, datum = NA)

hawaii  <- ggplot(data = filter(maps, name == "Hawaii")) +
  geom_sf(color = "black", aes(fill = terr_type)) + 
  coord_sf(crs = st_crs(4135),
           xlim = c(-161, -154), ylim = c(18,23),
           expand = FALSE, datum = NA)


usa <- filter(maps, year == "2000-9-3")
usa$geometry <- st_union(usa)
usa <- slice(usa, 1)
usa[,-length(colnames(usa))] = NA
usa[nrow(usa)+length(dates)-1,] <- NA
usa$year <- dates
usa$geometry <- usa$geometry[1]
usa$states <- FALSE
usa$terr_type <- if

maps <- bind_rows(maps, usa) 

animated_map <- ggplot(maps) +
  geom_sf(aes(color = states, fill = terr_type)) +
  coord_sf(crs = albers_projection) +
  theme_bw() +
  transition_manual(year) +
  labs(
    title = "United States ({1783 + (frame - 1)})",
    subtitle = "{historical_events(frame)}",
    caption = paste(
      "Continental US (48 states); Data from Newberry",
      "Library’s Atlas of Historical County Boundaries,"
    )
  ) +
  annotation_north_arrow(
    location = "bl", which_north = "true",
    pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  scale_color_manual(values = c("grey", "black")) +
  guides(fill = guide_legend(title = "Territory Type"),
         color = FALSE)

gif <- animate(animated_map, renderer = gifski_renderer(),
               nframes = length(dates), duration = 75) 
anim_save("us_expansion.gif", gif)


featured <- filter(maps, year=="2000-09-03") %>%
  ggplot() +
  geom_sf(color = "black", aes(fill = name)) +
  coord_sf(crs = albers_projection) +
  theme_bw() +
  labs(title = "United States of America") +
  guides(fill = FALSE)


