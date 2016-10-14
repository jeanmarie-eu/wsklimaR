# Get the values of several element at several station
getVMultiStationMultiElement <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {

  dateTs <- getDateTS(fromPeriod=fromPeriod,toPeriod=toPeriod,timeserietypeID=timeserietypeID)

  output <- data.frame(date = dateTs)
  for ( i in 1:length(elements)) {

    tmp <- getVCompleteTS(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[1],elements=elements[i],missingValues=missingValues)
    tmp[which(tmp[,2]==-99999),2] <- missingValues

    # if several stations
    df <- tmp
    if (length(stations)>1) {
       for ( j in 2:length(stations)) {
          tmp <- getVCompleteTS(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[j],elements=elements[i],missingValues=missingValues)
          tmp[which(tmp[,2]==-99999),2] <- missingValues
          df <- cbind(df,tmp[,2])
       }
    }
    df <- df[,-1]

    output$element <- data.frame(element=rep(NA,length(dateTs)))
    output$element <- data.frame(df)
    colnames(output$element) <- (stations)
    colnames(output) <- c("date",elements[1:i])
  }
	return(output)
}

# Get the complete timeseries fo one element at one station
# The timeserie is checked and filling-in by missing values in case of missing dates
getVCompleteTS <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {
  # get values
  df <- getV(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements)
  # filling-in by missing values when missing dates
  df <- checkDateTS(timeserie=df,timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,missingValues=missingValues);
	return(df)
}


# Get the values of one elements at one station
# The function getV makes it possible to get timeseries of a meteorlogical element at a given station registered by met.no
# for a specific period of time and a specific time resolution.
# In case of missing dates, the date timeserie will be incomplete.
# It is not recommended to use this function to get several elements at different stations.
# Indeed, some timeseries are incomplete and thus make the gathering of the different timeseries into a regular data.frame not possible.
# It is highly recommended to use the function getValues().
getV <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements) {

  wsklimaURL <- getVsetUrl(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements)

  xml_data <- NULL
  try(xml_data <-XML::xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))

  #results as a data.frame
  df <- data.frame(time = as.character(unlist(XML::xpathApply(xml_data,"//timeStamp",XML::xmlGetAttr,"from"))))
  #value
	df[elements] <- as.numeric(unlist(XML::xpathApply(xml_data,"//timeStamp/location/weatherElement/value",XML::xmlValue)))

  #no quality
  ##quality
	#df[paste(elements,"q",sep="")] <- as.numeric(unlist(xpathApply(xml_data,"//timeStamp/location/weatherElement",xmlGetAttr,"quality")))

  if (length(as.character(unlist(XML::xpathApply(xml_data,"//fault",XML::xmlValue))))>0)  df <- NULL

	return(df)
}

# url
getVsetUrl <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements) {

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
