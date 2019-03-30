library(dplyr)
#2. What is the corresponding lowest average?

gradebook=read.csv("Gradebook.txt",sep="\t", stringsAsFactors = TRUE)
gradebook=tbl_df(gradebook)

#3. Create a tibble that displays lowest score of all assignments for each major.
gradebook %>% group_by(Major) %>% summarise(min_project1=min(Project.1),min_project2=min(Project.2),min_teamproject=min(Team.Project))

#4. Which assignment has the highest median? (median = middle of a sorted list from smallest to largest)
#Project 2's median is highest, which is 95

arrange(gradebook, desc(Project.1))[133,]
arrange(gradebook, desc(Project.2))[133,]
arrange(gradebook, desc(Team.Project))[133,]

#5. What is the corresponding highest median?
#The corresponding median is 95

#6. Create a tibble that displays highest score of all assignments for each major.
gradebook %>% summarise(max_project1=max(Project.1),max_project2=max(Project.2),max_TeamProject=max(Team.Project))

#7. Which quiz has largest number of zeros?
# Quiz 4 has the larges number of zeros
gradebook %>% filter(Quiz.1==0) %>% dim() #7
gradebook %>% filter(Quiz.2==0) %>% dim() #4
gradebook %>% filter(Quiz.3==0) %>% dim() #7
gradebook %>% filter(Quiz.4==0) %>% dim() #20
gradebook %>% filter(Quiz.5==0) %>% dim() #9

# 8 What is the largest corresponding number of zeros?
# Quiz 4 has 20 zeros

# 9. Calculate average quiz score for each student. How many students have average quiz score 80 or more but less than 90?
#69 students
gradebook %>% group_by(Last.Name, First.Name) %>% summarise(average_Quiz=mean(Quiz.1,Quiz.2,Quiz.3,Quiz.4,Quiz.5,na.rm=T)) %>% filter(average_Quiz>=80 & average_Quiz<90)

# 10. Create a tibble that displays average of each assignment for each major.
gradebook %>% group_by(Major) %>% summarise(average_project1 = mean(Project.1),average_project2 = mean(Project.2),average_teamproject=mean(Team.Project))

# 11. On a 0 to 100 percent scale calculate the average final grade in the course. (Hint: do not forget that the final grade is the weighted average!)
#76.2
finalgrade=( gradebook %>% group_by(Last.Name, First.Name) %>% mutate(average_Quiz=(sum(Quiz.1,Quiz.2,Quiz.3,Quiz.4,Quiz.5)-min(Quiz.1,Quiz.2,Quiz.3,Quiz.4,Quiz.5))/4,average_project=mean(Project.1,Project.2)) %>% 
  mutate(finalgrade=0.12*average_Quiz+0.2*average_project+Team.Project*0.15 + 0.2*Midterm+0.33*Final.Exam) %>% mutate(coursegrade=ifelse(finalgrade<62,0, ifelse(finalgrade<64&finalgrade>=62,0.7, ifelse(finalgrade<70&finalgrade>=64,1,
  ifelse(finalgrade<72&finalgrade>=70,1.3,ifelse(finalgrade<74&finalgrade>=72,1.7,ifelse(finalgrade<80&finalgrade>=74,2,
  ifelse(finalgrade<82&finalgrade>=80,2.3,ifelse(finalgrade<84&finalgrade>=82,2.7,ifelse(finalgrade<90&finalgrade>=84,3,
  ifelse(finalgrade<92&finalgrade>=90,3.3,ifelse(finalgrade<94&finalgrade>=92,3.7,4)))))))))))) )  

finalgrade
meanfinalgrade=mean(finalgrade$finalgrade)

# 12. Which major corresponds to the highest number of students who performed excellently?
#BS (business statistic perfomed the best) with 79.4
finalgrade=tbl_df(finalgrade)
major_grade=(finalgrade %>% group_by(Major) %>% summarise(finalgrade=mean(finalgrade,na.rm=T)))

#Additional Info

#13. On a 0 to 4 scale calculate the average final grade in the course.
# 2.04 -> average final grade
averagegrade4=mean(finalgrade$coursegrade)
averagegrade4

