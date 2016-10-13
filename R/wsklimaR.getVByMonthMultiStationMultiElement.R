#' Get the values of several element at several station by month
#'
#' The wsklima server is not very young. It is better to split the request into several shorter in order to keep the server stable
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod string of character yyyymmdd
#' @param toPeriod string of character yyyymmdd
#' @param stations id of the stations. Can be a vector if multi-stations
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector if multi-element.
#' @param missingValues value of the expected mssing values.
#' @keywords wsklimaR
#' @export
#' @examples
#' wsklimaR.getVByMonthMultiStationMultiElement(timeserietypeID="0",
#'                                               fromPeriod="20130101",
#'                                               toPeriod="20130105",
#'                                               stations="180",
#'                                               elements="TAM",
#'                                               missingValues=-999)

wsklimaR.getVByMonthMultiStationMultiElement <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {

  dateTs <- wsklimaR.getDateTS(fromPeriod=fromPeriod,toPeriod=toPeriod,timeserietypeID=timeserietypeID)

  output <- data.frame(date = dateTs)
  for ( i in 1:length(elements)) {

    tmp <- wsklimaR.getVByMonthCompleteTS(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[1],elements=elements[i],missingValues=missingValues)
    tmp[which(tmp[,2]==-99999),2] <- missingValues

    # if several stations
    df <- tmp
    if (length(stations)>1) {
       for ( j in 2:length(stations)) {
          tmp <- wsklimaR.getVByMonthCompleteTS(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations[j],elements=elements[i],missingValues=missingValues)
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
