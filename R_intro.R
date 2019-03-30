
# 1. read in the data from the file "swans.dat"
?read.table
swans=read.table(file="swans.dat", header = TRUE)
#indicate your working directory/folder
#Session/Set working Directory/choose directory
head(swans)  #display first 6 rows
?tail
tail(swans,10) #display last 10 rows

#2. subset it using

  # a. the second row
swans[2,]
  # b. the third column
swans[3,]
  # c. the entry in the second row and third column
swans[2,3]
  # d. all swans with 6th col==1
col=1
col==2 #does col equal to 2?
swans[,6]==1
swans[swans[,6]==1,]
# e. all female swans
swans[swans[,8]=="F",]
swans[swans$sex=="F",]
swans[swans[,"sex"]=="F",]
swans[swans[,"sex",],]
# f. all swans weighing more than 10 kg
swans[swans$weight>10,]
#g male swans weighing more than 10 kg
T*T

as.numeric(T)
as.numeric(F)
as.logical(0)
as.logical(1)
#create a vector x that contains 3 components: T, T and F
x=c(T,T,F)
x
#create a vector x\y that contains 3 components: T, T and T
y=c(T,T,T)
y
x*y #elementwise multiplication
as.logical(x*y)
x & y
swans[swans$weight>10,]

swans[swans$sex=="M" & swans$weight>10,]

#g. swans whose gender is male or weight is >10 
swans[swans$sex=="M" | swans$weight>10,]

# 3. make a copy swans:
swanscopy=swans 

# 4. take log of cheight column and add it to the copy of swans:
swanscopy$logcheight=log(swanscopy$cheight)
head(swanscopy)
colnames(swanscopy)
dim(swans) #dimension
dim(swanscopy)

#how many rows swans table has
dim(swans)[1]
# how many columns swans table has?
dim(swans)[2]

# 5. compute summary statistics:min, 1st quartile, mean, median, 3rd quartile, max, 
# variance, standard deviation
summary(swans)

#transpose data using t() function
#colums represent variable/attributes/character
#rows represent subjects/objects/cases
mean(swans) # doesn't work
?apply
apply(swans[,-8],2,mean) #swans=swans[,-8] if we want to remove 8th col
apply(swans[,c(1,3,5)],2,mean) #2 means column 1->row c(1,2):rows and cols
apply(swans[,-8],2,sd)

apply(swans,2,mode)

is.numeric(swans)
#apply(swans,2,is.numeric)
#is.numeric(swans$circum)

# 6. compute a COVARIANCE matrix 
#covariance is a measure of lineara dependence between 2 numerical variable 
cov(swans[,-8])


# 7. compute a CORRELATION matrix:
round(cor(swans[,-8]),2) # 2 is the decimal points


# 8. compute means, variances and standard deviations of the columns and store
# the results in a matrix with properly labeled rows and columns
swanssummarytable=rbind(apply(swans[,-8],2,mean),apply(swans[,-8],2,var),apply(swans[,-8],2,sd))
rownames(swanssummarytable)=c("means","variance","sd")
swanssummarytable

# 9. summarize sex and age using table function: indiviaually and simultaneously:
table(swans$sex)
table(swans$age)
table(swans$sex,swans$age,swans$spec)

# 10. which of the variabbles are normally distributed? Answer this question by
# creating and interpreting a normal probability plots.
hist(swans$circum)
hist(swans$weight)

hist(rnorm(20)) #random normal valuable

qqnorm(swans$circum) #normal qq plot
qqline(swans$circum)

#Is variable normally distributed 
#1)histogram(wot aprropriate for small data sets)
#2)stem-leaf plot
#3)qq-plot
#4)qqnorm
#5)qqline

# 11. create stem-and-leaf plot for weight:
stem(swans$weight)

# 12. create histograms for each variable. what does parameter "breaks" do to the histogram?
hist(swans$circum)
hist(swans$circum,breaks=30) #30 bars

