# map

covid19sample<-read.csv("Data/FinalSample/UV_COVID_USA_sample.csv")

counties<-read_sf("Data/boundaries/counties/UScounties.shp")

covid19sample$fips<-ifelse(nchar(covid19sample$fips)==4, paste0("0", covid19sample$fips), covid19sample$fips)
covid19sample$FIPS<-as.character(covid19sample$fips)
counties<-merge(counties, covid19sample, by="FIPS")

counties<-counties[counties$STATE_NAME!="Hawaii",]
counties<-counties[counties$STATE_NAME!="Alaska",]

counties$meanUVAJAN01APR30<-counties$meanUVAJAN01APR30*100

pdf("Data/Figures/Figure1a.pdf", width=8, height=5)
plot(counties["meanUVAJAN01APR30"], border=NA, main="")
dev.off()


pdf("Data/Figures/Supplementary1a.pdf", width=8, height=5)
plot(counties["UVvitdyearmeanQ2"], border=NA, main="")
dev.off()

## latitude
counties$Lat = st_coordinates(st_centroid(counties))[,2]
counties$north37<-ifelse(counties$Lat<37,"1","0")
pdf("Data/Figures/Supplementary1b.pdf", width=8, height=5)
plot(counties["north37"], border=NA, main="")
dev.off()

