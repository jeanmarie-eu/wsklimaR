######################################################################################################################
# Get the metadata of the elements that have daily values                                                            #
######################################################################################################################
library(wsklimaR)
tmp <- wsklimaR.getMetaElement(timeserietypeID = "0")
str(tmp)
head(tmp)
