library(readxl)
deaths<-read_excel("data/HealthPop/morti 2020-2015.xlsx", sheet=2, skip=1)
deaths<-subset(deaths, select=c("COD_PROVCOM", "M+F...9", "M+F...12"))
colnames(deaths)<-c("codcom", "marapr1519deaths", "marapr20deaths")
deaths$codcom<-as.character(as.numeric(deaths$codcom))

covars<-read_excel("data/HealthPop/Municipality Italy_with deprivation.xlsx")
covars<-covars[3:nrow(covars),]
covars$codcom<-as.character(as.numeric(covars$codcom))

deathscovars<-merge(deaths, covars, by.x="codcom", all.x=T)

UVA<-read.csv("data/UVJAXA/meanJAN01APR30_ITALY.csv")
UVAdeathscovars<-merge(deathscovars, UVA, by.x="codcom", by.y="com")

temp<-read.csv("data/TempGEE/italylongtermwintertemp.csv")
UVAdeathscovars<-merge(UVAdeathscovars, temp, by.x="codcom", by.y="PRO_COM")

pm25<-read.csv("data/PM/italypm252016.csv")
UVAdeathscovars<-merge(UVAdeathscovars, pm25, by="codcom")

tests<-readr::read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province-20200430.csv")
UVAdeathscovars$Provincia[UVAdeathscovars$Provincia=="Reggio Calabria"]<-"Reggio di Calabria"
UVAdeathscovars$Provincia[UVAdeathscovars$Provincia=="Valle d'Aosta/Vallée d'Aoste"]<-"Aoste"
UVAdeathscovars$Provincia[UVAdeathscovars$Provincia=="Massa-Carrara"]<-"Massa Carrara"
UVAdeathscovars$Provincia[UVAdeathscovars$Provincia=="Bolzano/Bozen"]<-"Bolzano"
tests<-subset(tests, select=c("denominazione_provincia", "totale_casi"))


UVAdeathscovars<-merge(UVAdeathscovars, tests, by.x="Provincia", "denominazione_provincia")


####
UVAdeathscovars$deathsdiffnegativetozero<-UVAdeathscovars$marapr20deaths-UVAdeathscovars$marapr1519deaths
UVAdeathscovars$deathsdiffnegativetozero<-ifelse(UVAdeathscovars$deathsdiffnegativetozero<0, 0, UVAdeathscovars$deathsdiffnegativetozero)


##### rplace missings
UVAdeathscovars$z_percfore<-scale(as.numeric(UVAdeathscovars$`Perc. Fore`))
UVAdeathscovars$z_perc65<-scale(as.numeric(UVAdeathscovars$`Perc. 65+`))
UVAdeathscovars$z_perc85<-scale(as.numeric(UVAdeathscovars$`Perc. 85+`))
UVAdeathscovars$z_densityinhabitants<-scale(as.numeric(UVAdeathscovars$`Density (inhabitants`))
UVAdeathscovars$z_deprivationn<-scale(as.numeric(UVAdeathscovars$Deprivation))
UVAdeathscovars$z_superficietotalekm2<-scale(as.numeric(UVAdeathscovars$`Superficie totale (Km2)`))
UVAdeathscovars$z_pm2point52016<-scale(as.numeric(UVAdeathscovars$pm2point52016))
UVAdeathscovars$z_totale_casi<-scale(as.numeric(UVAdeathscovars$totale_casi))

### log pop
UVAdeathscovars$logpop<-log(as.numeric(UVAdeathscovars$`Census population`))

### only non missing for all these vars
UVAdeathscovars<-subset(UVAdeathscovars, select=c("codcom", "marapr1519deaths", "marapr20deaths","meanwintertemp","deathsdiffnegativetozero", "Provincia", 
                                 "meanUVAJAN01APR30", "z_percfore","z_perc65", "z_perc85", "z_densityinhabitants",
                                 "z_deprivationn", "z_superficietotalekm2", "logpop", "z_totale_casi", "z_pm2point52016"))
UVAdeathscovars<-na.omit(UVAdeathscovars)


#########################################

#write.csv(UVAdeathscovars, "data/FinalSample/covid19withUVItaly.csv", row.names=F)

##################################