#14. On a 0 to 4 scale calculate the average final grade in the course for each major separetely. Which major corresponds to the highest average?
#Major BS has the highest average course grade of 2.32 
finalgrade=tbl_df(finalgrade)
finalgrade %>% group_by(Major) %>% summarise(average_coursegrade=mean(coursegrade))

#15. Does the course need to be curved?
#yes. The average is only 2.04 which is too low.
  
#16. If instead of dropping the lowest quiz score, a professor decides to drop two lowest quiz scores. On a 0 to 4 scale calculate the new average 
#final grade in the course. (drop two lowest quiz scores only for this question, for all other questions drop only the lowest quiz score)
#2.07
finalgrade_2=(gradebook %>% group_by(Last.Name, First.Name) %>% mutate(average_Quiz=(sum(Quiz.1,Quiz.2,Quiz.3,Quiz.4,Quiz.5)-min(Quiz.1,Quiz.2,Quiz.3,Quiz.4,Quiz.5)-
            nth(sort(c(Quiz.1,Quiz.2,Quiz.3,Quiz.4,Quiz.5)),2)) /3,average_project=mean(Project.1,Project.2)) %>% 
            mutate(finalgrade=0.12*average_Quiz+0.2*average_project+Team.Project*0.15 + 0.2*Midterm+0.33*Final.Exam) %>% 
            mutate(coursegrade=ifelse(finalgrade<62,0, ifelse(finalgrade<64&finalgrade>=62,0.7, ifelse(finalgrade<70&finalgrade>=64,1,
            ifelse(finalgrade<72&finalgrade>=70,1.3,ifelse(finalgrade<74&finalgrade>=72,1.7,ifelse(finalgrade<80&finalgrade>=74,2,
            ifelse(finalgrade<82&finalgrade>=80,2.3,ifelse(finalgrade<84&finalgrade>=82,2.7,ifelse(finalgrade<90&finalgrade>=84,3,
            ifelse(finalgrade<92&finalgrade>=90,3.3,ifelse(finalgrade<94&finalgrade>=92,3.7,4)))))))))))) ) 
finalgrade_2
mean(finalgrade_2$coursegrade)

#Additional info
#17. What is the distribution in percentage of the above 4 qualitative performance descriptors?
#28.57% Poor performance, 27.82% Below average, 42.11% Good, 1.5% Excellent 
finalgrade_2 %>% filter(coursegrade<=1.3) %>% dim()/266#28.57% Poor performance
finalgrade_2 %>% filter(coursegrade<=2.3 & coursegrade>=1.7) %>% dim()/266 #27.82% Below average
finalgrade_2 %>% filter(coursegrade<=3.3 & coursegrade>=2.7) %>% dim()/266 #42.11% Good
finalgrade_2 %>% filter(coursegrade>=3.7) %>% dim()/266 #1.5% Excellent

#18. Which major corresponds to the lowest percentage of Below Average performance in the course? 
#IS major has the lowest percentage of Below Average performance which is only 0.75%
finalgrade_2= (finalgrade_2 %>% mutate(performance=ifelse(coursegrade<=1.3,"Poor",ifelse(coursegrade<=2.3 & coursegrade>=1.7,"Below Average",
                                                                          ifelse(coursegrade<=3.3 & coursegrade>=2.7,"Good","Excellent")))))
major_performance = table(finalgrade_2$Major,finalgrade_2$performance)
major_performance
k=1:9
for( i in 1:9 ){
  k[i]=major_performance[i,1] / 266
}
k

#19. What the corresponding percentage value?
#0.75%

#20. Students who receive 0 points on quizzes, projects, or exams are more likely to receive a “Poor Performance”. Among students receiving a 
#“Poor Performance”, what is the average number of quizzes, projects, or exams with a 0 point value?
#0.961 for average number of quizzes, projects, or exams with a 0 point value
counttable=(finalgrade_2 %>% filter(performance=="Poor") %>% summarise(count=sum(Quiz.1==0,Quiz.2==0,Quiz.3==0,Quiz.4==0,Quiz.5==0,Project.1==0,Project.2==0,
                                                                     Team.Project==0,Midterm==0,Final.Exam==0)))
