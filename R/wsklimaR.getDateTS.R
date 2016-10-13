#' Get the full date timeserie
#'
#' Get the full date timeserie between the range of the period and at the right time resolution
#' @param fromPeriod
#' @param toPeriod
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @keywords wsklimaR
#' @export
#' @examples
#' wsklimaR.getDateTS(fromPeriod,toPeriod,timeserietypeID)

wsklimaR.getDateTS <- function (fromPeriod,toPeriod,timeserietypeID){
   fromYear <- substring(fromPeriod, 1, 4)
   fromMonth <- substring(fromPeriod, 5, 6)
   fromDay <- substring(fromPeriod, 7, 8)
   toYear <- substring(toPeriod, 1, 4)
   toMonth <- substring(toPeriod, 5, 6)
   toDay <- substring(toPeriod, 7, 8)

   if ((timeserietypeID=="0")) {
     # Daily
     rangeDate <- range(((strptime(fromPeriod,"%Y%m%d",tz="GMT"))),((strptime(toPeriod,"%Y%m%d",tz="GMT"))))
     dateTs <- zoo(,(as.Date(seq(from =rangeDate[1], to =rangeDate[2], by = "day"))))

   } else if ((timeserietypeID=="1")) {
     # Monthly
     rangeDate <- range(((strptime(paste(fromYear,fromMonth,"01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste(toYear,toMonth,"01",sep=""),"%Y%m%d",tz="GMT"))))
     dateTs <- zoo(,(as.Date(seq(from =rangeDate[1], to =rangeDate[2], by = "month"))))

   } else if ((timeserietypeID=="2")) {
     # Hourly
     rangeDate <- range(((strptime(paste(fromPeriod,"000000",sep=""),"%Y%m%d%H%M%S",tz="GMT"))),((strptime(paste(toPeriod,"230000",sep=""),"%Y%m%d%H%M%S",tz="GMT"))))
     dateTs <- zoo(,(seq(from =rangeDate[1], to =rangeDate[2], by = "hour")))
     attributes(dateTs)$index <- as.POSIXct(attributes(dateTs)$index)

   } else if ((timeserietypeID=="3"))  {
     # Normal Monthly: 1961-1990
     rangeDate <- range(((strptime(paste("1961","01","01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste("1961","12","01",sep=""),"%Y%m%d",tz="GMT"))))
     dateTs <- zoo(,(as.Date(seq(from =rangeDate[1], to =rangeDate[2], by = "month"))))

   } else if ((timeserietypeID=="4"))  {
     # Normal Daily:1961-1990
     # Warning: the 29ths of February are not kept
     ts.date<-strptime(paste(ts$day,ts$month,ts$year,sep="."),"%d.%m.%Y",tz="GMT")
     ts2<-zoo(ts[,5:dim(ts)[2]], as.Date(ts.date))
     rangeDate <- range(((strptime(paste("1961","01","01",sep=""),"%Y%m%d",tz="GMT"))),((strptime(paste("1961","12","31",sep=""),"%Y%m%d",tz="GMT"))))
     dateTs <- zoo(,(as.Date(seq(from =rangeDate[1], to =rangeDate[2], by = "day"))))
   }
   res <- attributes(dateTs)$index
   return(res)
 }
