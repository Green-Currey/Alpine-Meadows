# Masking montane based on MAP and soils ----------------------------------


rm(list = ls())
cat('\014')

library(raster)
library(rgdal)
library(dplyr)

# all should be projected LAEA
gye <- readOGR('z:/gis_data/gye/GYI_Huc10_OUTLINE/GYE_Huc10_OUTLINE.shp')
montane <- raster('z:/gis_data/gye/Raster/Masking_rasters/unprojected/30m_montane_GYE_masked.tif'); montane
soils <- raster('z:/GIS_data/GYE/Raster/Masking_rasters/unprojected/taxsuborder_mask_wgs_resamp3.tif'); soils
MAP <- raster('z:/GIS_data/GYE/Raster/Masking_rasters/unprojected/GYE_MAP600_mask2.tif'); MAP
grass <- raster('z:/GIS_data/GYE/Raster/Masking_rasters/unprojected/gye_grass_mask2.tif'); grass
shrub <- raster('z:/GIS_data/GYE/Raster/Masking_rasters/unprojected/gye_grass_shrub_mask2.tif'); shrub
veg <- raster('z:/GIS_data/GYE/Raster/Masking_rasters/unprojected/gye_allveg_mask2.tif'); veg
area <- raster('z:/gis_data/gye/raster/masking_rasters/unprojected/GYE_area_km2.tif'); area

compareRaster(montane, soils, grass, shrub, veg, MAP, area)



# Masking -----------------------------------------------------------------

mask <- montane + soils + MAP
mask2 <- mask + grass
mask3 <- mask + shrub

# rcl for mask
rcl <- matrix(c(0,2,0,
                2,3,1), ncol = 3, byrow = T)
rcl

mask.rcl <- reclassify(mask, rcl)
writeRaster(mask.rcl, 'z:/gis_data/gye/raster/Masking_rasters/unprojected/Montane_Map600_cryoborolls.tif', overwrite = T)

# rcl for mask 2
rcl2 <- matrix(c(0,3,0,
                 3,4,1), ncol = 3, byrow = T)
rcl2

mask2.rcl <- reclassify(mask2, rcl2)
writeRaster(mask2.rcl, 'z:/gis_data/gye/raster/Masking_rasters/unprojected/Alpine_meadows_mask.tif', overwrite = T)


# rcl for mask 3
rcl2 <- matrix(c(0,3,0,
                 3,4,1), ncol = 3, byrow = T)
rcl2

mask3.rcl <- reclassify(mask3, rcl2)
writeRaster(mask3.rcl, 'z:/gis_data/gye/raster/Masking_rasters/unprojected/Alpine_shrub_mask.tif', overwrite = T)



# area calcs --------------------------------------------------------------


# Montane/soils/MAP
mask.rcl <- raster('z:/gis_data/gye/raster/Masking_rasters/unprojected/Montane_Map600_cryoborolls.tif')
# only grassland meadows
alpMeadows <- raster('z:/gis_data/gye/raster/Masking_rasters/unprojected/Alpine_meadows_mask.tif')
# grassland and shrub meadows
alpMeadows2 <- raster('z:/gis_data/gye/raster/Masking_rasters/unprojected/Alpine_shrub_mask.tif')


# Total GYE area
cellStats(area, sum, na.rm = T)
     # 119,299.7 sq km or 11.9 Mha

# total veg area
cellStats(veg*area, sum, na.rm = T)
     # 104,599.6 sq km or 10.45 Mha

# total montane veg area
montveg <- montane*veg
cellStats(montveg, sum, na.rm = T)
     # 90,626 sq km or 9.6 Mha

# total grass area
cellStats(grass*area, sum, na.rm = T)
     # 23,910.66 sq km or 2.39 Mha

# total grass/shrub area
cellStats(shrub*area, sum, na.rm = T)
     # 71,203.57 sq km or 7.12 Mha

# total alp grassy meadows area
cellStats(alpMeadows*area, sum, na.rm = T)
     # 1985.94 sq km or 0.199 Mha or ~200,000 ha

# total alp shrub meadows area
cellStats(alpMeadows2*area, sum, na.rm = T)
     # 9461.81 sq km or 0.946 Mha or ~ 950,000 ha



cellStats(soils*area, sum, na.rm =T)
cellStats(MAP*area, sum, na.rm =T)
cellStats(montane*area, sum, na.rm =T)