mean(counttable$count)

#21. Mirzagaliyeva Shakhizada (ID 20006187) this semester took the following courses: 2 unit course, BUAD 525, from Prof. Plotts and received D+; 4 unit course, DSO 524, from Prof. Ku and received A-; 6 unit course, GSBA 545, from Prof. Porter and received C+ and 3 unit course, DSO 545, from Prof. Gabrys for which you need to determine the grade. Calculate the 4.0 scale GPA for Shakhizada.
#he got average GPA of 2.48
finalgrade_2 %>% filter(Student.ID==20006187) #he got 2.0 on DSO545
(2*1.3+4*3.7+6*2.3+3*2)/(2+4+6+3)

#22. Due to a very low average, Marshall has decided to inflate (“curve”) everybody’s total weighted score by the percentage specified in the below table
#2.42 after curve 
newgrade_BDA=(finalgrade_2 %>% filter(Major=="BDA") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.015,ifelse(coursegrade==3.3,finalgrade*1.021,
            ifelse(coursegrade==3,finalgrade*1.043,ifelse(coursegrade==2.7,finalgrade*1.04,ifelse(coursegrade==2.3,finalgrade*1.12,ifelse(coursegrade==2,
            finalgrade*1.08,ifelse(coursegrade==1.7,finalgrade*1.1,ifelse(coursegrade==1.3,finalgrade*1.04,ifelse(coursegrade==1|coursegrade==0.7,finalgrade*1.11,finalgrade*1.12
            ))))))))))))   
newgrade_BS=(finalgrade_2 %>% filter(Major=="BS") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.018,ifelse(coursegrade==3.3,finalgrade*1.023,
            ifelse(coursegrade==3,finalgrade*1.028,ifelse(coursegrade==2.7,finalgrade*1.04,ifelse(coursegrade==2.3,finalgrade*1.04,ifelse(coursegrade==2,
            finalgrade*1.09,ifelse(coursegrade==1.7,finalgrade*1.08,ifelse(coursegrade==1.3,finalgrade*1.04,ifelse(coursegrade==1,finalgrade*1.11,ifelse(coursegrade==0.7,finalgrade*1.03,
                                                                                                                                                         finalgrade*1.14)))))))))))))
newgrade_AC=(finalgrade_2 %>% filter(Major=="AC") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.014,ifelse(coursegrade==3.3,finalgrade*1.02,
            ifelse(coursegrade==3,finalgrade*1.039,ifelse(coursegrade==2.7,finalgrade*1.07,ifelse(coursegrade==2.3,finalgrade*1.06,ifelse(coursegrade==2,
            finalgrade*1.03,ifelse(coursegrade==1.7,finalgrade*1.085,ifelse(coursegrade==1.3,finalgrade*1.08,ifelse(coursegrade==1,finalgrade*1.11,ifelse(coursegrade==0.7,finalgrade*1.02,
            finalgrade*1.14)))))))))))))
newgrade_MK=(finalgrade_2 %>% filter(Major=="MK") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.013,ifelse(coursegrade==3.3,finalgrade*1.027,
            ifelse(coursegrade==3,finalgrade*1.041,ifelse(coursegrade==2.7,finalgrade*1.07,ifelse(coursegrade==2.3,finalgrade*1.04,ifelse(coursegrade==2,
            finalgrade*1.06,ifelse(coursegrade==1.7,finalgrade*1.08,ifelse(coursegrade==1.3,finalgrade*1.05,ifelse(coursegrade==1,finalgrade*1.02,ifelse(coursegrade==0.7,finalgrade*1.04,
            finalgrade*1.14)))))))))))))
newgrade_MG=(finalgrade_2 %>% filter(Major=="MG") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.012,ifelse(coursegrade==3.3,finalgrade*1.026,
            ifelse(coursegrade==3,finalgrade*1.029,ifelse(coursegrade==2.7,finalgrade*1.08,ifelse(coursegrade==2.3,finalgrade*1.09,ifelse(coursegrade==2,
            finalgrade*1.04,ifelse(coursegrade==1.7,finalgrade*1.05,ifelse(coursegrade==1.3,finalgrade*1.07,ifelse(coursegrade==1,finalgrade*1.06,ifelse(coursegrade==0.7,finalgrade*1.03,
            finalgrade*1.1)))))))))))))
