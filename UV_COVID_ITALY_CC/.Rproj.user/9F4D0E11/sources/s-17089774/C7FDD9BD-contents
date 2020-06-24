library(sf)
muni<-read_sf("data/boundaries/Com01012019_WGS84.shp")
uv<-read.csv("data/UVJAXA/meanJAN01APR30_ITALY.csv")
muni<-merge(muni, uv, by.x="PRO_COM", by.y="com")

png("data/Figures/Figure1c.png")
plot(muni["meanUVAJAN01APR30"], border=NA, main="")
dev.off()