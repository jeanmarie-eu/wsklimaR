wsklimaR.getMetaSbyEsetUrl <- function(timeserietypeID,elements){

  wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getStationsFromTimeserieTypeElemCodes"

  #timeserietypeID:
  #0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily
  timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
  if (length(timeserietypeID) == 1) {
      type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
      if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
      else stop("'timeserietypeID' is not correctly specified.\n")
  } else stop("'timeserietypeID' is not correctly specified.\n")

  #element
  if (length(elements)>0) {
     wsklimaURL <- paste(wsklimaURL, "&elements=", paste(elements,collapse=",") ,sep="")
  } else stop("'elements' is not correctly specified")

  #username
  wsklimaURL <- paste(wsklimaURL, "&username=", sep = "")
  return(wsklimaURL)
}
