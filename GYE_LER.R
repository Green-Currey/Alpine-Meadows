# LER analysis ------------------------------------------------------------

library(raster)
library(dplyr)
dem <- raster('z:/gis_data/GYE/Raster/30m_dem_GYE.tif')
dem <- aggregate(dem, fact = 33.333, fun = mean)
dem
# plot(dem)
# global.mat2 <- global.mat[2000:2300, 25000:25300]
dem.mat <- dem %>% as.matrix()

# LER is a 10 sq km window that checks for a relief of 300m
# around each cell. If 300m of relief is found within the LER window, the cell
# is deemed a mountain.

# number of cells to check distance from edge
cells <- 5


for (i in seq(nrow(dem.mat))) {
     for (j in seq(ncol(dem.mat))) {
          
          if (is.na(dem.mat[i,j])) {global.mat2[i,j] <- NA
          
          } else {
               
               # this section of logical statements checks for the edges
               # of the map and adjusts the LER window
               if (i < cells) {i.seq <- i:(i+cells)
               } else if (i > nrow(dem.mat)-cells) {i.seq <- (i-cells):nrow(dem.mat)
               } else {i.seq <- (i-cells):(i+cells)
               }
               
               
               if (j < cells) {j.seq <- j:(j+cells)
               } else if (j > ncol(dem.mat)-cells) {(j-cells):ncol(dem.mat)
               } else {j.seq <- (j-cells):(j+cells)
               }
               
               LER <- dem.mat[i.seq, j.seq]
               
               if (sum(is.na(LER)) == (nrow(LER)*ncol(LER))) {LER.gye[i,j] <- NA} else {relief <- dem.mat[i,j] - min(LER, na.rm = T)}
               
               
               if (relief >= 300) {LER.gye[i,j] <- 1} else {LER.gye[i,j] <- NA}
          }
     }
}

write.csv(LER.gye, 'z:/gis_data/GYE/LER_GYE.csv')