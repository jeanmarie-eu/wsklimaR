#' Get the values of one/several elements at one/several stations
#'
#' wsklimaR.getValues makes it possible to get timeseries of meteorological elements at some given stations registered by met.no for a specific period of time and a specific time resolution.
#' rem: timeserietypeID #2 is not always representing the hourly time resolution but also can be infra-hourly. We only kept hourly datasets.

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod string of character yyyymmdd
#' @param toPeriod string of character yyyymmdd
#' @param stations id of the stations. Can be a vector if multi-stations
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector if multi-element
#' @param missingValues value of the expected mssing values. By default: -999
#' @return The output is a dataframe structured as followed: the date timeserie, and the elements. Each element is a dataframe made of the timeseries of the different stations.
#'  This structure eases the conversion into a json format
#' @keywords wsklimaR
#' @export
#' @examples
#' df <- wsklimaR.getValues(timeserietypeID="1",
#'                          fromPeriod="20130101",
#'                          toPeriod="20130105",
#'                          stations="180",
#'                          elements=c("TAM","RR"),
#'                          missingValues=-999)
#' str(df)
#' df <- wsklimaR.getValues(timeserietypeID="2",
#'                          fromPeriod="20120101",
#'                          toPeriod="20151231",
#'                          stations=c("19710","19720","2650","19480","18265","4870"),
#'                          elements=c("TA"),
#'                          missingValues=-999)
#' str(df)

wsklimaR.getValues <- function(timeserietypeID=NULL,fromPeriod=NULL,toPeriod=NULL,stations=NULL,elements=NULL,missingValues=-999)  {

   if (is.null(timeserietypeID)) stop("'timeserietypeID' is not correctly specified.\n")
   if (is.null(stations)) stop("'stations' is not correctly specified.\n")
   if (is.null(elements)) stop("'elements' is not correctly specified.\n")
   if (is.null(toPeriod)) toPeriod <-gsub("-","",format(Sys.time(), "%Y-%m-%d",tz="GMT"))
   if (is.null(fromPeriod)) fromPeriod <-gsub("-","",format(Sys.time()- 3 * 24 * 3600, "%Y-%m-%d",tz="GMT"))

   stations <- as.character(stations)
   elements <- as.character(elements)

   output <- switch(timeserietypeID,
     "0" = wsklimaR.getVByMonthMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "1" = wsklimaR.getVMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "2" = wsklimaR.getVByMonthMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "3" = wsklimaR.getVMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "4" = wsklimaR.getVMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     (message=paste0("Invalid timeserietypeID:", timeserietypeID,". Choose: 0, 1, 2, 3, 4 "))
     )

   return(output)
}
