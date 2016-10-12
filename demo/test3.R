library(wsklimaR)

# Get the hourly temperature at stations no 19710, 19720, 2650, 19480, 18265, 4870 between 27/12/2015 and 31/12/2015
tmp <- wsklimaR.getValues(timeserietypeID="2",
                                  fromPeriod="20151227",
                                  toPeriod="20151231",
                                  stations=c("19710","19720","2650","19480","18265","4870"),
                                  elements=c("TA"))
str(tmp)
head(tmp)
