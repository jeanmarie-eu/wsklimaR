wsklimaR.getVsetUrl <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements) {

     wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getMetDataValues"

     #timeserietypeID:
     #0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily
     timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
     if (length(timeserietypeID) == 1) {
       type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
       if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
       else stop("'timeserietypeID' is not correctly specified.\n")
     } else stop("'timeserietypeID' is not correctly specified.\n")

     #format of the date, here default: yyyy-mm-dd
     wsklimaURL <- paste(wsklimaURL, "&format=", sep = "")

     #period from-to
     if (is.numeric(toPeriod)) {
         toPeriod <- as.character(toPeriod)
         toPeriod <- paste(substring(toPeriod, 1, 4), substring(toPeriod, 5, 6),substring(toPeriod, 7, 8), sep = "-")
	   } else if (is.character(toPeriod)) {
         toPeriod <- paste(substring(toPeriod, 1, 4), substring(toPeriod, 5, 6),substring(toPeriod, 7, 8), sep = "-")
	   }

     if (is.numeric(fromPeriod)) {
         fromPeriod <- as.character(fromPeriod)
         fromPeriod <- paste(substring(fromPeriod, 1, 4), substring(fromPeriod, 5, 6),substring(fromPeriod, 7, 8), sep = "-")
	   } else if (is.character(toPeriod)) {
         fromPeriod <- paste(substring(fromPeriod, 1, 4), substring(fromPeriod, 5, 6),substring(fromPeriod, 7, 8), sep = "-")
	   }

     #rem:check-up the format of dates written as array of char
     wsklimaURL <- paste(wsklimaURL, "&from=", fromPeriod, "&to=", toPeriod,sep = "")

     #station
     if (length(stations)>0) {
      wsklimaURL <- paste(wsklimaURL, "&stations=", paste(stations,collapse=",") ,sep="")
     } else stop("'stations' is not correctly specified")

     #element
     if (length(elements)>0) {
      wsklimaURL <- paste(wsklimaURL, "&elements=", paste(elements,collapse=",") ,sep="")
     } else stop("'elements' is not correctly specified")

     #hours: every hours
     if (timeserietypeID_URL[type] == "2") {
       wsklimaURL <- paste(wsklimaURL, "&hours=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23", sep = "")
     } else wsklimaURL <- paste(wsklimaURL, "&hours=", sep = "")

     #months
     wsklimaURL <- paste(wsklimaURL, "&months=", sep = "")

     # only public data
     #username
     wsklimaURL <- paste(wsklimaURL, "&username=", sep = "")

     return(wsklimaURL)
}
