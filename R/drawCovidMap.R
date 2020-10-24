#' @title covidMap
#'
#' @description Draws Map of daily covid-19 deaths or confirmed
#'
#'
#' @return a leaflet map
#' @export
#' @importFrom stats rnorm
#'
#' @examples
#' mapOfCovid <- covidMap()
#'

drawCovidMap <-
  function(date,type)
  {
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
