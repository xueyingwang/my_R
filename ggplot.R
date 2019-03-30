#before importing file, set working directory

#1.Import data faithfuldata.csv in R and call it faithful
faithful=read.csv("faithfuldata.csv")

#2.Compactly display the internal structure of the data using str function
str(faithful)
?str

#3
install.packages("ggplot2")
library(ggplot2)

#4
ggplot(faithful, aes(x=waiting))

#5
ggplot(faithful, aes(x=waiting))+geom_histogram()

#6
#the distribution of the waiting time is bimodal.

#7 You can change the bin width of the histogram using the binwidth argument
ggplot(faithful, aes(x=waiting))+geom_histogram(binwidth = 10, fill="white",color="black")


#8
library(MASS)
#9
?birthwt
#10
str(birthwt)
#11
ggplot(birthwt,aes(x=bwt))+geom_histogram()
#12	Create a histogram of  birth weight (in grams) for each level of smoking status during pregnancy (variable smoke):
#a.	facet_grid() by row
ggplot(birthwt,aes(x=bwt))+geom_histogram()+facet_grid(smoke~.)
#bfacet_grid() by col
ggplot(birthwt,aes(x=bwt))+geom_histogram()+facet_grid(.~smoke)

#13	Change the labels of the facets by changing smoke =0 to No smoke and smoke =1 to Smoke and recreate the histograms for each smoke levels. 

mode(birthwt$smoke)
birthwt$smoke=as.factor(birthwt$smoke) #categorical variable
birthwt$smoke
levels(birthwt$smoke)=c("No smoke","Smoke")
ggplot(birthwt,aes(x=bwt))+geom_histogram()+facet_grid(.~smoke)

#14 Create a histogram of birth weight (in grams) for each level of mother’s race(race):
#a.	do Not include scales = "free" in facet_grid() and call your graph Before: Rescaling y
ggplot(birthwt,aes(x=bwt))+geom_histogram()+facet_grid(race~.)+ggtitle("Before rescaling y")
#b.	include scales = "free" in facet_grid()and call your graph After: Free y Scales
ggplot(birthwt,aes(x=bwt))+geom_histogram()+facet_grid(race~.,scale="free")+ggtitle("After: Free y Scales")

#15 Create a histogram of birth weight (in grams) and add fill = smoke
ggplot(birthwt,aes(x=bwt,fill=smoke))+geom_histogram()

#16 In previous graph in geom_histogram() add position = "identity" and alpha = 0.4 (alpha controls transparency).
ggplot(birthwt,aes(x=bwt,fill=smoke))+geom_histogram(position="identity",alpha=0.4) #alpha->transparency

#17 Using a layer of geom_line() with a parameter stat = "density" display so called kernel density plot of variable waiting in faithful. 
ggplot(faithful,aes(x=waiting))+geom_line(stat="density")

#18	The amount of smoothness in previous graph depends on the kernel bandwidth: the larger the bandwidth the smoother the curve. On one graph create 3 trajectories that represent 
#3 levels of smoothness in density curve: adjust =0.25, default level of smoothness and adjust =2. Curves that correspond to adjust = 0.25 and adjust =2 should be colored. 
#Expand the x axis to (35,105).   
ggplot(faithful,aes(x=waiting))+geom_line(stat="density",adjust=0.25,color="red")+
  geom_line(stat="density")+
  geom_line(stat="density",adjust=2,color="blue")

#19	Add a fill to your density plot in 17. Set transparency to be 0.2 and x range to be (35,105). 

ggplot(faithful,aes(x=waiting))+geom_density(fill="blue",alpha=0.2)+xlim(35,105)

#20 Overlay a density curve on your histogram.  Since the y-values for the density curve are very small (the area under the curve should sum up to 1) compared 
#to the values that we have for the histogram (counts), then we it is barely visible if you overlaid it on a histogram without any transformation. 
#To solve this problem, you can scale down the histogram to match the density curve with the mapping y=..density..

ggplot(faithful,aes(x=waiting,y=..density..))+geom_histogram(fill="blue",color="white")+geom_density(stat="density")+xlim(35,105)


#21	Overlay the density curves of birth weights for smoker and nonsmoker moms.
ggplot(birthwt,aes(x=bwt,fill=smoke))+geom_density(alpha=0.3,color=NA)

#22	Convert race variable to a factor variable by assigning “White”, “Black” and “Other” categories. 
birthwt$race=as.factor(birthwt$race)
levels(birthwt$race)=c("White","Black","Other")
birthwt$race

#23 Create side by side boxplots to display the distribution of weights by race by adding a layer of geom_boxplot() to a graphical object. 
ggplot(birthwt,aes(x=race,y=bwt))+geom_boxplot()
#boxplot is useful for frad detecting

#24 In previous graph change the width of the boxplot and the outlier dot shape: width = 0.5, outlier.size = 5, outlier.shape = 3. 
ggplot(birthwt,aes(x=race,y=bwt))+geom_boxplot(width=0.5,outlier.size=5,outlier.shape = 3)

#25 Arrange boxplots vertically.
ggplot(birthwt,aes(x=race,y=bwt))+geom_boxplot(width=0.5,outlier.size=5,outlier.shape = 3)+coord_flip()

#26 Add the means to the boxplots.
ggplot(birthwt,aes(x=race,y=bwt))+geom_boxplot()+stat_summary(fun.y="mean",geom="point",shape=23,size=3,fill="white")

#27 Create a boxplot for all observations for bwt without looking at each group separately. We have to provide some arbitrary value for x, 
#otherwise ggplot() won’t know what x coordinate to use for the boxplot. In this case we use x= 1, but it could be any value. 
#Also, in order to get rid of the x-axis tick markers and labels, we can use the scale_x_continous() and set the breaks=NULL
ggplot(birthwt,aes(x=1,y=bwt))+geom_boxplot()+scale_x_continuous(breaks=NULL)+xlab("")
