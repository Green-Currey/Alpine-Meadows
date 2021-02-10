
rm(list = ls())
cat('\014')

library(raster)
library(rgdal)
library(dplyr)

# Read in shapefile. This is the basis for the extent of this analysis.
gye <- readOGR('z:/GIS_data/GYE/Shapefile/GYE_WGS_OUTLINE.shp')


# Past processing of rasters ----------------------------------------------

# # Transforming gye shapefile
# gye.wgs <- spTransform(gye, crs(dem))
# writeOGR(gye.wgs, layer = 'GYE outline', dsn = 'f:/GIS_data/GYE/Shapefile/GYE_WGS_OUTLINE.shp', driver = 'ESRI Shapefile')

# # Cropping larger raster layers to GYE extent
# dem <- raster('z:/GIS_data/GYE/Raster/30m_dem_GYE.tif')
# dem.gye <- crop(dem, gye)

# # dem to slope
# writeRaster(terrain(dem, 'slope', 'degrees'), 'z:/GIS_data/GYE/Raster/30m_slope_GYE.tif', overwrite = T)
# slope <- raster('z:/GIS_data/GYE/Raster/30m_slope_GYE.tif')
# slope.gye <- crop(slope, gye)
# LER <- raster('z:/GIS_data/GYE/Raster/1km_LER_GYE.tif')
# ler.gye <- crop(LER, gye) %>% resample(dem.gye, method = 'ngb')

# # Writing cropped raster layers
# writeRaster(dem.gye, 'f:/GIS_data/GYE/Raster/30m_dem_GYE_cropped.tif', overwrite = T)
# writeRaster(slope.gye, 'z:/GIS_data/GYE/Raster/30m_slope_GYE_cropped.tif', overwrite = T)
# writeRaster(ler.gye, 'f:/GIS_data/GYE/Raster/30m_LER_GYE_cropped.tif', overwrite = T)

# Reading in raster data --------------------------------------------------


dem <- raster('z:/GIS_data/GYE/Raster/30m_dem_GYE_cropped.tif')
slope <- raster('z:/GIS_data/GYE/Raster/30m_slope_GYE_cropped.tif')
ler <- raster('z:/GIS_data/GYE/Raster/30m_LER_GYE_cropped.tif')
ler[is.na(ler)] <- 0
d2 <- slope >= 2
d5 <- slope >= 5

# Zonation of tropical mountains ------------------------------------------

# Mountain elevation zones are defined by Kapos et al., 2000
# and based off of strictly elevation (above 2500) or both
# elevation and slope (below 2500). For mountains below 1500,
# a relief filter is applied (called a local elevation range).
# A cell below 1500 is deemed a mountain if LER greater than
# 300. 


# Level 6 is anything greater than 4500m. No where in the GYE meets this criteria
# L6 <- dem >= 4500 
# writeRaster(L6, 'Elevation_Levels/L6.tif', overwrite = T)


# Level 5 is anything less than 4500m but greater than 3500m
L5 <- dem < 4500 & dem >= 3500
# writeRaster(L5, 'z:/GIS_data/gye/raster/Elevation_layers/L5.tif', overwrite = T)


# Level 4 is anything less than 3500m but greater than 2500m
L4 <- dem < 3500 & dem >= 2500
# writeRaster(L4, 'z:/GIS_data/gye/raster/Elevation_layers/L4.tif', overwrite = T)


# Level 3 is anything less than 2500m but greater than 1500m
# with a slope greater than 2 degrees
S3 <- dem < 2500 & dem >= 1500
L3 <- S3 * d2
writeRaster(L3, 'z:/GIS_data/gye/raster/Elevation_layers/L3.tif', overwrite = T)


# Level 2 is anything less than 1500m but greater than 1000m; Nothing meets this criteria in GYE propper
# with a slope greater than 5 degrees or a LER of 300
S2 <- dem < 1500 & dem >= 1000
S2a <- S2 * d5
S2b <- S2 * ler
L2 <- S2a + S2b
L2[L2>0] <- 1
writeRaster(L2, 'z:/GIS_data/gye/raster/Elevation_layers/L2.tif', overwrite = T)



# Level 1 is anything less than 1000 but greater than 300m with an LER of 300. Nothing meets this criteria
# S1 <- dem < 1000 & dem >= 300
# L1 <- S1 * ler
# writeRaster(L1, 'Elevation_Levels/L1_5k.tif', overwrite = T)


gye.montane <- L2 + L3 + L4 + L5 
writeRaster(gye.montane, 'z:/gis_data/gye/Raster/30m_montane_GYE_cropped.tif', overwrite = T)
gye.montane.m <- mask(gye.montane, gye)
writeRaster(gye.montane.m, 'z:/gis_data/gye/Raster/30m_montane_GYE_masked.tif', overwrite = T)
