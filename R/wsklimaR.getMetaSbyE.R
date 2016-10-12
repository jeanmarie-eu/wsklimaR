#' Get the metadata of the stations given a meteorlogical element
#'
#' wsklimaR.getMetaSbyE makes it possible to get the metadata of the stations from met.no given a meteorological element.
#' It is not recommended to use this function to get metadata of several elements.
#' Indeed, instead of the logic operator AND, wsklima uses the logic operator OR
#' It is highly recommended to use the function wsklimaR.getMetaStationbyElement().
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param elements TAM, RR, ..
#' @keywords wsklimaR
#' @export
#' @examples
#' wsklimaR.getMetaSbyE(timeserietypeID="1", fromPeriod="20130101",toPeriod="20130105",stations="180",elements="TAM")

wsklimaR.getMetaSbyE <- function(timeserietypeID, elements){

   wsklimaURL <- wsklimaR.getMetaSbyEsetUrl(timeserietypeID,elements)

   xml_data <- NULL
   try(xml_data <-xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))

   df <- data.frame(
       amsl = as.character(unlist(xpathApply(xml_data,"//amsl",xmlValue))),
       department = as.character(unlist(xpathApply(xml_data,"//department",xmlValue))),
       fromDay = as.character(unlist(xpathApply(xml_data,"//fromDay",xmlValue))),
       fromMonth = as.character(unlist(xpathApply(xml_data,"//fromMonth",xmlValue))),
       fromYear = as.character(unlist(xpathApply(xml_data,"//fromYear",xmlValue))),
       latDec = as.character(unlist(xpathApply(xml_data,"//latDec",xmlValue))),
       lonDec = as.character(unlist(xpathApply(xml_data,"//lonDec",xmlValue))),
       municipalityNo = as.character(unlist(xpathApply(xml_data,"//municipalityNo",xmlValue))),
       name = as.character(unlist(xpathApply(xml_data,"//name",xmlValue))),
       stnr = as.character(unlist(xpathApply(xml_data,"//stnr",xmlValue))),
       toDay = as.character(unlist(xpathApply(xml_data,"//toDay",xmlValue))),
       toMonth = as.character(unlist(xpathApply(xml_data,"//toMonth",xmlValue))),
       toYear = as.character(unlist(xpathApply(xml_data,"//toYear",xmlValue))),
       utm_e = as.character(unlist(xpathApply(xml_data,"//utm_e",xmlValue))),
       utm_n = as.character(unlist(xpathApply(xml_data,"//utm_n",xmlValue))),
       utm_zone = as.character(unlist(xpathApply(xml_data,"//utm_zone",xmlValue))),
       wmoNo = as.character(unlist(xpathApply(xml_data,"//wmoNo",xmlValue)))
       )

    if (length(as.character(unlist(xpathApply(xml_data,"//fault",xmlValue))))>0)  df <- NULL

  return(df)
}
