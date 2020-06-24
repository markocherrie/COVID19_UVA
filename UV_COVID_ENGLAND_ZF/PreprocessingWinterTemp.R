# msoa
msoa <- sf::read_sf("boundaries/Middle%20Layer%20Super%20Output%20Areas%20_December%202011_%20Boundaries-shp/Middle%20Layer%20Super%20Output%20Areas%20_December%202011_%20Boundaries.shp")
msoa<-sf::st_transform(msoa, crs=4326)

# temp
library(raster)
temp <- stack("temp8110/tas_hadukgrid_uk_1km_mon-30y_198101-201012.nc", varname="tas")
newproj <- "+proj=longlat +datum=WGS84 +no_defs"
temp <- projectRaster(temp, crs=newproj)
temp[temp>10000000]<-NA

fun = function(x) mean(x, na.rm = TRUE)

master<-msoa$msoa11cd

# extract
for(i in c(12,1,2)){
library(velox)
vx <- velox(temp[[i]])
ex.mat <- vx$extract(msoa, fun=fun, small=T)
ex.mat <- as.data.frame(ex.mat)
master<-cbind(ex.mat, master)
}

colnames(master)<-c("feb","jan","dec", "msoa")

library(dplyr)
master<-master %>%
  mutate(msoa, Meantempwinter = rowMeans(select(., -msoa), na.rm=T)) %>%
  select(msoa, Meantempwinter)

#write.csv(master, "temp8110/wintertempmsoa11.csv", row.names=F)



