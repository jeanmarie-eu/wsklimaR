library(wsklimaR)

# Get the element related to one type of timeserie
tmp <- wsklimaR.getMetaElement(timeserietypeID = "0")
str(tmp)
head(tmp)
