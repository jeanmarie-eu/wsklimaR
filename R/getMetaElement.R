#' Get the metadata of the meteorlogical element for a specific time resolution
#'
#' The function \code{getMetaElement()} makes it possible to get the metadata of meteorological elements measured by stations registered by met.no
#'
#' The output is a dataframe. This structure eases the conversion into json

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param stations id of the stations. Can be NULL, a scalar or a vector of station ids
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- getMetaElement(timeserietypeID="2")
#' str(tmp)
#' tmp <- getMetaElement(timeserietypeID="0",stations=180)
#' str(tmp)
getMetaElement <- function(timeserietypeID,
                           stations = NULL) {

   df <- getMetaE(timeserietypeID=timeserietypeID,stations=stations)

   return(df)
}