# 13. visualize sex and and age using barcharts - individually and together:
barplot(table(swans$sex))
barplot(table(swans$sex,swans$age))
barplot(table(swans$age,swans$sex))

# 14. create a bivariate plot of weight versus circumference; don't forget to label axes and create a title of the graph
plot(swans$circum,swans$weight,xlim=c(0,max(swans$circum)),ylim=c(0,max(swans$weight)))
plot(swans$circum,swans$weight,xlab = 'Circumference',
     ylab='weight',main='weight versus circumference')

plot(swans$circum,swans$weight,axes=F)
axis(1) #x axis
axis(2) #y axis
box()

# 15. plot only the female swans in the above graph:
plot(swans[swans$sex=="F",]$circum,swans[swans$sex=="F",]$weight,xlab = 'Circumference',
     ylab='weight',main='weight versus circumference')


# 16. plot all the swans but use M or F for the symbol:
plot(swans$circum,swans$weight,type='n')
text(swans$circum,swans$weight,swans$sex)


# 17. in the above graph use color to distinguish gender:
plot(swans$circum,swans$weight,col=as.numeric(swans$sex)) #col = "4" or col="red" 1:2 2 colors
dim(swans)
as.numeric(swans$sex)

# note that as.numeric(swans$sex) assigns numbers to the levels of 
# the categorical variable in alphabetical order, so that
# "M" is converted to 2 and "F" is converted to 1.
# We can change the colors to be whatever we like, in the following way:
plot(swans$circum,swans$weight,col=c("magenta","blue")[as.numeric(swans$sex)])
#
# and the available color names can be seen using the command:
colors()

# 18. compare male and female swans circum by creating side-by-side boxplots:
?boxplot
boxplot(circum~sex,data=swans)
#formula notation in R:
#y=b0+b1*x+e   product y from x   REGRESSION equation
#y~x (regression model using formula notation)


# 19. create all pairwise scatter plots to look at all variables:
pairs(swans)
pairs(swans[,1:5])
?pairs


# 20. color the above graphs using magneta and blue for females and males correspondingly:

pairs(swans[,1:5],col=c("magenta","blue")[as.numeric(swans$sex)])


# 21. fit a linear model to predict weight from circum
#y=intercept+slope*x
#in R simple regression model is reated using lm function
#lm(y~x,data)
M1=lm(weight~circum,data=swans)#linear model(regression model)
summary(M1)

M2=lm(weight~circum+sex+spec+circum*sex,data=swans)
summary(M2)
#add interaction using * or :
plot(M1)

# 22. create the scatterplot between weight and circum and superimpose the above 
# regression line


plot(x=swans$circum,y=swans$weight)
?plot
abline(M1,col="red") #This function adds one or more straight lines through the current plot.

# 23. create regression models separately for boys and girls:

M1F=lm(weight~circum,data=swans[swans$sex=="F",])
M1F
summary(M1F)

M1M=lm(weight~circum,data=swans[swans$sex=="M",])
M1M
summary(M1M)



# 24. graph all data, use magenta and blue colors to indicate gender and add both regression
# lines using corresponding colors

plot(swans$circum,swans$weight,col=c("magenta","blue")[as.numeric(swans$sex)])
abline(M1F,col="magenta")
abline(M1M,col='blue')

# 25. fit a multiple regression to predict weight from circum, wingspan, cwidth, cheight and sex
#fit a model to predict weight from all variables
Mall=lm(weight~.,data=swans)
Mall
summary(Mall)
Mall1=lm(weight~.,~cwidth,data=swans)
# 26. using summary function determine Rsquared, spread around the regression plane, 
# which variables are significant. 
summary(Mall)
plot(x=swans$circum,y=swans$weight)
abline(M1,col="red")
abline(h=mean(swans$weight),col="blue")

#Rsquare means %of imporved uncertainty
