library(wsklimaR)

# Get the hourly temperature and precipitation at stations no 19710, 19720, between 27/12/2015 and 31/12/2015
tmp <- wsklimaR.getValues(timeserietypeID="2",
                                  fromPeriod="20151227",
                                  toPeriod="20151231",
                                  stations=c("19710","19720"),
                                  elements=c("TA","RR_1"))
str(tmp)
head(tmp)
