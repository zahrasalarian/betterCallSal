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

covidMap <-
  function()
  {
    #get covid data
    covid<- betterCallSal::updateCovid()

    # set domain
    domain <- range(covid$Deaths)

    # make palette
    pal <- colorNumeric(palette = viridis(10000), domain = domain)

    # create leaflet map
    covidMap <- leaflet(covid)  %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      setView(-71.931180, 42.385453, zoom = 7) %>%
      addCircleMarkers(~Long_, ~Lat, popup=covid$Deaths, weight = 3, radius=4,
                       color=~pal(Deaths), stroke = F, fillOpacity = 0.5)%>%
      addLegend("bottomright", pal = pal, values = ~Deaths,
                title = "Deaths")
    return(covidMap)
  }
