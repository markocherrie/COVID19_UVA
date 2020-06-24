#####################################

library(bitops)
library(metafor)
library(Formula)

EffectSize=c(-0.30954,-0.20536, -0.6789)
se=c(0.0882,0.06959, 0.1337)
slab=c("USA", "Italy", "England")

#Run ramdom effects model
ma_model_2 <- rma.uni(measure="IRR", yi=EffectSize, sei=se, slab=slab)
#ma_model_2 <- rma.uni(yi=yi, sei=sei, data = effects)

forest(ma_model_2, xlab="Mortality Rate Ratio", header="Country", atransf=exp)

#https://cran.r-project.org/web/packages/metafor/metafor.pdf
#http://www.metafor-project.org/doku.php/plots:forest_plot_with_subgroups
