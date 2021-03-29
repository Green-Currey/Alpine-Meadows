
# Original reclass --------------------------------------------------------



# Land cover analysis
# Metadata for the NALCMS Landcover data
# The following list describes the display of land cover classification in the .tif file:
# Value 1, Temperate or sub-polar needleleaf forest, RGB 0 61 0;
# Value 2, Sub-polar taiga needleleaf forest, RGB 148 156 112;
# Value 3, Tropical or sub-tropical broadleaf evergreen forest, RGB 0 99 0;
# Value 4, Tropical or sub-tropical broadleaf deciduous forest, RGB 30 171 5;
# Value 5, Temperate or sub-polar broadleaf deciduous forest, RGB 20 140 61;
# Value 6, Mixed forest, RGB 92 117 43;
# Value 7, Tropical or sub-tropical shrubland, RGB 179 158 43;
# Value 8, Temperate or sub-polar shrubland, RGB 179 138 51;
# Value 9, Tropical or sub-tropical grassland, RGB 232 220 94;
# Value 10, Temperate or sub-polar grassland, RGB 225 207 138;
# Value 11, Sub-polar or polar shrubland-lichen-moss, RGB 156 117 84;
# Value 12, Sub-polar or polar grassland-lichen-moss, RGB 186 212 143;
# Value 13, Sub-polar or polar barren-lichen-moss, RGB 64 138 112;
# Value 14, Wetland, RGB 107 163 138;
# Value 15, Cropland, RGB 230 174 102;
# Value 16, Barren lands, RGB 168 171 174;
# Value 17, Urban, RGB 220 33 38;
# Value 18, Water, RGB 76 112 163;
# Value 19, Snow and Ice, RGB 255 250 255.


rm(list = ls())
cat('\014')

library(raster)


GYE.grass.forest <- raster('z:/GIS_data/GYE/Raster/GYE_NALCMS_LC.tif')



GYE.grass.forest[GYE.grass.forest>10] <- 4

GYE.grass.forest[GYE.grass.forest==1] <- 3
GYE.grass.forest[GYE.grass.forest==5] <- 3
GYE.grass.forest[GYE.grass.forest==6] <- 3

GYE.grass.forest[GYE.grass.forest==8] <- 2
GYE.grass.forest[GYE.grass.forest==10] <- 1

plot(GYE.grass.forest)



writeRaster(GYE.grass.forest, 'z:/GIS_data/GYE/Raster/GYE_grass_shrub_forest_LC.tif')

# For GYE_grass_forest_lc.tif
# Grassland = 1
# Forest = 2
# Other = 3

# For GYE_grass_shrub_forest_lc.tif
# Grassland = 1
# Shrubland = 2
# Forest = 3
# Other = 4




# Masking reclass ---------------------------------------------------------

# grass 
veg <- raster('z:/GIS_data/GYE/Raster/GYE_grass_shrub_forest_LC2.tif')
veg

# 1 = grass
# 2 = shrub
# 3 = forest
# 4 = other
rcl <- matrix(c(0,1,1,
                1,4,0), ncol = 3, byrow = T)
rcl
veg.rcl <- reclassify(veg, rcl)
plot(veg.rcl)
writeRaster(veg.rcl, 'z:/gis_data/gye/raster/gye_grass_mask.tif')


# grass shrub
rcl <- matrix(c(0,2,1,
                2,4,0), ncol = 3, byrow = T)
rcl
veg.rcl <- reclassify(veg, rcl)
plot(veg.rcl)
writeRaster(veg.rcl, 'z:/gis_data/gye/raster/gye_grass_shrub_mask.tif')


# grass shrub forest
rcl <- matrix(c(0,3,1,
                3,4,0), ncol = 3, byrow = T)
rcl
veg.rcl <- reclassify(veg, rcl)
plot(veg.rcl)
writeRaster(veg.rcl, 'z:/gis_data/gye/raster/gye_allveg_mask.tif')