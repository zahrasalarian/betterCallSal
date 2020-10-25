#' @title drawCovidPlot
#'
#' @description Draws the plot of the number of covid-19 deaths and confirmed cases during a time series in a specific country
#'
#' @param period a vector containing the start and end date of the time series
#' @param country name of the chosen country
#'
#' @return a ggplot object
#' @export
#' @import dplyr
#' @import GetoptLong
#' @import tidyverse
#' @import reshape
#' @import ggplot2
#'
#' @examples
#' plotOfCovid <- drawCovidPlot(c("04-02-2020","06-12-2020"),"US")
#'

drawCovidPlot <-
  function(period,country)
  {
    library(dplyr)
    library(GetoptLong)
    library(tidyverse)
    library(reshape)
    library(ggplot2)
    link_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
    link_confirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
    deaths_data<-as.data.frame(read.csv((link_deaths)))
    confirmed_data<-as.data.frame(read.csv((link_confirmed)))

    #change name of columns
    colnames(deaths_data)[2]<- c("Country")
    deaths_data[1]<- NULL
    colnames(confirmed_data)[2]<- c("Country")
    confirmed_data[1]<- NULL

    #filter by country
    deaths_data<- deaths_data%>%
    dplyr::filter(Country == country)%>%
      group_by(Country)%>%
      summarise_each(list(sum))

    confirmed_data<- confirmed_data%>%
      filter(Country == country)%>%
      group_by(Country)%>%
      summarise_each(list(sum))

    a <- unlist(strsplit(period[1],'-'))
    a[3] <- paste(unlist(strsplit(a[3],""))[-1:-2], collapse = "")
    a<- qq("X@{as.integer(a[1])}.@{as.integer(a[2])}.@{as.integer(a[3])}")
    b <- unlist(strsplit(period[2],'-'))
    b[3] <- paste(unlist(strsplit(b[3],""))[-1:-2], collapse = "")
    b<- qq("X@{as.integer(b[1])}.@{as.integer(b[2])}.@{as.integer(b[3])}")

    a_deaths <-grep(a, colnames(deaths_data))
    b_deaths <-grep(b, colnames(deaths_data))
    deaths_data<- deaths_data[a_deaths:b_deaths]

    a_confirmed <- grep(a, colnames(confirmed_data))
    b_confirmed <- grep(b, colnames(confirmed_data))
    confirmed_data<- confirmed_data[a_confirmed:b_confirmed]

    #reshape
    deaths_data <- as.data.frame(t(deaths_data))
    deaths_data$date <- rownames(deaths_data)
    deaths_data<- melt(deaths_data, id.vars=c("date"))
    deaths_data$type <- "deaths"
    deaths_data$seq <- seq.int(nrow(deaths_data))

    confirmed_data <- as.data.frame(t(confirmed_data))
    confirmed_data$date <- rownames(confirmed_data)
    confirmed_data<- melt(confirmed_data, id.vars=c("date"))
    confirmed_data$type <- "confirmed"
    confirmed_data$seq <- seq.int(nrow(confirmed_data))

    #combine
    full_data <- rbind(confirmed_data,deaths_data)

    p<- ggplot(data=full_data, aes(x=date, y=value, fill=type, color=type, alpha=type)) +
      geom_bar(stat="identity", position ="identity") +
      scale_colour_manual(values=c("lightblue4", "red")) +
      scale_fill_manual(values=c("lightblue", "pink")) +
      scale_alpha_manual(values=c(.3, .8))
    return(p)

  }
