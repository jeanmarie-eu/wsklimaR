#' Get the values of one elements at one station
#'
#' wsklimaR.getV makes it possible to get timeseries of a meteorlogical element at a given station registered by met.no for a specific period of time and a specific time resolution.
#' In case of missing dates, the date timeserie will be incomplete.
#' It is not recommended to use this function to get several elements at different stations.
#' Indeed, some timeseries are incomplete and thus make the gathering of the different timeseries into a regular data.frame not possible.
#' To check and fill-in missing dates, please use the function wsklimaR.checkDateTimeSerie(). It makes sure the timeserie to be complete
#' It is highly recommended to use the function wsklimaR.getValues().
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod string of character yyyymmdd
#' @param toPeriod string of character yyyymmdd
#' @param stations id of the stations. 
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector if multi-element
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- wsklimaR.getV(timeserietypeID="1",
#'                      fromPeriod="20130101",
#'                      toPeriod="20130105",
#'                      stations="180",
#'                      elements="TAM")

wsklimaR.getV <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements) {

  wsklimaURL <- wsklimaR.getVsetUrl(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements)

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
