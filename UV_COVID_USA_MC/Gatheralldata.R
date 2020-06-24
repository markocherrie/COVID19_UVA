# load packages

################################################################################

library("dplyr")
library("pscl")
library("MASS")
library(sf)

###############################################################################

# RUN ALL THE PRE-PROCESSING SCRIPTS
#source("PreprocessingHealth.R")
#source("PreprocessingLongUV.R")
#source("PreprocessingShortUV.R")

###############################################################################

#### Merge short term UVA with health data

UV<-read.csv("Data/UVJAXA/meanUVAJAN01APR30.csv")
UV$fips<-as.numeric(as.character(UV$FIPS))
UV$fips<-ifelse(nchar(UV$fips)==4, paste0("0",UV$fips), UV$fips)
aggregate_pm_census_cdc_test$fips<-ifelse(nchar(aggregate_pm_census_cdc_test$fips)==4, paste0("0",aggregate_pm_census_cdc_test$fips), aggregate_pm_census_cdc_test$fips)
aggregate_pm_census_cdc_test2<-merge(aggregate_pm_census_cdc_test, UV, by="fips", all=T)
aggregate_pm_census_cdc_test2$meanUVAJAN01APR30_100<-aggregate_pm_census_cdc_test2$meanUVAJAN01APR30/100


##########################################################

UVdata2<-read.csv(paste0("Data/2007UV_climat/clim_79-00.VtD.csv"))
UVdata2$fips<-as.numeric(as.character(UVdata2$master))
UVdata2$fips<-ifelse(nchar(UVdata2$fips)==4, paste0("0",UVdata2$fips), UVdata2$fips)

UVdata2 <- UVdata2 %>% mutate(
  yearmean = rowMeans(dplyr::select(., Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec))) %>%
  dplyr::select(fips, yearmean) %>%
  dplyr::mutate_at(vars(yearmean), funs(./10)) %>%
  dplyr::select(fips, yearmean) %>%
  dplyr::rename(UVvitdyearmean=yearmean)


UVdata2 <- UVdata2 %>% mutate(UVvitdyearmeanQ2=as.numeric(gtools::quantcut(UVdata2$UVvitdyearmean, 5)))

#### Merge Long term UVA with health data

aggregate_pm_census_cdc_test2<-merge(aggregate_pm_census_cdc_test2, UVdata2, by="fips")


#### Constructing deprivation principal component scores
agg<-aggregate_pm_census_cdc_test2[,c("poverty", "medianhousevalue", "medhouseholdincome", "pct_owner_occ", "education")]
agg$poverty=1-agg$poverty
agg$education=1-agg$education
agg<-agg[complete.cases(agg),]
agg.pca <- prcomp(agg, center = TRUE, scale. = TRUE)
PCA1<-as.data.frame(agg.pca$x[,1])
aggregate_pm_census_cdc_test2 <- aggregate_pm_census_cdc_test2[complete.cases(aggregate_pm_census_cdc_test2[,c("poverty", "medianhousevalue", "medhouseholdincome", "pct_owner_occ", "education")]),]
aggregate_pm_census_cdc_test2<-cbind(aggregate_pm_census_cdc_test2, PCA1)
names(aggregate_pm_census_cdc_test2)[75]<-"PCA1"

#### State tests 
aggregate_pm_census_cdc_test2<-aggregate_pm_census_cdc_test2 %>%
  dplyr::group_by(Province_State) %>%
  dplyr::mutate(statepop=sum(population))%>%
  dplyr::mutate(positivetestsperpop=(positive/statepop)*100)

#### Urban Rural indicator
URRU<-read.csv("Data/HealthPop/ruralurbancodes2013.csv")
URRU$fips<-as.numeric(as.character(URRU$FIPS))
URRU$fips<-ifelse(nchar(URRU$fips)==4, paste0("0",URRU$fips), URRU$fips)
aggregate_pm_census_cdc_test2<-merge(aggregate_pm_census_cdc_test2,URRU, by="fips")
# Urban and close to metro as 1
aggregate_pm_census_cdc_test2$RUCC_2013_CAT[aggregate_pm_census_cdc_test2$RUCC_2013%in%c(5,7,9)]<-0
aggregate_pm_census_cdc_test2$RUCC_2013_CAT[aggregate_pm_census_cdc_test2$RUCC_2013%in%c(1,2,3,4,6,8)]<-1
