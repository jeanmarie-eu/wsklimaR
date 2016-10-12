#' Get the metadata of the meteorlogical element for a specific time resolution
#'
#' wsklimaR.getMetaElement makes it possible to get the metadata of meteorological elements measured by met.no's stations
#'
#' The output is a dataframe. This structure eases the conversion into json

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param elements TAM, RR, ..
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- wsklimaR.getMetaElement(timeserietypeID="2")
#' str(tmp)
#' tmp <- wsklimaR.getMetaElement(timeserietypeID="0",station=180)
#' str(tmp)
wsklimaR.getMetaElement <- function(timeserietypeID,station=NULL) {

   wsklimaURL <- getMetaEsetUrl(timeserietypeID=timeserietypeID,station=station)
   xml_data <- NULL
   try(xml_data <-xmlTreeParse(wsklimaURL, useInternal = T,encoding = "UTF-8"))
   df <- data.frame(
         description = as.character(unlist(xpathApply(xml_data,"//description",xmlValue))),
		     element = as.character(unlist(xpathApply(xml_data,"//elemCode",xmlValue))),
		     elementGroup = as.character(unlist(xpathApply(xml_data,"//elemGroup",xmlValue))),
		     elementNo = as.character(unlist(xpathApply(xml_data,"//elemNo",xmlValue))),
		     fromDate = as.character(unlist(xpathApply(xml_data,"//fromdate",xmlValue))),
		     language = as.character(unlist(xpathApply(xml_data,"//language",xmlValue))),
		     name = as.character(unlist(xpathApply(xml_data,"//name",xmlValue))),
		     toDate = as.character(unlist(xpathApply(xml_data,"//todate",xmlValue))),
		     unit = as.character(unlist(xpathApply(xml_data,"//unit",xmlValue)))
         )

   return(df)
}
