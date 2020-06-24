temp<-read.csv("C:/Users/mcherrie/Downloads/temp_dec_italymuni.csv")
temp<-subset(temp, select=c("PRO_COM", "median"))
colnames(temp)<-c("PRO_COM", "dec")

temp2<-read.csv("C:/Users/mcherrie/Downloads/temp_jan_italymuni.csv")
temp2<-subset(temp2, select=c("PRO_COM", "median"))
colnames(temp2)<-c("PRO_COM", "jan")

temp3<-read.csv("C:/Users/mcherrie/Downloads/temp_feb_italymuni.csv")
temp3<-subset(temp3, select=c("PRO_COM", "median"))
colnames(temp3)<-c("PRO_COM", "feb")

temp4<-cbind(temp, temp2, temp3)

temp4[,3]<-NULL
temp4[,4]<-NULL

library(dplyr)

temp4<-temp4 %>%
  mutate(meanwintertemp= rowMeans(select(., -PRO_COM), na.rm=T)) %>%
  select(PRO_COM, meanwintertemp)

write.csv(temp4, "C:/Users/mcherrie/Desktop/UV_COVID/UV_covid19_italy/data/italywintertemp.csv", row.names=F)

