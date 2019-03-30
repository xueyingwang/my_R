library(scales)
library(ggplot2)
baggage=read.csv("Baggage.csv",stringsAsFactors = FALSE)
AEbaggage=baggage[baggage$Airline=="American Eagle",]
HAbaggage=baggage[baggage$Airline=="Hawaiian",]
UAbaggage=baggage[baggage$Airline=="United",]

#1.	Explore baggage complaints over time: create 3 time series plots for the variable Baggage by Date for each of the airlines separately. 

par(mfrow=c(3,1))
tsAE=ts(AEbaggage$Baggage)
tsHA=ts(HAbaggage$Baggage)
tsUA=ts(UAbaggage$Baggage)
plot(x=AEbaggage$Date,y=tsAE,color="black",main="American Eagle Airline",
     xlab="date",ylab="# of claied baggage")
plot(x=HAbaggage$Date,y=tsHA,color="green",main="Hawaiian Airline",
     xlab="date",ylab="# of claied baggage")
plot(x=UAbaggage$Date,y=tsUA,color="blue",main="United Airline",
     xlab="date",ylab="# of claied baggage")

#2.	Briefly describe what patterns, if any, you see in the plots in 1.
#[I think they are seasonal. It looks like a sin/cos wave. The United Airline has the highest baggage lost. Then Americican Eagle has the less highest
#baggae lost. This is probabliy because of the size of the airlines.]

#3.	To compare each month’s data in different years, superimpose each year’s Baggage by month on a single graph for each airline. Your answer consists of 3 time series plots. 

AEbaggage$Date=as.Date(AEbaggage$Date,format='%m/%Y')

ggplot(data=AEbaggage,aes(x=Month,y=Baggage))+geom_point(aes(colour=factor(Year)))+geom_line(aes(linetype=factor(Year),colour=factor(Year)))+xlim(1,12)+
  labs(subtitle="Baggage complaints in each month(2004 - 2010) for American Eagle",y="# of baggage claims")

ggplot(data=HAbaggage,aes(x=Month,y=Baggage))+geom_point(aes(colour=factor(Year)))+geom_line(aes(linetype=factor(Year),colour=factor(Year)))+xlim(1,12)+
  labs(subtitle="Baggage complaints in each month(2004 - 2010) for Hawaiian Airline",y="# of baggage claims")

ggplot(data=UAbaggage,aes(x=Month,y=Baggage))+geom_point(aes(colour=as.factor(Year)))+geom_line(aes(linetype=as.factor(Year),colour=as.factor(Year)))+xlim(1,12)+
  labs(subtitle="Baggage complaints in each month(2004 - 2010) for United Airline",y="# of baggage claims")


#4 Briefly describe what patterns, if any, you see in the plots in 3.
#[I think there are seasonal. It looks like a sin/cos wave. The United Airline has the highest baggage lost. Then Americican Eagle has the less highest
#baggae lost. This is because of the size of the airlines.]

#5 To better compare the baggage complaints for three airlines, plot all three airline Baggage data by Date on one graph.
ggplot(data=baggage,aes(x=Date,y=Baggage))+geom_point(aes(color=factor(Airline)))+geom_line(aes(linetype=factor(Airline)))+
  labs(subtitle="Baggage complaints in each month(2004 - 2010) for American Eagle, Hawaiian and United Airline",y="# of baggage claims")

#6	Based on the graph in question 5., do some airlines have better baggage handling practices?
#[ Hawaiian Airline has way less baggage claims ]


#7	Based on the graph in question 5., which airline has the best record? The worst?
#[Hawaiian Airline has the best record and the united airline has the worst record]


#8	Based on the graph in question 5., are complaints getting better or worse over time?
#[For Hawaiian Airline, the complaints always stay the same flunctuaion. For United Airline, the complaints get worse. UA and AE all fluctuate a lot. ]


#9	Are the conclusions, you have drawn based on the graphs of the raw data you created, accurate? 
#Are there any potential factors that may distort your conclusions and should be taken into consideration?
#Answer: [I think only looking at the cliamed baggages is too biased. We should consider the airline sizes, numbers of scheduled flights and cancelled,
#and totol number of passengers who boarded.]

