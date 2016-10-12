getMetaEsetUrl <- function(timeserietypeID,station=NULL) {

   if (!is.null(station)) {

      wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getElementsFromTimeserieTypeStation"

      #timeserietypeID:
      #0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily
      timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
      if (length(timeserietypeID) == 1) {
        type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
        if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
        else stop("'timeserietypeID' is not correctly specified.\n")
      } else stop("'timeserietypeID' is not correctly specified.\n")

      #station
      wsklimaURL <- paste(wsklimaURL, "&stnr=", as.integer(station), sep = "")

   } else {

      wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getElementsFromTimeserieType"

      #timeserietypeID:
      #0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily
      timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
      if (length(timeserietypeID) == 1) {
        type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
        if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
        else stop("'timeserietypeID' is not correctly specified.\n")
      } else stop("'timeserietypeID' is not correctly specified.\n")

    }
    return(wsklimaURL)

}
