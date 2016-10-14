# get metadatda for one or several stations that provides the target element
# At the difference from wsklima request: make a AND instead of a OR
getMetaSbyEl <- function(timeserietypeID,elements) {

  if (length(elements)>1) {
     df <- getMetaSbyE(timeserietypeID,elements[1])
     stations <- df$stnr
     for ( i in 2:length(elements)) {
       tmp <- getMetaSbyE(timeserietypeID,elements[i])
       indice<-match(stations,tmp$stnr)
       if (length(indice)>0) {
          stations <- na.omit(tmp$stnr[indice])
       } else stop("No stations with all the specified elements")
     }
     if (length(stations)>0) {
        indice<-match(stations,df$stnr)
        df <- df[indice,]
     } else  stop("No stations with all the specified elements")
  } else df <- getMetaSbyE(timeserietypeID,elements)

  return(df)
}


# the function getMetaSbyE makes it possible to get the metadata of the stations from met.no given a meteorological element.
# It is not recommended to use this function to get metadata of several elements.
# Indeed, instead of the logic operator AND, wsklima uses the logic operator OR
# It is highly recommended to use the function wsklimaR.getMetaStationbyElement().
getMetaSbyE <- function(timeserietypeID, elements){

   wsklimaURL <- getMetaSbyEsetUrl(timeserietypeID,elements)

   xml_data <- NULL
   try(xml_data <-XML::xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))

   df <- data.frame(
       amsl           = as.character(unlist(XML::xpathApply(xml_data,"//amsl",XML::xmlValue))),
       department     = as.character(unlist(XML::xpathApply(xml_data,"//department",XML::xmlValue))),
       fromDay        = as.character(unlist(XML::xpathApply(xml_data,"//fromDay",XML::xmlValue))),
       fromMonth      = as.character(unlist(XML::xpathApply(xml_data,"//fromMonth",XML::xmlValue))),
       fromYear       = as.character(unlist(XML::xpathApply(xml_data,"//fromYear",XML::xmlValue))),
       latDec         = as.character(unlist(XML::xpathApply(xml_data,"//latDec",XML::xmlValue))),
       lonDec         = as.character(unlist(XML::xpathApply(xml_data,"//lonDec",XML::xmlValue))),
       municipalityNo = as.character(unlist(XML::xpathApply(xml_data,"//municipalityNo",XML::xmlValue))),
       name           = as.character(unlist(XML::xpathApply(xml_data,"//name",XML::xmlValue))),
       stnr           = as.character(unlist(XML::xpathApply(xml_data,"//stnr",XML::xmlValue))),
       toDay          = as.character(unlist(XML::xpathApply(xml_data,"//toDay",XML::xmlValue))),
       toMonth        = as.character(unlist(XML::xpathApply(xml_data,"//toMonth",XML::xmlValue))),
       toYear         = as.character(unlist(XML::xpathApply(xml_data,"//toYear",XML::xmlValue))),
       utm_e          = as.character(unlist(XML::xpathApply(xml_data,"//utm_e",XML::xmlValue))),
       utm_n          = as.character(unlist(XML::xpathApply(xml_data,"//utm_n",XML::xmlValue))),
       utm_zone       = as.character(unlist(XML::xpathApply(xml_data,"//utm_zone",XML::xmlValue))),
       wmoNo          = as.character(unlist(XML::xpathApply(xml_data,"//wmoNo",XML::xmlValue)))
       )

    if (length(as.character(unlist(XML::xpathApply(xml_data,"//fault",XML::xmlValue))))>0)  df <- NULL

  return(df)
}

# url
getMetaSbyEsetUrl <- function(timeserietypeID,elements){

  wsklimaURL <- "http://eklima.met.no/met/MetService?invoke=getStationsFromTimeserieTypeElemCodes"

  timeserietypeID_URL<-c("0","1","2","3","4") #,"5")
  if (length(timeserietypeID) == 1) {
      type<-grep(timeserietypeID, c("0","1","2","3","4"), ignore.case = TRUE, value = FALSE)
      if (length(type)==1) wsklimaURL <-paste(wsklimaURL, "&timeserieypeID=",timeserietypeID_URL[type], sep = "")
      else stop("'timeserietypeID' is not correctly specified.\n")
  } else stop("'timeserietypeID' is not correctly specified.\n")

  if (length(elements)>0) {
     wsklimaURL <- paste(wsklimaURL, "&elements=", paste(elements,collapse=",") ,sep="")
  } else stop("'elements' is not correctly specified")

  # only public data
  # username
  wsklimaURL <- paste(wsklimaURL, "&username=", sep = "")
  return(wsklimaURL)
}
