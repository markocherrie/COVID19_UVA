UVAdeathscovars<-read.csv("data/FinalSample/covid19withUVItaly.csv")

############################################
#UVAdeathscovars$deathsdiffnegativetozero<-round(UVAdeathscovars$deathsdiffnegativetozero, 0)
# similar results with rounded deaths - 0.84 (0.74-0.96); continue with non-integar

library(glmmTMB)
library(emmeans)

m <- glmmTMB(
  deathsdiffnegativetozero ~  meanUVAJAN01APR30
  # air pollution
  + z_pm2point52016
  # other climate
  + scale(meanwintertemp)
  # demographics
  + z_perc85 + z_perc65 + z_densityinhabitants + z_percfore
  # Deprivation
  + z_deprivationn
  # health care factors
  + z_superficietotalekm2
  # tests
  + z_totale_casi
  # offset
  + offset(logpop) 
  # multilevel
  + (1 | Provincia), 
  
  ziformula = ~  
    # demographics
    + z_perc85 + z_perc65 + z_densityinhabitants + z_percfore
  # Deprivation
  + z_deprivationn
  # health care factors
  + z_superficietotalekm2 
  + z_totale_casi,
  # family
  family = nbinom2, 
  data = UVAdeathscovars
)



summary(m)
confint(m)

exp(confint(m)[2,1]*100)
exp(confint(m)[2,2]*100)
exp(confint(m)[2,3]*100)

mean(UVAdeathscovars$meanUVAJAN01APR30)
sd(UVAdeathscovars$meanUVAJAN01APR30)

# ICC
performance::icc(m)

library(ggplot2)
t<-emmeans(m, c("meanUVAJAN01APR30"), at = list(meanUVAJAN01APR30 = c(600, 700,800)), type = "re", offset=c(log(1000000)))
png("Data/Figures/Figure2c.png")
plot(t, by = NULL, horizontal = FALSE, colors = "darkgreen") + theme_bw(base_size = 18)
dev.off()


