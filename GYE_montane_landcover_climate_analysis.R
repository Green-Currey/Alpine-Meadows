# Alpine Montane Landcover and Precipitation analysis

rm(list = ls())
cat('\014')

library(raster)
library(rgdal)
library(dplyr)


# Landcover ---------------------------------------------------------------
# For GYE_grass_forest_lc.tif
# Grass/shrubland = 1
# Forest = 2
# Other = 3

# OR

# For GYE_grass_shrub_forest_lc.tif
# Grassland = 1
# Shrubland = 2
# Forest = 3
# Other = 4

montane <- raster('z:/gis_data/gye/Raster/30m_montane_GYE_masked.tif')
montane
plot(montane)

# have to project
lc <- raster('z:/gis_data/gye/Raster/GYE_grass_shrub_forest_LC.tif') %>%
     # project()
     # resample(montane, method = 'ngb')
lc
plot(lc)


montane.lc <- montane*lc
montane.lc
plot(montane.lc)
writeRaster(montane.lc, 'z:/gis_data/gye/Raster/GYE_grass_forest_montane.tif', overwrite = T)


# Precipitation -----------------------------------------------------------

gye <- readOGR('z:/gis_data/gye/Shapefile/GYE_WGS_OUTLINE.shp')
map <- raster('z:/gis_data/climate/wc2.1_30s_bio/wc2.1_30s_bio_12.tif')
map
map.masked <- mask(map, gye)
map.masked <- crop(map.masked, gye)
plot(map.masked)

map.gye <- map.masked %>% 
     resample(montane.lc)
writeRaster(map.gye, 'z:/gis_data/gye/Raster/GYE_MAP_30m.tif', overwrite = T)


map.gye <- raster('z:/gis_data/gye/Raster/GYE_MAP_30m.tif')
map.500 <- map.gye>=500
map.600 <- map.gye>=600

writeRaster(map.500, 'z:/gis_data/gye/Raster/GYE_MAP_500mm.tif', overwrite = T)
writeRaster(map.600, 'z:/gis_data/gye/Raster/GYE_MAP_600mm.tif', overwrite = T)
