#' @title drawCovidMap
#'
#' @description Draws the global map of daily covid-19 deaths or confirmed cases
#'
#' @param date the date of which you want the drawn map
#' @param type type of the map. Either Deaths or Confirmed cases
#'
#' @return a leaflet map
#' @export
#' @import leaflet
#' @import viridisLite
#' @import GetoptLong
#' @import RCurl
#'
#' @examples
#' mapOfCovid <- drawCovidMap("07-03-2020","Deaths")
#'

drawCovidMap <-
  function(date,type)
  {
    library(leaflet)
    library(viridisLite)
    library(GetoptLong)
    library(RCurl)
    date_temp <- unlist(strsplit(date,'-'))
    if (as.integer(date_temp[1]) <= 3 & as.integer(date_temp[2]) <= 22)
      return("date is not valid")
    #get covid data
    covid<- betterCallSal::updateCovid(date)

    # set domain
    domain <- range(covid[[type]])

    # make palette
    pal <- colorNumeric(palette = viridis(10000), domain = domain)

    # create leaflet map
    covidMap <- leaflet(covid)  %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      setView(-71.931180, 42.385453, zoom = 7) %>%
      addCircleMarkers(~Long_, ~Lat, popup=covid[[type]], weight = 3, radius=4,
                       color=~pal(covid[[type]]), stroke = F, fillOpacity = 0.5)%>%
      addLegend("bottomright", pal = pal, values = ~covid[[type]],
                title = type)
    return(covidMap)
  }
