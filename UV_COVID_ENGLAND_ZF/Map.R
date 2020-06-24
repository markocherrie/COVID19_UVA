
############# map
covid19<-read.csv("data/FinalSample/covid19withUV.csv")
msoas<-sf::read_sf("data/boundaries/Middle_20Layer_20Super_20Output_20Areas_20_December_202011__20Boundaries-shp/Middle_20Layer_20Super_20Output_20Areas_20_December_202011__20Boundaries.shp")
msoas<- merge(msoas, covid19, by="msoa11cd")


############# maps

msoas<-msoas[grep("^E", msoas$msoa11cd), ]
png("data/Figures/Figure1b.png")
plot(msoas["meanUVAJAN01APR17"], border=NA, main="")
dev.off()
