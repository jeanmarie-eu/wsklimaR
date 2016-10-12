#' Get the values of one/several elements at one/several stations
#'
#' wsklimaR.getValues makes it possible to get timeseries of a meteorlogical elements at some given stations registered by met.no for a specific period of time and a specific time resolution.
#' rem: timeserietypeID #2 is not always representing the hourly time resolution but also can be infra-hourly. We only kept hourly datasets.
#' The output is a dataframe structured as followed: the date timeserie, and the elements. Each element is a dataframe made of the timeseries of the different stations.
#' This structure eases the conversion into json
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod
#' @param toPeriod
#' @param stations
#' @param elements TAM, RR, ...
#' @param missingValues
#' @keywords wsklimaR
#' @export
#' @examples
#' df <- wsklimaR.getValues(timeserietypeID="1", fromPeriod="20130101",toPeriod="20130105",stations="180",elements=c("TAM","RR"))
#' str(df)
#' df <- wsklimaR.getValues(timeserietypeID="2",fromPeriod="20120101",toPeriod="20151231",stations=c("19710","19720","2650","19480","18265","4870"),elements=c("TA")
#' str(df)

wsklimaR.getValues <- function(timeserietypeID=NULL,fromPeriod=NULL,toPeriod=NULL,stations=NULL,elements=NULL,missingValues=-999)  {

   if (is.null(timeserietypeID)) stop("'timeserietypeID' is not correctly specified.\n")
   if (is.null(stations)) stop("'stations' is not correctly specified.\n")
   if (is.null(elements)) stop("'elements' is not correctly specified.\n")
   if (is.null(toPeriod)) toPeriod <-gsub("-","",format(Sys.time(), "%Y-%m-%d",tz="GMT"))
   if (is.null(fromPeriod)) fromPeriod <-gsub("-","",format(Sys.time()- 7 * 24 * 3600, "%Y-%m-%d",tz="GMT"))

   stations <- as.character(stations)
   elements <- as.character(elements)
   dateTs <- wsklimaR.getDateTS(fromPeriod=fromPeriod,toPeriod=toPeriod,timeserietypeID=timeserietypeID)

   output <- data.frame(date = dateTs)
   for ( i in 1:length(elements)) {

     # get values by month: avoid to crash wsklima server
     tmp <- wsklimaR.getVByMonth(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[1],elements=elements[i])
     # filling-in by missing values when missing dates
     tmp <- wsklimaR.checkDateTS(timeserie=tmp,timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,missingValue=missingValues);
     tmp[which(tmp[,2]==-99999),2] <- missingValues

     # if several stations
     df <- tmp
     if (length(stations)>1) {
        for ( j in 2:length(stations)) {
           tmp <- wsklimaR.getVByMonth(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[j],elements=elements[i])
           tmp <- wsklimaR.checkDateTS(timeserie=tmp,timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,missingValue=missingValues);
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
