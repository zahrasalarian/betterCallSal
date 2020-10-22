# get updated covid-19 data
updateCovid <-
  function()
  {
    library(GetoptLong)
    library(readr)
    date <- unlist(strsplit(as.character(Sys.Date()),'-'))
    date[3]<- as.character(as.integer(date[3]) - 1)
    date <- paste(date[2],date[3],date[1],sep="-")
    library(RCurl)
    link <- qq("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/@{date}.csv")
    covidData<-as.data.frame(read.csv((link)))
    return(covidData)
  }
