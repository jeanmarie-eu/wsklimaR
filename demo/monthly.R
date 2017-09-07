######################################################################################################################
# Get the monthly temperature and precipitation at stations no 19710 and 180 between 16/03/2014 and 31/12/2015       #
######################################################################################################################
library(wsklimaR)
tmp <- wsklimaR::getValues(timeserietypeID="1",fromPeriod="201403",toPeriod="201512",stations=c("19710","180"),elements=c("TAM","RR"))
str(tmp)
head(tmp)
