# Get the metadata of the meteorlogical element for a specific time resolution
getMetaE <- function(timeserietypeID,stations=NULL) {

   wsklimaURL <- getMetaEsetUrl(timeserietypeID=timeserietypeID,stations=stations)

   xml_data <- NULL
   try(xml_data <-XML::xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))
   df <- data.frame(
         description  = as.character(unlist(XML::xpathApply(xml_data,"//description",XML::xmlValue))),
		     element      = as.character(unlist(XML::xpathApply(xml_data,"//elemCode",XML::xmlValue))),
		     elementGroup = as.character(unlist(XML::xpathApply(xml_data,"//elemGroup",XML::xmlValue))),
		     elementNo    = as.character(unlist(XML::xpathApply(xml_data,"//elemNo",XML::xmlValue))),
		     fromDate     = as.character(unlist(XML::xpathApply(xml_data,"//fromdate",XML::xmlValue))),
		     language     = as.character(unlist(XML::xpathApply(xml_data,"//language",XML::xmlValue))),
		     name         = as.character(unlist(XML::xpathApply(xml_data,"//name",XML::xmlValue))),
		     toDate       = as.character(unlist(XML::xpathApply(xml_data,"//todate",XML::xmlValue))),
		     unit         = as.character(unlist(XML::xpathApply(xml_data,"//unit",XML::xmlValue)))
         )

   return(df)
}

# url
getMetaEsetUrl <- function(timeserietypeID,stations=NULL) {

   if (!is.null(stations)) {

      wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getElementsFromTimeserieTypeStation"

      timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
      if (length(timeserietypeID) == 1) {
        type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
        if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
        else stop("'timeserietypeID' is not correctly specified.\n")
      } else stop("'timeserietypeID' is not correctly specified.\n")

      wsklimaURL <- paste(wsklimaURL, "&stnr=", as.integer(stations), sep = "")

   } else {

      wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getElementsFromTimeserieType"

      timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
      if (length(timeserietypeID) == 1) {
        type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
        if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
        else stop("'timeserietypeID' is not correctly specified.\n")
      } else stop("'timeserietypeID' is not correctly specified.\n")

    }
    return(wsklimaURL)

}
