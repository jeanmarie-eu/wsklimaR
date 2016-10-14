######################################################################################################################
# Get the daily normal temperature at stations no 180, 2650                                                          #
######################################################################################################################
library(wsklimaR)
tmp <- wsklimaR::getValues(timeserietypeID="4",stations=c("180","2650"),elements=c("TAM"))
str(tmp)
head(tmp)
