######################################################################################################################
# Get the hourly temperature at stations no 19710 and 2650 between 27/12/2015 and 31/12/2015                         #
######################################################################################################################
library(wsklimaR)
tmp <- wsklimaR.getValues(timeserietypeID="2",fromPeriod="20151227",toPeriod="20151231",stations=c("19710","2650"),elements=c("TA"))
str(tmp)
head(tmp)
