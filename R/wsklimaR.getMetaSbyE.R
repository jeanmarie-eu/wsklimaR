#' Get the metadata of the stations given a meteorlogical element
#'
#' wsklimaR.getMetaSbyE makes it possible to get the metadata of the stations from met.no given a meteorological element.
#' It is not recommended to use this function to get metadata of several elements.
#' Indeed, instead of the logic operator AND, wsklima uses the logic operator OR
#' It is highly recommended to use the function wsklimaR.getMetaStationbyElement().
#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector if multi-element
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- wsklimaR.getMetaSbyE(timeserietypeID="0",elements="TAM")

wsklimaR.getMetaSbyE <- function(timeserietypeID, elements){

   wsklimaURL <- wsklimaR.getMetaSbyEsetUrl(timeserietypeID,elements)

   xml_data <- NULL
   try(xml_data <-XML::xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))

   df <- data.frame(
       amsl           = as.character(unlist(XML::xpathApply(xml_data,"//amsl",XML::xmlValue))),
       department     = as.character(unlist(XML::xpathApply(xml_data,"//department",XML::xmlValue))),
       fromDay        = as.character(unlist(XML::xpathApply(xml_data,"//fromDay",XML::xmlValue))),
       fromMonth      = as.character(unlist(XML::xpathApply(xml_data,"//fromMonth",XML::xmlValue))),
       fromYear       = as.character(unlist(XML::xpathApply(xml_data,"//fromYear",XML::xmlValue))),
       latDec         = as.character(unlist(XML::xpathApply(xml_data,"//latDec",XML::xmlValue))),
       lonDec         = as.character(unlist(XML::xpathApply(xml_data,"//lonDec",XML::xmlValue))),
       municipalityNo = as.character(unlist(XML::xpathApply(xml_data,"//municipalityNo",XML::xmlValue))),
       name           = as.character(unlist(XML::xpathApply(xml_data,"//name",XML::xmlValue))),
       stnr           = as.character(unlist(XML::xpathApply(xml_data,"//stnr",XML::xmlValue))),
       toDay          = as.character(unlist(XML::xpathApply(xml_data,"//toDay",XML::xmlValue))),
       toMonth        = as.character(unlist(XML::xpathApply(xml_data,"//toMonth",XML::xmlValue))),
       toYear         = as.character(unlist(XML::xpathApply(xml_data,"//toYear",XML::xmlValue))),
       utm_e          = as.character(unlist(XML::xpathApply(xml_data,"//utm_e",XML::xmlValue))),
       utm_n          = as.character(unlist(XML::xpathApply(xml_data,"//utm_n",XML::xmlValue))),
       utm_zone       = as.character(unlist(XML::xpathApply(xml_data,"//utm_zone",XML::xmlValue))),
       wmoNo          = as.character(unlist(XML::xpathApply(xml_data,"//wmoNo",XML::xmlValue)))
       )

    if (length(as.character(unlist(XML::xpathApply(xml_data,"//fault",XML::xmlValue))))>0)  df <- NULL

  return(df)
}
