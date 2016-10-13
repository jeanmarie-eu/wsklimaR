#' Get the complete timeseries fo one element at one station
#'
#' The timeserie is checked and filling-in by missing values in case of missing dates
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param fromPeriod string of character yyyymmdd
#' @param toPeriod string of character yyyymmdd
#' @param stations id of the stations.
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector if multi-element.
#' @param missingValues value of the expected mssing values.
#' @keywords wsklimaR
#' @export
#' @examples
#' wsklimaR.getVCompleteTS(timeserietypeID="0",
#'                         fromPeriod="20130101",
#'                          toPeriod="20130105",
#'                          stations="180",
#'                          elements="TAM",
#'                          missingValues=-999)

wsklimaR.getVCompleteTS <- function(timeserietypeID,fromPeriod,toPeriod,stations,elements,missingValues) {

  # get values
  df <- wsklimaR.getV(timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,stations=stations,elements=elements)
  # filling-in by missing values when missing dates
  df <- wsklimaR.checkDateTS(timeserie=df,timeserietypeID=timeserietypeID,fromPeriod=fromPeriod,toPeriod=toPeriod,missingValues=missingValues);
	return(df)
}
