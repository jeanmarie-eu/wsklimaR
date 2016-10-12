library(wsklimaR)

# Get the daily temperature amd precipitation at station no 180 without specifying the period
tmp <- wsklimaR.getValues(timeserietypeID="0",
                                  stations="180",
                                  elements=c("TAM","RR"))
str(tmp)
head(tmp)