#10	Report the average of scheduled flights and the average of enplaned passengers by airline. 
#Answer:  Mean of Scheduled flight:
#AE:#41314.05    HA:4844.679  UA: 38225.3
#Mean of enplaned passengers 
#AE:1396726    HA:594174.2    UA: 4620712
mean(AEbaggage$Scheduled)#41314.05
mean(HAbaggage$Scheduled)#4844.679
mean(UAbaggage$Scheduled)#38225.3
mean(AEbaggage$Enplaned)#1396726
mean(HAbaggage$Enplaned)#594174.2
mean(UAbaggage$Enplaned)#4620712

#11.	What insights, ideas, and concerns does the data in the table in 10. provide you with?
#[The Hawaiian Airline has the smallest amounts of average scheduled flights and enplanned passengers. UA has the second smallest amounts of scheduled flights
#but largest enplanned passengers. AE airline has the largest amounts of scheduled flight but middle amounts of enplanned passengers.]


#12.	Create a KPI that adjusts the total number of passenger complaints for size in the following way: Baggage % = Baggage / Enplaned ×100 %. Display average Baggage % for each airline.
#[American Eagle: 1.033%, Hawaiian Airline: 0.277%, United Airline: 0.464% ]
baggage$baggagepercent=baggage$Baggage/baggage$Enplaned
mean(as.numeric(baggage[baggage$Airline =='American Eagle',]$baggagepercent)) #1.033%
mean(as.numeric(baggage[baggage$Airline =='Hawaiian',]$baggagepercent))  
mean(as.numeric(baggage[baggage$Airline =='United',]$baggagepercent))
baggage$baggagepercent=percent(baggage$Baggage/baggage$Enplaned) #percentage

#13.	Do the results in question 12 support your previous conclusions? Briefly explain.
#[No, the results are quite surprising. The Hawaiian seems has the best baggage percent KPI. Then United Airlines has the second best KPI and AE has the worst KPI.
#From the previous group, UA seems has more baggage lost claims than AE. However, we see it is opposite in the KPI. ]


#14.	Superimpose all three time series on one graph to display Baggage % by Date. 
as.numeric(sub("%","",baggage$baggagepercent))/100
AETS=ts(AEbaggage$baggagepercent)
HATS=ts(HAbaggage$baggagepercent)
UATS=ts(UAbaggage$baggagepercent)

par(mfrow=c(3,1))
plot(x=AEbaggage$Date,y=AETS,type="b",main="American Eagle")
plot(x=AEbaggage$Date,y=HATS,type="b",main="Hawaiian Airline")
plot(x=AEbaggage$Date,y=UATS,type="b",main="United Airline")


#15.	In addition to the graph in question 14., would plotting each series on a separate graph be beneficial and why? Create a graph to support your answer.  
#[Yes, I think ploting each series on a separate graph will be beneficial because since Time Series is used to check the seasonality, trend, long run cycle
#of one thing. We should more focus on one graph for each airline instead of looking at them together]

ggplot(data=AEbaggage,aes(x=Date,y=AETS,group=1))+geom_line()+theme(axis.text.x = element_text(angle=45))
ggplot(data=HAbaggage,aes(x=Date,y=HATS,group=2))+geom_line()+theme(axis.text.x = element_text(angle=45))
ggplot(data=UAbaggage,aes(x=Date,y=UATS,group=1))+geom_line()+theme(axis.text.x = element_text(angle=45))

 
#16.	Based on the analysis of KPI Baggage %, have any of your conclusions drawn in questions 6. - 8. changed? Briefly discuss.
#[Yes. The answer changed.Now Hawaiian Airline has the best KPI of lugagge lost.Then AE and UA fluctuate a lot.
#Then United Airlines has the second best KIP and AE has the worst KPI.]

#17.	Superimpose time series plots of monthly averages of Baggage % by time for the three airlines.
?rowMeans
bagAE=c()
bagHA=c()
bagUA=c()
for(j in 1:12){
  bagAE[j]=mean(AEbaggage[AEbaggage$Month==j,]$baggagepercent)
}
for(j in 1:12){
  bagHA[j]=mean(HAbaggage[HAbaggage$Month==j,]$baggagepercent)
}
for(j in 1:12){
  bagUA[j]=mean(UAbaggage[UAbaggage$Month==j,]$baggagepercent)
}
bagAE
par(mfrow=c(3,1))
plot(x=1:12,y=ts(bagAE),type="b",main="American Eagle")
plot(x=1:12,y=ts(bagHA),type="b",main="Hawaiian Airline")
plot(x=1:12,y=ts(bagUA),type="b",main="United Airline")

