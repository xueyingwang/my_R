# A line chart or line graph is a type of chart which displays information as a series of data points called ‘markers’ 
# connected by straight line segments. It is similar to a scatter plot except that the measurement
# points are ordered (typically by their x-axis value) and joined with straight line segments.
# Line graphs are typically used for visualizing how one continous varaible, on the y-axis, 
# changes in relation to another continous variable, on the x-axis. Often the x variable represent time, 
# but it may also represent some other continous quantity, like the amount of a drung administered to experimental subjects.
# Line graphs can also be used with a discrete variable on the x-axis. This is appropriate when the variable is ordered 
# (e.g. “small”, “medium”, “large”), but not when the variable is unordered (e.g. “cow”, “goose”,"pig")                                                                                                                                                                           “pig”).

#1.
library(ggplot2)

#2
?BOD
BOD
head(BOD,3)

#3
plot(BOD[,])
plot(x=BOD[,1],y=BOD[,2])
plot(x=BOD[,1],y=BOD[,2],type="l") 
plot(x=BOD[,1],y=BOD[,2],type="b") 
plot(x=BOD[,1],y=BOD[,2],type="b",lwd=5) 

ggplot(BOD,aes(x=Time,y=demand))+geom_line()

#4
ggplot(BOD,aes(x=factor(Time),y=demand))+geom_line() #ERROR
#When the x variable is a factor, you must also use aes(group = 1) to tell ggplot() that the data points belong together 
#and should be connected with a line. 

#5 
ggplot(BOD,aes(x=factor(Time),y=demand,group=1))+geom_line()+xlab("Time")

#6 add a dashed red vertical line. Indicate that x axis is discrete and y is continuous
ggplot(BOD,aes(x=factor(Time),y=demand,group=1))+geom_line()+xlab("Time")+geom_vline(xintercept=3,color="red",linetype="dashed")+
  scale_x_discrete(name="",breaks=1:7,labels=paste("Min",1:7))+scale_y_continuous(name="Demand",breaks=8:20,labels=8:20)+theme_bw() #remove the grey background

plot(x=BOD[,1],y=BOD[,2],type="l",axes=F, ylim=c(0,max(BOD$demand)),xlab = "time",ylab="Demand")
axis(1,at=c(1,4,7),labels=paste("Min",c(1,4,6)))
axis(2)
box()
abline(v=3,lty=3,col="red")

#7 Expand y limits from 0
ggplot(BOD,aes(x=factor(Time),y=demand,group=1))+geom_line()+xlab("Time")+expand_limits(y=0)

#8 Indicat each points by geom_point
ggplot(BOD,aes(x=factor(Time),y=demand,group=1))+geom_line()+xlab("Time")+expand_limits(y=0)+geom_point(size=4)


?ToothGrowth
str(ToothGrowth)

#9 Group data and compute mean for each group, where the groups are specifies by each combination of supp and dose
library(dplyr)
ToothGrowth %>% group_by(supp,dose) %>% summarise(mean_length=mean(len))
unique(ToothGrowth[,3])

#10 Visulize how mean length of teeth changes with different doses using different supplements. Include colour=sup and linetype=supp
ToothGrowth %>% group_by(supp,dose) %>% summarise(mean_length=mean(len)) %>% 
  ggplot(aes(x=dose,y=mean_length,color=supp))+geom_line()+ylab("Average length")

#11 see group -> supp
ToothGrowth %>% group_by(supp,dose) %>% summarise(mean_length=mean(len)) %>% 
  ggplot(aes(x=dose,y=mean_length,color=supp,linetype=supp,group=supp))+geom_line()+ylab("Average length")

#12 add points to plot and map variables to propertites of points. such as shape and fill
ToothGrowth %>% group_by(supp,dose) %>% summarise(mean_length=mean(len)) %>% 
  ggplot(aes(x=dose,y=mean_length,color=supp,linetype=supp,group=supp))+geom_line(color="blue",linetype="dashed",size=1)+
  ylab("Average length")+xlab("Dose")+geom_point(size=7,shape=21)


ggplot(ToothGrowth, aes(x=factor(dose),y=len,fill=supp,group = supp)) + geom_line(color = "lightblue", size = 2, linetype = "dashed") 
  + geom_point(size = 7, shape = 21) # 21: empty circle

#To find out the different point shapes (25 different shapes)
pts=data.frame(x=1:25,y=rep(10,25))
ggplot(pts,aes(x=factor(x),y=y))+geom_point(color=1:25,shape=1:25,size=2) #learn different shapes

library(gcookbook)
str(uspopage)

data <- filter(uspopage, AgeGroup == "<5") 
head(data)
#make graph wiht shaded area
ggplot(data, aes(x = Year, y = Thousands)) + geom_area(fill = "blue", alpha = 0.2) + geom_line()

class(sunspot.year) #ts: time series

sunspot_df = data.frame(year = as.numeric(time(sunspot.year)), sunspots = as.numeric(sunspot.year))
ggplot(sunspot_df, aes(x = year, y = sunspots)) + geom_area(fill = "blue", alpha = .2, color = "black")

ggplot(sunspot_df, aes(x = year, y = sunspots)) + geom_area(fill = "blue", alpha = .2) + geom_line()

######Making a stacked graph########
ggplot(uspopage, aes(x = Year, y = Thousands, fill = AgeGroup)) + geom_area()

library(dplyr) # for desc()
ggplot(uspopage, aes(x = Year, y = Thousands, fill = AgeGroup, order = desc(AgeGroup))) +
  geom_area(color = "black", size = 0.6, alpha = 0.4) + ylab("Population Size (in thousands)")

#Get rid of the line
ggplot(uspopage, aes(x = Year, y = Thousands, fill = AgeGroup, order = desc(AgeGroup))) +
  geom_area(alpha = 0.4) + geom_line(position = "stack", size = 0.2)+ ylab("Population Size (in thousands)")


#############Making propotional stack graph
library(gcookbook)
library(dplyr)
# convert Thousands to Percent
uspopage_prop <- uspopage %>%
  group_by(Year) %>%
  mutate(Percent = Thousands /sum(Thousands) * 100)
ggplot(uspopage_prop, aes(x = Year, y = Percent, fill = AgeGroup , order = desc(AgeGroup)))+geom_area(alpha = 0.8) + 
  geom_line(position = "stack", size = 0.1)
