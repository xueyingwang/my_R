#paste() function i base package
rho=0.5 #correlation cofficient
paste("Correlation coefficient",rho,expression(rho))

#Install and upload library Stringr
install.packages("stringr")
library(stringr)

#finding pattens in a string

#1. Exact string match
x="Good Morning "
x=="Good Morning"

#2. how to ignore case sensitivity
tolower(x)=="good morning "

#3 Matching anywhere in the string
#use str_detect()function
str_detect(x,"d Morn")

#4 Matching the beginning of a string
#use caret symbol ^
str_detect(x,"^Good")

#5 End of the string?
#use $ at the end
str_detect(x,"ing$")
str_detect(x,"ing $")

#how to locate position of a pattern in a string
#Use str_locate() function
str_locate(x,"od M")
x

str_locate(x,"odd M")  #NA NA

#create a new variable that contains pattern in several location in the string

y="John opened the door and then John came inside"
str_locate(y,"John")
str_locate_all(y,"John")

#if you see [[...]] this notation represents list
as.data.frame(str_locate_all(y,"John"))

#6 length of a string: str_length
str_length(x)
str_length(y)

#8 Frequency obtain using str_count()
str_count(x,"John")
str_count(y,"John")

#9 padding numbers with leading zeros
str_pad(c(10,2,50),width = 3, side="left",pad=0)

#10 Append text to string
str_c(x,"has ",str_length(x)," characters")
str_c(y,"has ",str_length(y)," characters")

#11 how to remove white spaces str_trim
x=" Good Morning"
str_length(x)
str_trim(x,side="left")
str_trim(x,side="right")
str_trim(x,side="both")

#12 replace elements of a string
#use str_replace()
#replace spaces with dashes in x
str_replace(x," ","-")
str_replace_all(x," ","-")

#13 how to extract paerts of a string
str_sub(x,start=6,end=100)
str_sub(x,start=6)

#14  how to split string by a character
d="Year=2018,Month=April,Day=10"
str_split(d,",")
unlist(str_split(d,","))