newgrade_BA=(finalgrade_2 %>% filter(Major=="BA") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.016,ifelse(coursegrade==3.3,finalgrade*1.025,
            ifelse(coursegrade==3,finalgrade*1.036,ifelse(coursegrade==2.7,finalgrade*1.06,ifelse(coursegrade==2.3,finalgrade*1.09,ifelse(coursegrade==2,
            finalgrade*1.09,ifelse(coursegrade==1.7,finalgrade*1.09,ifelse(coursegrade==1.3,finalgrade*1.08,ifelse(coursegrade==1,finalgrade*1.1,ifelse(coursegrade==0.7,finalgrade*1.08,
            finalgrade*1.13)))))))))))))
newgrade_IS=(finalgrade_2 %>% filter(Major=="IS") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.017,ifelse(coursegrade==3.3,finalgrade*1.025,
            ifelse(coursegrade==3,finalgrade*1.028,ifelse(coursegrade==2.7,finalgrade*1.04,ifelse(coursegrade==2.3,finalgrade*1.07,ifelse(coursegrade==2,
            finalgrade*1.08,ifelse(coursegrade==1.7,finalgrade*1.03,ifelse(coursegrade==1.3,finalgrade*1.06,ifelse(coursegrade==1,finalgrade*1.07,ifelse(coursegrade==0.7,finalgrade*1.09,
            finalgrade*1.07)))))))))))))
newgrade_FN=(finalgrade_2 %>% filter(Major=="FN") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.019,ifelse(coursegrade==3.3,finalgrade*1.024,
            ifelse(coursegrade==3,finalgrade*1.047,ifelse(coursegrade==2.7,finalgrade*1.07,ifelse(coursegrade==2.3,finalgrade*1.08,ifelse(coursegrade==2,
            finalgrade*1.09,ifelse(coursegrade==1.7,finalgrade*1.05,ifelse(coursegrade==1.3,finalgrade*1.03,ifelse(coursegrade==1,finalgrade*1.04,ifelse(coursegrade==0.7,finalgrade*1.09,
            finalgrade*1.12)))))))))))))
newgrade_OM=(finalgrade_2 %>% filter(Major=="FN") %>% mutate(adjusted=ifelse(coursegrade==4,finalgrade,ifelse(coursegrade==3.7,finalgrade*1.009,ifelse(coursegrade==3.3,finalgrade*1.019,
            ifelse(coursegrade==3,finalgrade*1.025,ifelse(coursegrade==2.7,finalgrade*1.03,ifelse(coursegrade==2.3,finalgrade*1.03,ifelse(coursegrade==2,
            finalgrade*1.05,ifelse(coursegrade==1.7,finalgrade*1.09,ifelse(coursegrade==1.3,finalgrade*1.08,ifelse(coursegrade==1,finalgrade*1.08,ifelse(coursegrade==0.7,finalgrade*1.09,
            finalgrade*1.11)))))))))))))
inflated=rbind(newgrade_BDA,newgrade_BS,newgrade_AC,newgrade_MK,newgrade_MG,newgrade_BA,newgrade_IS,newgrade_FN,newgrade_OM)
newtable=(inflated %>% mutate(adjustedgrade=ifelse(adjusted<62,0, ifelse(adjusted<64&adjusted>=62,0.7, ifelse(adjusted<70&adjusted>=64,1,
  ifelse(adjusted<72&adjusted>=70,1.3,ifelse(adjusted<74&adjusted>=72,1.7,ifelse(adjusted<80&adjusted>=74,2,
  ifelse(adjusted<82&adjusted>=80,2.3,ifelse(adjusted<84&adjusted>=82,2.7,ifelse(adjusted<90&adjusted>=84,3,
  ifelse(adjusted<92&adjusted>=90,3.3,ifelse(adjusted<94&adjusted>=92,3.7,4)))))))))))))
mean(newtable$adjustedgrade)








