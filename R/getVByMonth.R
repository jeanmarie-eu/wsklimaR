# Get the values of several element at several station by month
# The wsklima server is not so young. It is better to split the request into several shorters.
# The wsklima server will stay stable
getVByMonthMultiStationMultiElement <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {

  dateTs <- getDateTS(fromPeriod=fromPeriod,toPeriod=toPeriod,timeserietypeID=timeserietypeID)

  output <- data.frame(date = dateTs)
  for ( i in 1:length(elements)) {

    tmp <- getVByMonthCompleteTS(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[1],elements=elements[i],missingValues=missingValues)
    tmp[which(tmp[,2]==-99999),2] <- missingValues

    # if several stations
    df <- tmp
    if (length(stations)>1) {
       for ( j in 2:length(stations)) {
          tmp <- getVByMonthCompleteTS(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[j],elements=elements[i],missingValues=missingValues)
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

# The timeserie is checked and filling-in by missing values in case of missing dates
getVByMonthCompleteTS <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {

  # get values by month: avoid to crash wsklima server
  df <- getVByMonth(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements)
  # filling-in by missing values when missing dates
  df <- checkDateTS(timeserie=df,timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,missingValues=missingValues);

  return(df)
}

# get the values by month
getVByMonth <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements) {

  fromYear <- substring(fromPeriod, 1, 4)
  fromMonth <- substring(fromPeriod, 5, 6)
  fromDay <- substring(fromPeriod, 7, 8)
  toYear <- substring(toPeriod, 1, 4)
  toMonth <- substring(toPeriod, 5, 6)
  toDay <- substring(toPeriod, 7, 8)

	rangetime <- range(((strptime(fromPeriod,"%Y%m%d",tz="GMT"))),((strptime(toPeriod,"%Y%m%d",tz="GMT"))))
	tmp <- zoo::zoo(,(zoo::as.Date(seq(from =rangetime[1], to =rangetime[2], by = "month"))+1))
	seqPeriod <- attributes(tmp)$index
	nbMonth <- length(seqPeriod)

	fperiod<-as.character(zoo::as.Date(zoo::as.yearmon(seqPeriod) ))
	substr(fperiod[1], 9, 10) <- fromDay
	fperiod<-gsub("-","",fperiod)


	tmp <- zoo::as.Date(zoo::as.yearmon(seqPeriod))+35
	tperiod <- as.character(zoo::as.Date(zoo::as.yearmon(tmp))-1)
	substr(tperiod[nbMonth], 9, 10) <- toDay
	tperiod<-gsub("-","",tperiod)

  # result is a data.frame
	df<-NULL
	for (i in 1:(nbMonth)) {
       tmp <- getV(timeserietypeID=timeserietypeID,fromPeriod=fperiod[i],toPeriod=tperiod[i],stations=stations,elements=elements)
		   if (!is.null(tmp)) {
         df <- rbind(df,tmp)
       }
	}

	return(df)
}
