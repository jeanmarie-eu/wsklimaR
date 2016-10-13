#' Get the values of one element at one station by month
#'
#' The wsklima server is not very young. It is better to split the request into several shorter in order to keep the server stable
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod
#' @param toPeriod
#' @param stations
#' @param elements TAM, RR, ...
#' @keywords wsklimaR
#' @export
#' @examples
#' wsklimaR.getVByMonth(timeserietypeID="1", fromPeriod="20130101",toPeriod="20130105",stations="180",elements="TAM")

wsklimaR.getVByMonth <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements) {

  fromYear <- substring(fromPeriod, 1, 4)
  fromMonth <- substring(fromPeriod, 5, 6)
  fromDay <- substring(fromPeriod, 7, 8)
  toYear <- substring(toPeriod, 1, 4)
  toMonth <- substring(toPeriod, 5, 6)
  toDay <- substring(toPeriod, 7, 8)

	rangetime <- range(((strptime(fromPeriod,"%Y%m%d",tz="GMT"))),((strptime(toPeriod,"%Y%m%d",tz="GMT"))))
	tmp <- zoo(,(as.Date(seq(from =rangetime[1], to =rangetime[2], by = "month"))+1))
	seqPeriod <- attributes(tmp)$index
	nbMonth <- length(seqPeriod)

	fperiod<-as.character(as.Date(as.yearmon(seqPeriod) ))
	substr(fperiod[1], 9, 10) <- fromDay
	fperiod<-gsub("-","",fperiod)


	tmp <- as.Date(as.yearmon(seqPeriod))+35
	tperiod <- as.character(as.Date(as.yearmon(tmp))-1)
	substr(tperiod[nbMonth], 9, 10) <- toDay
	tperiod<-gsub("-","",tperiod)

  # result is a data.frame
	df<-NULL
	for (i in 1:(nbMonth)) {
       tmp <- wsklimaR.getV(timeserietypeID=timeserietypeID,fromPeriod=fperiod[i],toPeriod=tperiod[i],stations=stations,elements=elements)
		   if (!is.null(tmp)) {
         df <- rbind(df,tmp)
       }
	}

	return(df)
}
