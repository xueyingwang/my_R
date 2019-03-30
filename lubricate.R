#1.
todays_date=as.POSIXct("03-02-2018",format="%m-%d-%Y")
class(todays_date)
unclass(todays_date)
as.numeric(todays_date)

#2
library(lubridate)
mdy_hms("03-08-2018 4:49:10",tz="EST")
