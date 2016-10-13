#' Get the complete timeseries for one meteorlogical element at one station by month
#'
#' The processs is split by month of the period in order to make the wsklima server not to send you an error
#' The timeserie is checked and filling-in by missing values in case of missing dates
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod
#' @param toPeriod
#' @param stations
#' @param elements TAM, RR, ...
#' @param missingValues
#' @keywords wsklimaR
#' @export
#' @examples
#' wsklimaR.getVByMonthCompleteTS(timeserietypeID="1", fromPeriod="20130101",toPeriod="20130105",stations="180",elements="TAM",missingValues=-999)

wsklimaR.getVByMonthCompleteTS <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {

  # get values by month: avoid to crash wsklima server
  df <- wsklimaR.getVByMonth(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements)
  # filling-in by missing values when missing dates
  df <- wsklimaR.checkDateTS(timeserie=df,timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,missingValue=missingValues);
	return(df)
}
