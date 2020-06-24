#####################################################
### zinb covid 19 model 
### zf May 2020 ###

library("dplyr")
library("MASS")
library(NBZIMM)

covid19 <- read.csv("data/FinalSample/covid19_msoa4r.csv")

####################

newuv<-read.csv("data/UVJAXA/meanUVAJAN01APR17_ENGLAND.csv")
covid19<-merge(covid19, newuv, by.x="msoa11cd", by.y="msoa")
covid19$meanUVAJAN01APR17_100<-covid19$meanUVAJAN01APR17/100

newtemp<-read.csv("data/WinterTempMO/englandlongtermwintertemp.csv")
covid19<-merge(covid19, newtemp, by.x="msoa11cd", by.y="msoa")

sink("data/Results/Englandresults.txt") 

###########################################################################
 
library(glmmTMB)
library(emmeans)

m <- glmmTMB(
  covid19 ~  
  meanUVAJAN01APR17
  + scale(pm251418)
  + scale(Meantempwinter)
  + scale(p80up) 
  + scale(p6579) 
  + scale(pblack) 
  + scale(pindian)  
  + scale(ppakbang) 
  + scale(pchinese) 
  + scale(incomescore19) 
  + scale(higheredu) 
  + scale(pcarehm)  
  + scale(countDays) 
  # population
  + offset(log(allpop))
  + (1 | utla), 
  
  ziformula = ~ 
    scale(p80up) 
  + scale(p6579) 
  + scale(p5064)  
  + scale(pblack)  
  + scale(pindian)   
  + scale(ppakbang) 
  + scale(pchinese)  
  + scale(incomescore19)
  + scale(pcarehm)  
  + scale(pbus)
  + scale(ptrain)
  + scale(ptube)
  + scale(personkm2)
  + scale(countDays),
  
  family= nbinom2, 
  data = covid19
)

summary(m)
confint(m)
exp(confint(m)[2,1]*100)
exp(confint(m)[2,2]*100)
exp(confint(m)[2,3]*100)

mean(covid19$meanUVAJAN01APR17)
sd(covid19$meanUVAJAN01APR17)
summary(covid19$meanUVAJAN01APR17)

t<-emmeans(m, c("meanUVAJAN01APR17"),at = list(meanUVAJAN01APR17 = c(350, 400, 450)), type = "re", offset=c(log(1000000)))

library(ggplot2)
pdf("Data/Figures/Figure2b.pdf", width=8, height=5)
plot(t, by = NULL, horizontal = FALSE, colors = "darkgreen") + theme_bw(base_size = 18)+labs(y= "COVID-19 deaths per million", x = "Mean Daily UVA Jan-Apr 17th 2020 (KJ/m2)")
dev.off()

sink()

 
###########################################################
