library(dplyr)
library(readr)
##############################

# run the code here for each month: https://github.com/Scottish-External-Exposome/read_uvr


##############
df <- list.files(path="outputITALY/", full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_cols %>%
  dplyr::select(master, starts_with("2"))

df2<-df[,colnames(df) %in% gsub("-", "",seq(as.Date("2020/01/1"), as.Date("2020/04/30"), "day"))]
colnames(df2)<-as.character(colnames(df2))

###
df2 <- df2 %>%
  mutate(meanUVAJAN01APR30 = rowMeans(., na.rm=T)) 

dfmaster<-as.data.frame(cbind(df$master, df2$meanUVAJAN01APR30))
colnames(dfmaster)<-c("com", "meanUVAJAN01APR30")

write.csv(dfmaster,"outputITALY/meanJAN01APR30ITALY.csv")