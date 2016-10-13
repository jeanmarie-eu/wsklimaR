#' Get the metadata of the meteorlogical element for a specific time resolution
#'
#' wsklimaR.getMetaElement makes it possible to get the metadata of meteorological elements measured by met.no's stations
#'
#' The output is a dataframe. This structure eases the conversion into json

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param stations id of the stations. Can be a vector if multi-stations
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- wsklimaR.getMetaElement(timeserietypeID="2")
#' str(tmp)
#' tmp <- wsklimaR.getMetaElement(timeserietypeID="0",stations=180)
#' str(tmp)
wsklimaR.getMetaElement <- function(timeserietypeID,stations=NULL) {

   wsklimaURL <- getMetaEsetUrl(timeserietypeID=timeserietypeID,stations=stations)
   xml_data <- NULL
   try(xml_data <-XML::xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))
   df <- data.frame(
         description  = as.character(unlist(XML::xpathApply(xml_data,"//description",XML::xmlValue))),
		     element      = as.character(unlist(XML::xpathApply(xml_data,"//elemCode",XML::xmlValue))),
		     elementGroup = as.character(unlist(XML::xpathApply(xml_data,"//elemGroup",XML::xmlValue))),
		     elementNo    = as.character(unlist(XML::xpathApply(xml_data,"//elemNo",XML::xmlValue))),
		     fromDate     = as.character(unlist(XML::xpathApply(xml_data,"//fromdate",XML::xmlValue))),
		     language     = as.character(unlist(XML::xpathApply(xml_data,"//language",XML::xmlValue))),
		     name         = as.character(unlist(XML::xpathApply(xml_data,"//name",XML::xmlValue))),
		     toDate       = as.character(unlist(XML::xpathApply(xml_data,"//todate",XML::xmlValue))),
		     unit         = as.character(unlist(XML::xpathApply(xml_data,"//unit",XML::xmlValue)))
         )

   return(df)
}
