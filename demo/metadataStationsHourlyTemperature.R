#####################################################################################################################
# Get the metadata of the stations that measures or did measure hourly temperature                                  #
#####################################################################################################################
library(wsklimaR)
tmp <- wsklimaR.getMetaStationbyElement(timeserietypeID="2",elements="TA")
str(tmp)
head(tmp)
