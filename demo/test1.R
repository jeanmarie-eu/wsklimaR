library(wsklimaR)

# Get the daily temperature amd precipitation at station no 180 between 01/01/2013 and 05/01/2013
tmp <- wsklimaR.getValues(timeserietypeID="0",
                                  fromPeriod="20130101",
                                  toPeriod="20130105",
                                  stations="180",
                                  elements=c("TAM","RR"))
str(tmp)
head(tmp)
