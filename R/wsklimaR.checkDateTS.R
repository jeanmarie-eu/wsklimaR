#' Check the data timeseries and fill-in by missing values
#'
#' In case of missing dates, the date timeserie will get filled-in, and a missing value will be added as a value of the element
#' @param timeserie a 2-column data.frame with time and the values
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod string of character yyyymmdd
#' @param toPeriod string of character yyyymmdd
#' @param missingValues value of the expected mssing values.
#' @keywords wsklimaR
#' @export
#' @examples
#' \dontrun{
#' tmp <- wsklimaR.checkDateTS(timeserie, timeserietypeID, fromPeriod, toPeriod, missingValues)
#' }
#'

wsklimaR.checkDateTS <- function(timeserie, timeserietypeID, fromPeriod, toPeriod, missingValues) {

 fromYear  <- substring(fromPeriod, 1, 4)
 fromMonth <- substring(fromPeriod, 5, 6)
 fromDay   <- substring(fromPeriod, 7, 8)
 toYear    <- substring(toPeriod, 1, 4)
 toMonth   <- substring(toPeriod, 5, 6)
 toDay     <- substring(toPeriod, 7, 8)

 if (!is.null(timeserie)) {

   ts <- data.frame(
      year = as.character(substr(timeserie$time,1,4)),
      month = as.character(substr(timeserie$time,6,7)),
      day = as.character(substr(timeserie$time,9,10)),
      hour = as.character(substr(timeserie$time,12,23)),
      value = timeserie[,2]
   )

   if ((timeserietypeID=="0")) {
         # Daily
         ts.date<-strptime(paste(ts$day,ts$month,ts$year,sep="."),"%d.%m.%Y",tz="GMT")
         ts2<-zoo::zoo(ts[,5:dim(ts)[2]], as.Date(ts.date))
         ts2.rangetime2 <- range(((strptime(fromPeriod,"%Y%m%d",tz="GMT"))),((strptime(toPeriod,"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "day"))))
         ts3<-merge(x=ts2, y=ts2.entire_date)
         ts3[is.na(ts3)]<-missingValues

   } else if ((timeserietypeID=="1")) {
         # Monthly
         ts.date<-strptime(paste("01",ts$month,ts$year,sep="."),"%d.%m.%Y",tz="GMT")
         ts2<-zoo::zoo(ts[,5:dim(ts)[2]], as.Date(ts.date))
         ts2.rangetime2 <- range(((strptime(paste(fromYear,fromMonth,"01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste(toYear,toMonth,"01",sep=""),"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "month"))))
         ts3<-merge(x=ts2, y=ts2.entire_date)
         ts3[is.na(ts3)]<-missingValues

   } else if ((timeserietypeID=="2")) {
         # Hourly
       ts.date<-strptime(paste(ts$year,ts$month,ts$day,ts$hour,sep=""),"%Y%m%d%H:%M:%S",tz="GMT")
       ts2<-zoo::zoo(ts[,5:dim(ts)[2]], ts.date)
       ts2.rangetime2 <- range(((strptime(paste(fromPeriod,"000000",sep=""),"%Y%m%d%H%M%S",tz="GMT"))),((strptime(paste(toPeriod,"230000",sep=""),"%Y%m%d%H%M%S",tz="GMT"))))
       ts2.entire_date <- zoo::zoo(,(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "hour")))

       attributes(ts2.entire_date)$index <- as.POSIXct(attributes(ts2.entire_date)$index,tz="GMT")
       attributes(ts2)$index <- as.POSIXct(attributes(ts2)$index,tz="GMT")

       ts3<-merge(x=ts2, y=ts2.entire_date)
       ts3[is.na(ts3)]<-missingValues
       attributes(ts3)$index <- as.POSIXct(attributes(ts3)$index,tz="GMT")

   } else if ((timeserietypeID=="3"))  {
         # Normal Monthly: 1961-1990
         ts.date<-strptime(paste("01",ts$month,ts$year,sep="."),"%d.%m.%Y",tz="GMT")
         #rem: ts.date[13]: yearly normal
         ts.date <- ts.date[-13]
         ts2<-zoo::zoo(ts[,5:dim(ts)[2]], as.Date(ts.date))
         ts2.rangetime2 <- range(((strptime(paste("1961","01","01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste("1961","12","01",sep=""),"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "month"))))
         ts3<-merge(x=ts2, y=ts2.entire_date)
         ts3[is.na(ts3)]<-missingValues

   } else if ((timeserietypeID=="4"))  {
         # Normal Daily:1961-1990
         ts.date<-strptime(paste(ts$day,ts$month,ts$year,sep="."),"%d.%m.%Y",tz="GMT")
         # Warning: 29th of February is not kept
         ts.date <- ts.date[-60]
         ts2<-zoo::zoo(ts[,5:dim(ts)[2]], as.Date(ts.date))
         ts2.rangetime2 <- range(((strptime(paste("1961","01","01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste("1961","12","31",sep=""),"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "day"))))
         ts3<-merge(x=ts2, y=ts2.entire_date)
         ts3[is.na(ts3)]<-missingValues
   }

   df <- data.frame(
          date = attributes(ts3)$index,
         value = as.numeric(ts3[,2])
   )

 } else {
   if ((timeserietypeID=="0")) {
         # Daily
         ts2.rangetime2 <- range(((strptime(fromPeriod,"%Y%m%d",tz="GMT"))),((strptime(toPeriod,"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "day"))))

   } else if ((timeserietypeID=="1")) {
         # Monthly
         ts2.rangetime2 <- range(((strptime(paste(fromYear,fromMonth,fromDay,sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste(toYear,toMonth,toDay,sep=""),"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "month"))))

   } else if ((timeserietypeID=="2")) {
         # Hourly
         ts2.rangetime2 <- range(((strptime(paste(fromPeriod,"000000",sep=""),"%Y%m%d%H%M%S",tz="GMT"))),((strptime(paste(toPeriod,"235959",sep=""),"%Y%m%d%H%M%S",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "hour")))

   } else if ((timeserietypeID=="3"))  {
         # Normal Monthly: 1961-1990
         ts2.rangetime2 <- range(((strptime(paste("1961","01","01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste("1961","12","01",sep=""),"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "month"))))

   } else if ((timeserietypeID=="4"))  {
         # Normal Daily:1961-1990
         # Warning: 29th of February are not kept
         ts2.rangetime2 <- range(((strptime(paste("1961","01","01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste("1961","12","31",sep=""),"%Y%m%d",tz="GMT"))))
         ts2.entire_date <- zoo::zoo(,(as.Date(seq(from =ts2.rangetime2[1], to =ts2.rangetime2[2], by = "day"))))
   }

 df <- data.frame(
          date = attributes(ts2.entire_date)$index,
          value = rep(missingValues,length(attributes(ts2.entire_date)$index))
    )
  }
   return(df)
 }
