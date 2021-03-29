
rm(list = ls())
cat('\014')


library(raster)
library(rgdal)
library(dplyr)


setwd('z:/gis_data/')


gye <- readOGR('GYE/GYI_Huc10_OUTLINE/GYE_Huc10_OUTLINE.shp')
gye.lcc <- spTransform(gye, CRSobj = '+proj=lcc +lat_0=42.5 +lon_0=-100 +lat_1=25 +lat_2=60 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs')
files <- list.files(path = 'Climate/daymet/Monthly', pattern = 'prcp', full.names = T)[-c(1:20)]


for(i in seq(length(files))) {
     
     s <- crop(stack(files[i]), gye.lcc)
     year <- unlist(str_split(files[i], '_'))[5] %>% as.numeric
     map <- calc(s, sum)
     
     if (year == 2000) {map.s <- map} else {map.s <- map.s %>% stack(map)}
}

map.clim <- calc(map.s, mean)
writeRaster(map.clim, 'GYE/Raster/GYE_MAP_daymet.tif', overwrite = T)
map600 <- map.clim>=600
writeRaster(map600, 'GYE/Raster/GYE_MAP_600mm_daymet.tif', overwrite = T)
