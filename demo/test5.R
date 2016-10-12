library(wsklimaR)

# Get the metadata of the stations given the type of the timeserie and the meteorlogical element Temperature (TA)
tmp <- wsklimaR.getMetaStationbyElement(timeserietypeID="2",elements="TA")
str(tmp)
head(tmp)
