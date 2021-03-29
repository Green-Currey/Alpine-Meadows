rm(list = ls())
cat('\014')


library(rgdal)
library(raster)


gye <- readOGR('z:/GIS_data/GYE/GYI_Huc10_OUTLINE/GYE_Huc10_OUTLINE.shp')
# taxorder <- raster('z:/gis_data/gye/raster/Soils/gye_taxorder.tif')
taxsuborder <- raster('z:/gis_data/gye/soils/GYE_cryoborolls2.tif'); taxsuborder
# taxsuborder2  <- raster('z:/gis_data/gye/soils/GYE_cryobs.tif')

# For tax order data
# gye2 <- spTransform(gye, CRSobj = crs(taxorder))
# taxorder2 <- mask(taxorder, gye2)
# taxorder3 <- crop(taxorder2, taxsuborder)

# taxorder3 == 1 for mollisols
# taxsuborder == 1 for cryolls
# taxsuborder == 12 for borolls



# rcl <- matrix(c(0, 1, 1, 1, 10, NA), ncol = 3, byrow = T)
# rcl
# 
# taxorder.rcl <- reclassify(taxorder3, rcl)
# plot(taxorder.rcl)

rcl <- matrix(c(0,1,1,
                1,4,1), ncol = 3, byrow = T)
rcl


# rcl2 <- matrix(c(0,1,1,
#                 1,9,0), ncol = 3, byrow = T)
# rcl2

taxsuborder.rcl <- reclassify(taxsuborder, rcl)
# taxsuborder.rcl2 <- reclassify(taxsuborder2, rcl2)
taxsuborder.rcl
plot(taxsuborder.rcl2)
 
# taxsuborder.rcl.wgs <- projectRaster(taxsuborder.rcl,
#                                      crs = '+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs',
#                                      method = 'ngb')
writeRaster(taxsuborder.rcl, 'z:/GIS_data/GYE/Raster/taxsuborder_mask.tif', overwrite = T)
writeRaster(taxsuborder.rcl2, 'z:/GIS_data/GYE/Raster/taxsuborder_mask2.tif', overwrite = T)


