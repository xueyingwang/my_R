date1=as.Date("2018-03-08")
date1
class(date1)
as.numeric(date1)

date2=as.POSIXct("2018-03-08 12:37")
date2
class(date2)
as.numeric(date2)

class(date1)
class(as.numeric(date1))


## locale-specific version of the date

Sys.Date()
format(Sys.Date(), "%a %b %d")

x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
z <- as.Date(x, "%d%b%Y")



## read in date/time info in format 'm/d/y'
dates <- c("02/27/92", "02/27/92", "01/14/92", "02/28/92", "02/01/92")
dates
as.Date(dates, "%m/%d/%y")
as.factor(dates)


## date given as number of days since 1900-01-01 (a date in 1989)
as.Date(32768, origin = "1900-01-01")


## Time zone effect
z <- ISOdate(2010, 04, 13, c(0,12)) # midnight and midday UTC
z
as.Date(z) # in UTC
## these time zone names are common
as.Date(z, tz = "America/Los_Angeles")
as.Date(z, tz = "HST") # Hawaii





# current time as POSIXct
unclass(Sys.time())

# and as POSIXlt
unclass(as.POSIXlt(Sys.time()))





date.lookup <- format(seq(as.Date("2018-01-01"), as.Date(Sys.time()), by = "1 day"))
match("2018-02-15", date.lookup)
date.lookup[35]



# create a date
as.Date("2018-03-08")

# specify the format
as.Date("03/08/2018", format = "%m/%d/%Y")

# use a different origin, for instance importing values from Excel
as.Date(43165, origin = "1900-01-01")



# take a difference
Sys.Date() - as.Date("1970-01-01")

# alternate method with specified units
difftime(Sys.Date(), as.Date("1970-01-01"), units = "days")

# see the internal integer representation
unclass(Sys.Date())


library(lubridate)
ymd_hms("2018-03-08 2:00:00")


ldate <- mdy_hms("03/07/2018 23:59:59")
ldate + seconds(1)

month(ldate)



































