library(dplyr)
#1.
date=as.POSIXct("03-20-2018",format="%m-%d-%Y")
date
class(date)

#2. 
library(lubridate)
date=mdy("03-20-2018")
date
date1=dmy("20-03-2018")
date1

ymd("2018-03-20")
ymd("2018.03/20")
ymd("20180320")
ymd("180320")

mdy_hms("03-20-2018 14:22:0",tz="America/New_York")
hm("1:45")

#3.
snow=read.csv("snowdates.csv")
head(snow)
str(snow)
snow$date=ymd(snow$date)
str(snow)

library(ggplot2)

ggplot(snow,aes(x=date,y=deaths))+geom_point()

#4
date=now()
date
year(date)
wday(date)
week(date)
wday(date,label=T)

wday(date,label=T)
wday(date,label=T,abbr=F) 


#ccreate a vector that contains two date type variables
date=c("2018/3/15","2018/3/20")
class(date)
mode(date)
date=ymd(date)
date
class(date) #date
date %>% day %>% mean
mean(day(date))

#5.
start_2011=ymd_hms("2011-01-01 12:00:00")
start_2011
?ymd_hms

start_2011+minutes(1)+hours(1)+days(365)

#6
start_2012 = ymd_hms("2012-01-01 12:00:00")
start_2012+days(365)
start_2012+years(1) #leap year

#7
collision=load("collisiondata.rda")
head(collision)
glimpse(collision)#??????

#11
apple=read.csv("AAPL.csv")
google=read.csv("GOOG.csv")
amazon=read.csv("AMZN.csv")
colnames(apple)

apple$Date=ymd(apple$Date)
google$Date=ymd(google$Date)
amazon$Date=ymd(amazon$Date)

#change the format
apple$Adj.Close=as.numeric(apple$Adj.Close)
glimpse(apple)
google$Adj.Close=as.numeric(google$Adj.Close)
amazon$Adj.Close=as.numeric(amazon$Adj.Close)

str(apple)
head(apple)

#plot all three stocks
#origin Jan 1 2006

apple %>% filter(Date>dmy("1-1-2016")) %>% ggplot(aes(x=Date,y=Adj.Close))+geom_line()

apple = apple %>% filter(Date>dmy("1-1-2016")) 
google = google %>% filter(Date>dmy("1-1-2016")) 
amazon = amazon %>% filter(Date>dmy("1-1-2016")) 

ggplot(apple,aes(x=Date,y=Adj.Close))+geom_line()+geom_line(data=google,aes(x=Date,y=Adj.Close),colour="red")+
  geom_line(data=amazon,aes(x=Date,y=Adj.Close),colour="blue")
##package: quantmod

library(quantmod)
getSymbols("GOOG",src="yahoo") # from yahoo finance 
head(GOOG)

date=mdy("11-01-2018")
wday(date,label=T)
date+weeks(4)

#####################
plot(1:10)
