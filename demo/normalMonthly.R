######################################################################################################################
# Get the monthly normal precipitation at stations no 180                                                            #
######################################################################################################################
library(wsklimaR)
tmp <- wsklimaR::getValues(timeserietypeID="3",stations=c("180"),elements=c("RR"))
str(tmp)
head(tmp)
