library(dplyr)
library(readr)

# run the code here for each month: https://github.com/Scottish-External-Exposome/read_uvr

#######################
df <- list.files(path="outputUKmsoa11/", full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_cols %>%
  dplyr::select(master, starts_with("2"))

df2<-df[,colnames(df) %in% gsub("-", "",seq(as.Date("2020/01/1"), as.Date("2020/04/17"), "day"))]
colnames(df2)<-as.character(colnames(df2))

df2 <- df2 %>%
  mutate(meanUVAJAN01APR17 = rowMeans(., na.rm=T)) 

dfmaster<-as.data.frame(cbind(df$master, df2$meanUVAJAN01APR17))
colnames(dfmaster)<-c("msoa", "meanUVAJAN01APR17")

write.csv(dfmaster,"data/UVJAXA/meanUVAJAN01APR17_ENGLAND.csv")
