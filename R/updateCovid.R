#' @title updateCovid
#'
#' @description Gives updated covid-19 data from Johns Hopkins University's github
#'
#' @param date the date to which you want to update your data
#'
#' @return a dataframe of data
#' @export
#' @import GetoptLong
#' @import readr
#' @import RCurl
#'
#' @examples
#' updatedCovidData <- updateCovid("06-10-2020")
#'

updateCovid <-
  function(date)
  {
    library(GetoptLong)
    library(readr)
    library(RCurl)
    #date <- unlist(strsplit(date,'-'))
    #if (date == as.character(Sys.Date()))
    #  date[3]<- as.character(as.integer(date[3]) - 1)
    #date <- paste(date[2],date[3],date[1],sep="-")
    link <- qq("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/@{date}.csv")
    covidData<-as.data.frame(read.csv((link)))
    return(covidData)
  }
