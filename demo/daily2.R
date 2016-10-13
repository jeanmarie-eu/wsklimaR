#############################################################################################################
# Get the daily temperature amd precipitation at station no 180 between three days in past from now and now #
#############################################################################################################
library(wsklimaR)
tmp <- wsklimaR.getValues(timeserietypeID="0",stations="180",elements=c("TAM","RR"))
str(tmp)
head(tmp)
