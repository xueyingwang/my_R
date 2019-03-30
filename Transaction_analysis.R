#Load file
library(stringr) 
library(lubridate) 
library(MASS)
?read.table
transaction = read.table("SupermarketTransactions.txt",sep="\t",header=F,stringsAsFactors = F)
colnames(transaction)=scan("SupermarketTransactionsColumnLabels.txt",what="character",sep="\t") 
no_transaction=dim(transaction)[1]
new_amount_paid <- str_replace(transaction$`Amount paid`, pattern = '\\$', replacement ='')
?str_replace
transaction$`Amount paid`= as.numeric(new_amount_paid)

tax=read.table("SupermarketTransactionsTax.csv",row.names=1,sep=",",
               header=T)

#1. How many transactions are made on Tuesday? Answer:1979
?as.Date
transaction$Weekday=weekdays(as.Date(transaction$`Purchase Date`,format='%m/%d/%Y'))
num_Tues=length(which(na.omit(weekday=="Tuesday")))


#2. What percentage of purchases (transactions) are made by male customers? Answer:49%
length(which(transaction$Gender=="M"))/no_transaction #6889/14059
paste(round(table(transaction$Gender)["M"] / dim(transaction)[1]*100,2),"%")

#3. What percentage of supermarket patrons are male? Answer: 50.52% 
gender_and_id <- transaction[, c(3,4)]
unique_customers <- unique(gender_and_id)
length(which(unique_customers$Gender == 'M'))/length(unique(transaction$`Customer ID`)) 

#4. What is the average, median, and standard deviation of amount paid?
#average=$13.00; median=$11.25 Std=$8.22
mean(transaction$`Amount paid`)
median(transaction$`Amount paid`) 
sd(transaction$`Amount paid`) 

#5. How many transactions are made on Tuesday by male customers?
#968 transactions are made on Tuesday by male customers
length(which(transaction$Gender=="M"&transaction$Weekday=="Tuesday"))


#6. How many transactions that are made on Tuesday by male customers exceed 5 units per transaction?
#117 transactions
length(which(transaction$Gender=="M"&transaction$Weekday=="Tuesday"&transaction$`Units Sold`>5))


#7. Create a contingency table between gender and annual income. 
table(transaction$Gender,transaction$`Annual Income`)
#    $10K - $30K $110K - $130K $130K - $150K $150K + $30K - $50K $50K - $70K $70K - $90K $90K - $110K
#F        1587           307           390     140        2243        1224         959          320
#M        1503           336           370     133        2358        1146         750          293

#8. How many unique customer IDs are in the data set? Answer:5404 unique IDs
num_patrons=length(unique(transaction$`Customer ID`)) 

#9. Which day of the week has largest number of transactions? #Monday
library(plyr)
table(transaction$Weekday)[which.max(table(transaction$Weekday))]
#Friday    Monday  Saturday    Sunday  Thursday   Tuesday Wednesday 
#1976      2056      1988      2017      2040      1979      2003 


#10. Is amount paid normally distributed? Create several visualizations (histogram, stem-leaf-plot, qqplot) of the distribution of amount paid and interpret the shape. 
#No, the amount paid is not normally distributed since the qqline is departure from the qqnorm. QQ plot is not straight. Histogram is not symetric.
#it appears to be right-skewed.
hist(transaction$`Amount paid`)
stem(transaction$`Amount paid`)
qqnorm(transaction$`Amount paid`)
qqline(transaction$`Amount paid`)


#11. Sales tax rate in each state and by product category is provided in Taxes.xlsx.  Add a new column TaxRate and assign tax rate to each transaction.
for(k in 1:(nrow(transaction))){
  for(i in 1:(dim(tax)[1])){#product category; rownames 45
    for(j in 1:(dim(tax)[2])){#state name; Colnames 10
      if(as.character(transaction$`Product Category`[k])==as.character(rownames(tax)[i])&as.character(transaction$State[k])==as.character(colnames(tax)[j])){
        transaction$Taxrate[k]=as.numeric(tax[i,j])
        next}
    }
  }
}

#12. What is the total government tax revenue generated for each country from the supermarket chain?
#USA=$2928.05 Mexico=$835.4 Canada=$278.65
unique(transaction$Country)
transaction$supermarket_revenue <- transaction$`Amount paid`/(1+as.numeric(transaction$Taxrate)/100)
transaction$govn_revenue<-transaction$`Amount paid`-transaction$supermarket_revenue
#transactions$Government.Revenue=as.numeric(gsub("\\$","",transactions$`Amount paid`))-transactions$Supermarket.Revenue
sum(transaction[transaction$Country=="USA",]$govn_revenue)  
sum(transaction[transaction$Country=="Mexico",]$govn_revenue)  
sum(transaction[transaction$Country=="Canada",]$govn_revenue)  


#13. Contrast amount paid for males and females by creating a side by side box plot.  
boxplot(transaction$`Amount paid`~transaction$Gender,data=transaction)

#14. Create a scatter plot between amount paid and government revenue.
plot(x=transaction$`Amount paid`,y=transaction$govn_revenue,xlab="Amount paid",ylab="Government Revenue")
