#' Get the metadata of the stations given several meteorlogical element
#'
#' wsklimaR.getMetaStationbyElement makes it possible to get the metadata of the met.no's stations that measure all the chosen meteorological elements.
#'
#' The output is a dataframe. This structure eases the conversion into json

#' @param timeserietypeID 0:Daily, 1:Monthly, 2:Observations-hourly based, 3:Normal Monthly, 4: Normal Daily, 5:Record Daily (not used)
#' @param elements TAM, RR, ..
#' @keywords wsklimaR
#' @export
#' @examples
#' tmp <- wsklimaR.getMetaStationbyElement(timeserietypeID="2",elements="TA")
#' str(tmp)
#' tmp <- wsklimaR.getMetaStationbyElement(timeserietypeID="0",elements=c("TAM","RR"))
#' str(tmp)
wsklimaR.getMetaStationbyElement <- function(timeserietypeID,elements) {
  if (length(elements)>1) {
     df <- wsklimaR.getMetaSbyE(timeserietypeID,elements[1])
     stations <- df$stnr
     for ( i in 2:length(elements)) {
       tmp <- wsklimaR.getMetaSbyE(timeserietypeID,elements[i])
       indice<-match(stations,tmp$stnr)
       if (length(indice)>0) {
          stations <- na.omit(tmp$stnr[indice])
       } else stop("No stations with all the specified elements")
     }
     if (length(stations)>0) {
        indice<-match(stations,df$stnr)
        df <- df[indice,]
     } else  stop("No stations with all the specified elements")
  } else df <- wsklimaR.getMetaSbyE(timeserietypeID,elements)

  return(df)
}