#18.	Discuss common patterns all three time series exhibit in question 17.
#[For all three airlines, they all share the same pattern: there is a peak at January, June and December. I think this is because there are holidays in these months.]

#19.	Create a timeplot of Baggage %, add average line of Baggage % and  a Trendline (regression line) of monthly average Baggage %’s for each airline. Hint: total of 3 charts; each chart 3 superimposed trajectories. 
library(Hmisc)
ggplot(data=AEbaggage,aes(x=Month,y=baggagepercent)) + geom_line(aes(linetype=factor(Year))) + stat_summary(fun.data=mean_cl_normal,geom="point")+geom_smooth(method='lm') # geom_hline(yintercept = mean(bagAE), color="blue")
ggplot(data=HAbaggage,aes(x=Month,y=baggagepercent)) + geom_line(aes(linetype=factor(Year))) + stat_summary(fun.data=mean_cl_normal,geom="point")+geom_smooth(method='lm')
ggplot(data=UAbaggage,aes(x=Month,y=baggagepercent)) + geom_line(aes(linetype=factor(Year))) + stat_summary(fun.data=mean_cl_normal,geom="point")+geom_smooth(method='lm')

#20. Prepare a brief (one paragraph) executive summary of your findings.  
#[After we choose the right KPI(percentage baggage lost) to look with, we find that the Hawaiian seems has the best baggage percent KPI. 
#Then United Airlines has the second best KPI and AE has the worst KPI. However, if we see the baggage lost in total, UA seems has more
#baggage lost claims than AE. Hawaiian has the smallest amounts of baggage lost.]


# ----------------------------------------------------------------Case 2----------------------------------------------------------------------------
ceo_comp=read.csv("CEOcompensation.txt", sep="\t")
industrymedian=read.csv("IndustryMedians.csv")

#1.	What is the number of female CEOs? [ 2 female CEOs ] 
length(which(ceo_comp$Gender=="F"))

#2.	What is the age of a youngest CEO? [youngest: 45]
min(ceo_comp$Age)

#3.	What is the age of the oldest CEO? [oldest: 81]
max(ceo_comp$Age)

#4.	What is the average age of a CEO? [average = 58.38]
mean(ceo_comp$Age)

#5.	What is the total CEO 2008 salary? [$201.8Million]
sum(ceo_comp$X2008.Salary)

#6.	How many CEOs have joined a company as a CEO? [166]
length(which(ceo_comp$Founder=="No"))

#7 What is the average amount of time a CEO worked for a company before becoming a CEO? (Use two decimal digit precision)
#[11.51 years]
mean(ceo_comp$Years.with.company-ceo_comp$Years.as.company.CEO)

#8 Which industry in the data set has largest number CEO’s? 
#[Oil & Gas Operations]

table(ceo_comp$Industry)
max(table(ceo_comp$Industry))

#9 What is the average CEO 2008 Compensation? Note that 2008 compensation for a CEO consists of a total four components: Salary, Bonus, other (including vested restricted stock grants, LTIP (long-term incentive plan) payouts, and perks), and stock gains. (Use two decimal digit precision)
#[$18.68 M]
ceo_comp$x2008compensation=ceo_comp$X2008.Salary+ceo_comp$X2008.Bonus+
  ceo_comp$X2008.Other+ceo_comp$X2008.Stock.gains
mean(ceo_comp$x2008compensation)

#10	Which CEO did get paid the largest compensation amount in 2008? 
#[Lawrence J Ellison]
ceo_comp$CEO[which(ceo_comp$x2008compensation==max(ceo_comp$x2008compensation))]

#11 What is the corresponding amount? (Use two decimal digit precision)
#[$556.98 M]
max(ceo_comp$x2008compensation)

#12	Which industry does correspond to the second largest total CEO compensation in 2008? (Hint:check sort(), order () functions).
#[second largest: Ray R Irani]
sortcom=sort(ceo_comp$x2008compensation,decreasing =TRUE,index.return=TRUE)[[2]]
ceo_comp$CEO[sortcom[2]]

