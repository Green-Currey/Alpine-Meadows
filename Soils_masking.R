library(rgdal)
library(raster)






gye <- readOGR('z:/GIS_data/GYE/GYI_Huc10_OUTLINE/GYE_Huc10_OUTLINE.shp')
taxorder <- raster('z:/gis_data/gye/raster/Soils/gye_taxorder.tif')
taxsuborder <- raster('z:/gis_data/gye/raster/Soils/gye_taxsuborder.tif')


gye2 <- spTransform(gye, CRSobj = crs(taxorder))
taxorder2 <- mask(taxorder, gye2)
taxorder3 <- crop(taxorder2, taxsuborder)

# taxorder3 == 1 for mollisols
# taxsuborder == 1 for cryolls
# taxsuborder == 12 for borolls



rcl <- matrix(c(0, 1, 1, 1, 10, NA), ncol = 3, byrow = T)
rcl

taxorder.rcl <- reclassify(taxorder3, rcl)
plot(taxorder.rcl)

rcl <- matrix(c(-Inf,0.5, NA,
                0.5, 1, 1, 
                1, 11, NA, 
                11, 12, 1, 
                12, 35, NA), ncol = 3, byrow = T)
rcl

taxsuborder.rcl <- reclassify(taxsuborder, rcl)
plot(taxsuborder.rcl)
writeRaster(taxsuborder.rcl, 'z:/GIS_data/GYE/Raster/taxsuborder_mask.tif')



