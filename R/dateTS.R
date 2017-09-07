# Get the full date timeserie between the range of the period and at the right time resolution

getDateTS <- function (fromPeriod,toPeriod,timeserietypeID){
   res <- completeDateTS(fromPeriod=,toPeriod=toPeriod,timeserietypeID=timeserietypeID)
   return(res$seqPeriod)
}


# Check the data timeseries and fill-in by missing values
# In case of missing dates, the date timeserie will get filled-in, and a missing value will be added as a value of the element
checkDateTS <- function(timeserie, timeserietypeID, fromPeriod, toPeriod, missingValues) {

  # build a complete date timeserie
  completeTS <- completeDateTS(fromPeriod=fromPeriod,toPeriod=toPeriod,timeserietypeID=timeserietypeID)


  # build a POSIXlt vector of from the data
  if (!is.null(timeserie)) {
     uncompleteTS <- timeManip::standard2(precision="hourly", paste(paste(as.character(substr(timeserie$time,1,4)),             # year
                                                                          as.character(substr(timeserie$time,6,7)),             # month
                                                                          as.character(substr(timeserie$time,9,10)),sep="/"),   # day
                                                                          as.character(substr(timeserie$time,12,23)),sep=" "))  # hour

     indice <- match(uncompleteTS,completeTS)

     df <- data.frame(
            date = completeTS$seqPeriod,
            value = rep(missingValues,completeTS$nb))

     df$value[indice] <- timeserie[,2]

  }
  else{
    df <- data.frame(
           date = completeTS$seqPeriod,
           value = rep(missingValues,completeTS$nb))
  }

   return(df)
 }

 completeDateTS <- function(fromPeriod,toPeriod,timeserietypeID){
   res <- switch(timeserietypeID,
     "0" = timeManip::timeserie(timeResolution="daily",fromPeriod=fromPeriod,toPeriod=toPeriod),
     "1" = timeManip::timeserie(timeResolution="monthly",fromPeriod=fromPeriod,toPeriod=toPeriod),
     "2" = timeManip::timeserie(timeResolution="hourly",fromPeriod=fromPeriod,toPeriod=toPeriod),
     "3" = timeManip::timeserie(timeResolution="monthly",fromPeriod=paste0("1961","01"),toPeriod=paste0("1961","12"),
     "4" = timeManip::timeserie(timeResolution="daily",fromPeriod=paste0("1961","01","01"),toPeriod=paste0("1961","12","01"),
     stop("timeserietypeID not recognize: ",timeserietypeID))
   return(res)
 }
