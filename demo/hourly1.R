######################################################################################################################
# Get the hourly temperature at stations no 19710 and 2650 between 27/12/2015 and 31/12/2015                         #
######################################################################################################################
library(wsklimaR)
tmp <- wsklimaR::getValues(timeserietypeID="2",fromPeriod="2015122723",toPeriod="2015123112",stations=c("19710","2650"),elements=c("TA"))
str(tmp)
head(tmp)
