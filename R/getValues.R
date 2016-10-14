#' Get the values of one/several elements at one/several stations
#'
#' The function \code{getValues()} makes it possible to get timeseries of meteorological elements at some given stations registered by met.no for a specific period of time and a specific time resolution.
#'
#' rem: timeserietypeID #2 is not always representing the hourly time resolution but also can be infra-hourly. We only keep hourly datasets.

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Hourly, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod string of character yyyymmdd. Omitting this parameter will make it start 3 days earlier from now
#' @param toPeriod string of character yyyymmdd. Omitting this parameter will make it stop now
#' @param stations id of the stations. Can be a scalar or a vector of station ids
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector of elements
#' @param missingValues value of the expected mssing values. By default: -999
#' @return The output is a dataframe structured as followed: the date timeserie, and the elements.
#'  Each element is a dataframe made of the timeseries of the different stations.
#'  This structure eases the conversion into a json format
#' @keywords wsklimaR
#' @export
#' @examples
#' ########################################################
#' # Get daily temperature amd precipitation              #
#' # at station no 180 between 01/01/2013 and 05/01/2013  #
#' ########################################################
#' tmp <- getValues(timeserietypeID="0",
#'                  fromPeriod="20130101",
#'                  toPeriod="20130105",
#'                  stations="180",
#'                  elements=c("TAM","RR"))
#' str(tmp)
#' head(tmp)
#'
#' ########################################################
#' # Get hourly temperature at stations no 19710          #
#' # and 2650 between 27/12/2015 and 31/12/2015           #
#' ########################################################
#' tmp <- getValues(timeserietypeID="2",
#'                  fromPeriod="20151227",
#'                  toPeriod="20151231",
#'                  stations=c("19710","2650"),
#'                  elements=c("TA"))
#' str(tmp)
#' head(tmp)
#'
#' ########################################################
#' # Get monthly temperature and precipitation at         #
#' # stations no 19710 and 180 between 16/03/2014 and     #
#' # 31/12/2015                                           #
#' ########################################################
#' tmp <- getValues(timeserietypeID="1",
#'                  fromPeriod="20140316",
#'                  toPeriod="20151231",
#'                  stations=c("19710","180"),
#'                  elements=c("TAM","RR"))
#' str(tmp)
#' head(tmp)
#'
#' ########################################################
#' # Get daily normal temperature at                      #
#' # stations no 180, 2650                                #
#' ########################################################
#' tmp <- getValues(timeserietypeID="4",
#'                  stations=c("180","2650"),
#'                  elements=c("TAM"))
#' str(tmp)
#' head(tmp)

getValues <- function(timeserietypeID=NULL,
                      fromPeriod=NULL,
                      toPeriod=NULL,
                      stations=NULL,
                      elements=NULL,
                      missingValues=-999)  {

   if (is.null(timeserietypeID)) stop("'timeserietypeID' is not correctly specified.\n")
   if (is.null(stations)) stop("'stations' is not correctly specified.\n")
   if (is.null(elements)) stop("'elements' is not correctly specified.\n")
   if (is.null(toPeriod)) toPeriod <-gsub("-","",format(Sys.time(), "%Y-%m-%d",tz="GMT"))
   if (is.null(fromPeriod)) fromPeriod <-gsub("-","",format(Sys.time()- 3 * 24 * 3600, "%Y-%m-%d",tz="GMT"))

   stations <- as.character(stations)
   elements <- as.character(elements)

   output <- switch(timeserietypeID,
     "0" = getVByMonthMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "1" = getVMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "2" = getVByMonthMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "3" = getVMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     "4" = getVMultiStationMultiElement(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements,missingValues=missingValues),
     (message=paste0("Invalid timeserietypeID:", timeserietypeID,". Choose: 0, 1, 2, 3, 4 "))
     )

   return(output)
}
