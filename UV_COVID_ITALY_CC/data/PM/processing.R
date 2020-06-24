library(velox)
muni <- sf::read_sf("boundaries/Limiti01012019/Com01012019/Com01012019_WGS84.shp")
muni <- sf::st_transform(muni, crs=4326)

AP<-raster::raster("airpollution/GWRwSPEC.HEI_PM25_EU_201601_201612-RH35.nc")


library(velox)
vx <- velox(AP)
fun = function(x) mean(x, na.rm = TRUE)
ex.mat <- vx$extract(muni, fun=fun, small=T)
ex.mat <- as.data.frame(eex.mat)
apforitaly<-cbind(muni$PRO_COM, ex.mat)
colnames(apforitaly)<-c("codcom", "pm2point52016")