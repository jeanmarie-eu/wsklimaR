#' Get the metadata of the stations given several meteorlogical element
#'
#' The function \code{getMetaStationbyElem()} makes it possible to get the metadata of stations, registered by met.no, that measure all the chosen meteorological elements.
#'
#' The output is a dataframe. This structure eases the conversion into json

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Hourly, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param elements meteorlogical element as its code ("TAM", "RR", ...). Can be a vector of elements
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- getMetaStationbyElem(timeserietypeID="2",elements="TA")
#' str(tmp)
#' tmp <- getMetaStationbyElem(timeserietypeID="0",elements=c("TAM","RR"))
#' str(tmp)
getMetaStationbyElem <- function(timeserietypeID,elements) {

  df <- getMetaSbyEl(timeserietypeID,elements[1])

  return(df)
}
