# Finding patterns in a string


# 1. Checking for an exact string match

x="Good Morning"
x=="Good Morning"
x=="Good morning"  #R differentiates cases

# 2. How to ignore case sensitivity?

# If you want R to ignore cases in any string operations, 
# simply force all variables to a lower case and define the pattern 
# being compared against in lower case
tolower(x)==tolower("Good morning")  #R differentiates cases




# Checking for a partial match


# 3. load the library(stringr)
library(stringr)

# 4. Matching anywhere in the string: use str_detect() function
str_detect(x,"d Morn")


# 5. Matching the begining of the string
#add the carat character ^ in front of the pattern
str_detect(x,"Good")

# 6. Matching the end of the sring
#add the dollar character $ to the end of the pattern
str_detect(x,"ing$")




# 7. Locating the position of a pattern in a string
# use the str_locate() function

# The function returns two values: the position in the string where the pattern starts 
# and the position where the pattern ends
str_locate(x,"od M")

# Note that if the pattern is not found, str_locate returns NA's
str_locate(x,"od m")

#Note too that the str_locate function only returns the position of the first occurrence.
y="John opened the door, and then John entered the room."
str_locate(y,"John")

# To find all occurrences, use the str_locate_all() function
y="John opened the door, and then John entered the room."
str_locate_all(y,"John")

# The function returns a list object. To extract the position values 
# into a dateframe, simply wrap the function in a call to  as.data.frame
as.data.frame(str_locate_all(y,"John"))

#The reason str_locate_all returns a list and not a matrix or a data 
# frame can be understood in the following example:
# z d is a four element string vector
z=c("John opened the door, and then John entered the room.", " John Called", "Sun ", " John, John's and why John")
# The str_locate_all function returns a result for each element of that vector, 
# and since patterns can be found multiple times in a same vector element, the 
# output can only be conveniently stored in a list
str_locate_all(z,"John")



# 8. Finding the length of a string: use the str_length() function
str_length(x)
str_length(y)
str_length(z)

# 9. Finding a pattern's frequency
str_count(x, "Morn")
str_count(y, "John")
str_count(z, "John")


#Modifying strings

# 10. Padding numbers with leading zeros
# The str_pad() function can be used to pad numbers 
# with leading zeros. Note that in doing so, you are 
# creating a character object from a numeric object.
x1=c(12,9,0,10,5000)
str_pad(x1, width=3, side="left", pad = "0" )


# 13. Appending text to strings
# Append strings with custom text using the str_c() functions. 
str_c(x, " has ", str_length(x), " characters" )
str_c(y, " has ", str_length(y), " characters" )
str_c(z, " has ", str_length(z), " characters" )

# 14. Removing white spaces
# Remove leading or ending (or both) white spaces from a string
str_length(z)
str_trim(z, side="left")
str_length(str_trim(z, side="left"))
# To remove trailing spaces set side = "right" and to 
# remove both leading and trailing spaces set side = "both"

# 15. Replacing elements of a string
# To replace all instances of a specified set of characters in 
# a string with another set of characters, use the str_replace_all() function
str_replace_all(y, " ", "-")


# Extracting parts of a string

# 17. Extracting elements of a string given start and end positions
# To find the character elements of a vector at a given position of 
# a given string, use the str_sub() function
str_sub(x, start=6, end=24)
str_sub(z, start=10, end=15)
#If you don't specify a start position, then all characters up to 
#and including the end position will be returned. Likewise, if the 
#end position is not specified then all characters from the start 
#position to the end of the string will be returned.

# 18. Splitting a string by a character
# To break a string up into individual components based on a 
# character delimiter, use the str_split() function
d <- "Year=2018, Month=April, Day=10"
str_split(d, ",")
# The output is a one element list. If object d consists 
# of more than one element, the output will be a list of as 
# many elements as there are d elements.

#For example, if you want to find an element in the above 
# str_split output that matches the string Year=2018, the 
# following will return FALSE and not TRUE as expected
"Year=2018" %in% str_split(d, ",")

# The workaround is to convert the right-hand output to a single 
# vector using the unlist function
"Year=2018" %in% unlist(str_split(d, ","))

#If you are applying the split function to a column of data from 
# a dataframe, you will want to use the function str_split_fixed instead.
# This function assumes that the number of components to be extracted via 
# the split will be the same for each vector element. For example, the 
#following vector, T1, has two time components that need to be extracted. 
#The separator is a dash, -.
T1 <- c("9:30am-10:45am", "9:00am- 9:50am", "1:00pm- 2:15pm")
T1
str_split_fixed(T1, "-", 2)

# The third parameter in the str_split_fixed function is the number of elements 
# to return which also defines the output dimension (here, a three row and 
#two column table). If you want to extract both times to separate vectors, 
# reference the columns by index number:
T1.start <- str_split_fixed(T1, "-", 2)[ ,1]
T1.start
T1.end   <- str_split_fixed(T1, "-", 2)[ ,2]
T1.end

# You will want to use the indexes if you are extracting strings in 
# a data frame. For example:
dat <- data.frame( Time = c("9:30am-10:45am", "9:00am-9:50am", "1:00pm-2:15pm"))
dat$Start_time <- str_split_fixed(dat$Time, "-", 2)[ , 1]
dat$End_time   <- str_split_fixed(dat$Time, "-", 2)[ , 2]
dat


# 19. Extracting parts of a string that follow a pattern

#To extract the three letter months from object d (defined in 
# the last example), you can use a combination of stringr functions
loc <- str_locate(d, "Month=")
str_sub(d, start = loc[,"end"] + 1, end = loc[,"end"]+3)

# The above chunk of code first identifies the position of the Month: 
# string and passes its output to the object loc (a matrix). It then uses 
# the loc's end position in the call to str_sub to extract the three 
# characters making up the month abbreviation. The value 1 is added 
# to the start parameter in str_sub to omit the last character of Month: 
# (recall that the str_locate positions are inclusive).
# This can be extend to multi-element vectors as follows:

# Note the differences in spaces and string lenghts between the vector
# elements.
ds <- c("Year=2000, Month=Jan, Day=23",
        "Year=345, Month=Mar, Day=30",
        "Year=1867 , Month=Nov, Day=5")

loc <- str_locate(ds, "Month=")
str_sub(ds, start = loc[,"end"] + 1, end = loc[,"end"]+3)


# Note the non-uniformity in each element's length and Month: 
# position which requires that we explicitly search for the Month: 
# string position in each element. Had all elements been of equal 
# length and format, we could have simply assigned the position 
# numbers in the call to str_sub function.


