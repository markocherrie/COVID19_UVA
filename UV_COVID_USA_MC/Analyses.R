# If you've run the preprocessing code then 
#covid19sample<-aggregate_pm_census_cdc_test2
# otherwise:
covid19sample<-read.csv("Data/FinalSample/UV_COVID_sample.csv")

#add in humidity
humidity<-read.csv("Data/HealthPop/humidity_county.csv")
covid19sample<-merge(covid19sample, humidity, by.x="fips", by.y="FIPS")

sink("Data/Results/USAresults.txt") 

########## subset to only places that did not have sufficient UV for vitamin D synthesis

covid19sampleunder<-covid19sample[covid19sample$UVvitdyearmeanQ2!=5,]
summary(covid19sampleunder$meanUVAJAN01APR30_100)

library(dplyr)
covid19sample %>%
  group_by(UVvitdyearmeanQ2) %>%
  dplyr::summarize(Min = min(Uvvitdyearmean_10, na.rm=TRUE))

####### UVvitd in the highest category (sufficient all year round) is mean monthly UVvitd of over 165 KJ/m2

####### Descriptive stats

mean(covid19sampleunder$meanUVAJAN01APR30)
sd(covid19sampleunder$meanUVAJAN01APR30)

####### Model

library(glmmTMB)
library(emmeans)

m <- glmmTMB(
  NewDeaths ~  meanUVAJAN01APR30_100
  # air pollution
  + scale(mean_pm25) 
  # other climate
  + scale(mean_winter_temp)
  + scale(mean_winter_rm)
  # demographics
  + scale(pct_blk) + scale(older_pecent) + scale(popdensity) + scale(hispanic)
  # Deprivation
  + scale(PCA1)
  # health care factors
  + scale(statepositivetestsperpop) 
  # urban rural
  + factor(RUCC_2013_CAT)
  # population
  + offset(log(population)) 
  # multilevel
  + (1 | state), 
  
  ziformula = ~  
    # demographics
    + scale(pct_blk) + scale(older_pecent)  + scale(hispanic) + scale(popdensity)
  # Deprivation
  + scale(PCA1)
  # health care factors
  + scale(statepositivetestsperpop) 
  # urban rural
  + factor(RUCC_2013_CAT),
  # family
  family = nbinom2, 
  data = covid19sampleunder
)

## show estimates
m
summary(m)


#### Get mortality rate ratios

confint(m)
exp(confint(m)[2,1])
exp(confint(m)[2,2])
exp(confint(m)[2,3])

#### intraclass correlation coefficient
performance::icc(m)

####### Get the predictions and plots

library(ggplot2)
t<-emmeans(m, c("meanUVAJAN01APR30_100"), at = list(meanUVAJAN01APR30_100 = c(6, 7, 8)), type = "re", offset=c(log(1000000)))

pdf("Data/Figures/Figure2a.pdf", width=8, height=5)
plot(t, by = NULL, horizontal = FALSE, colors = "darkgreen") + theme_bw(base_size = 18) +labs(y= "COVID-19 deaths per million", x = "Mean Daily UVA Jan-Apr 2020 (KJ/m2)")
dev.off()


sink()