#13	Consider the following age groups: [45 – 50), [50 – 55), [55 – 60), [60 – 70), and [70 or more). Analyze age groups by industry and determine which age group corresponds to largest CEO average salary in 2008? Hint: 1. left end point is included; 2. nested if helps assign age category
#Additional info: File IndustryMedians.xls includes median compensation/salary/other/bonus/stock gain values for the various industries, so that you can compare any CEO to these median values in his/her industry. Compare each CEO’s total compensation to corresponding median compensations in his/her respective industry by calculating % difference:
#  %difference = (CEO’s compensation in 2008 – Corresponding industry median compensation in 2008) / Corresponding industry median compensation in 2008 × 100%

#Analysis: 
#1.The average compensation for each age group: 
#[45 – 50) => $10.81M  [50 – 55) =>$13.85M
#[55 – 60) =>$15.77  [60 – 70)=>$23.66M   [70 or more) =>33.16

#[45 – 50)  Mean compensation by age group (Display Example)
#1  Business Services & Supplies                    4.11
#2                 Conglomerates                    7.22
#3        Diversified Financials                    4.88
#4         Drugs & Biotechnology                    6.65
#5                         Media                   39.27
#6          Oil & Gas Operations                   36.01
#7                     Retailing                    1.38
#8                Semiconductors                    2.89
#9           Software & Services                   17.16
#10               Transportation                    5.17

#[50 – 55) MEAN compensation by age group (Display example)
#1               Aerospace & Defense                 26.7600
#2                           Banking                  1.0300
#3                         Chemicals                  3.1400
#4                     Conglomerates                 12.6100
#5            Diversified Financials                 13.5200
#6             Drugs & Biotechnology                 39.2100
#7              Food Drink & Tobacco                 25.5100
#8  Health Care Equipment & Services                 16.4250
#9     Household & Personal Products                 10.9100
#10                        Insurance                  5.1300
#11                            Media                 11.0700
#12             Oil & Gas Operations                 16.0100
#13                        Retailing                 10.2450
#14                   Semiconductors                 17.8300
#15              Software & Services                  1.3500
#16  Technology Hardware & Equipment                  0.5900
#17                   Transportation                 68.6200
#18                        Utilities                  8.4675

#add a column of percentage difference
for( i in 1:(dim(ceo_comp)[1])){
  in_median = industrymedian$Total.compensation[which(industrymedian$Industry==ceo_comp$Industry[i])]
  ceo_comp$percent_diff[i] = percent( (ceo_comp$x2008compensation[i]-in_median)/in_median)}

#extract group 1
age45=ceo_comp[ceo_comp$Age>=45 & ceo_comp$Age<50,]
ave45=mean(age45$x2008compensation)

library(data.table)
table45=as.data.frame(age45)
aggregate(formula=age45$x2008compensation~age45$Industry, data=age45, FUN=mean)

age50=ceo_comp[ceo_comp$Age>=50 & ceo_comp$Age<55,]
ave50=mean(age50$x2008compensation)
aggregate(formula=age50$x2008compensation~age50$Industry, data=age50, FUN=mean)


age55=ceo_comp[ceo_comp$Age>=55 & ceo_comp$Age<60,]
ave55=mean(age55$x2008compensation)
aggregate(formula=age55$x2008compensation~age55$Industry, data=age55, FUN=mean)

age60=ceo_comp[ceo_comp$Age>=60 & ceo_comp$Age<70,]
ave60=mean(age60$x2008compensation)
aggregate(formula=age60$x2008compensation~age60$Industry, data=age60, FUN=mean)

age70=ceo_comp[ceo_comp$Age>=70,]
ave70=mean(age70$x2008compensation)
aggregate(formula=age70$x2008compensation~age70$Industry, data=age70, FUN=mean)


#14	How many CEO’s have received 100% or larger compensation relative to their respective median compensation?
#[112 CEOs]
count=0
for( i in 1:(dim(ceo_comp)[1])){
  if(ceo_comp$x2008compensation[i] >= industrymedian$Total.compensation[which(industrymedian$Industry==ceo_comp$Industry[i])]){
    count=count+1
    next}
}
count

#15	Is the following formula always true? Total median compensation = Median Salary + Median Bonus + Median Other + Median Stock Gains
#[No. This formula is not true.]
industrymedian$Total.compensation == industrymedian$Salary+industrymedian$Bonus+industrymedian$Other+industrymedian$Stock.Gains
