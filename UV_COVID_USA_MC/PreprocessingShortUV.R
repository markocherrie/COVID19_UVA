# usa
library(sf)
counties <- sf::read_sf("Data/boundaries/counties/UScounties.shp")
counties <- sf::st_transform(counties, crs=4326)


#devtools::install_url('https://cran.r-project.org/src/contrib/Archive/velox/velox_0.2.0.tar.gz')

# run the code here for each month: https://github.com/Scottish-External-Exposome/read_uvr

library(raster)
library(dplyr)

fun = function(x) mean(x, na.rm = TRUE)

processUV <-function(dir){
  files<- list.files(dir, full.names = T)
  library(velox)
  master<-counties$FIPS
  for(i in files){
    testmaster<-raster(i, varname="uva")
    vx <- velox(testmaster)
    ex.mat <- vx$extract(counties, fun=fun, small=T)
    ex.mat <- as.data.frame(ex.mat)
    colnames(ex.mat)<-substr(i, 8, 15)
    ex.mat[,1]<-(ex.mat[,1]*86400)/1000
    master<-cbind(ex.mat, master)
  }
  write.csv(master, paste0("output/", gsub("/", "", dir), ".csv"))
}

processUV("2020/1")
processUV("2020/2")
processUV("2020/3")
processUV("2020/4")

# create the summary measures
library(dplyr)
library(readr)

df <- list.files(path="output/", full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_cols %>%
  dplyr::select(master, starts_with("2"))

df2<-df[,colnames(df) %in% c("master",gsub("-", "",seq(as.Date("2020/01/1"), as.Date("2020/04/30"), "day")))]
colnames(df2)<-as.character(colnames(df2))

df2<-df2 %>%
  mutate(master, meanUVAJAN01APR30 = rowMeans(select(., -master), na.rm=T)) %>%
  select(master, meanUVAJAN01APR30)

df2<-df2[which(rowMeans(!is.na(df2)) > 0.90), ]

dfmaster<-as.data.frame(cbind(df$master, df2$meanUVAJAN01APR30))
colnames(dfmaster)<-c("county", "meanUVAJAN01APR30")
dfmaster$meanUVAJAN01APR30<-as.numeric(as.character(dfmaster$meanUVAJAN01APR30))

write.csv(dfmaster,"Data/UVJAXA/meanUVAJAN01APR30.csv")



