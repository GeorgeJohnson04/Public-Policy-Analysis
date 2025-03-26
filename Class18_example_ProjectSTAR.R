#install.packages('car')
#install.packages('dplyr')


library(dplyr) # used for data manipulation
library(car)

# 1. set working directory
setwd("/Users/bheller/Dropbox/10. POLC3322/5. Spring 2025/Data Exercises/")

# 2. import full Project STAR dataset
STAR_data<-read.csv("ProjectSTAR_replication_data_K.csv", header = T, na.strings=c(""))

# 3. limit sample to observations with valid Kindergarten class assignment
STAR_Kinder <- STAR_data[complete.cases(STAR_data$cltype_k),]

# 4. check values of Kindergarten class type
table(STAR_Kinder$cltype_k)

# 5. create binary indicators for each class type
STAR_Kinder$small_class <- as.numeric(STAR_Kinder$cltype_k == 'SMALL CLASS') 
STAR_Kinder$reg_class <- as.numeric(STAR_Kinder$cltype_k == 'REGULAR CLASS') 
STAR_Kinder$regaide_class <- as.numeric(STAR_Kinder$cltype_k == 'REGULAR + AIDE CLASS') 

# 6. combine math and reading scores into a single "average score" variable 
STAR_Kinder$ave_score_k <- (STAR_Kinder$std_read_score_k + STAR_Kinder$std_math_score_k)/2

# 7. create binary indicator for female gender
STAR_Kinder$female <- as.numeric(STAR_Kinder$gender == 'FEMALE')

# 8. create binary indicators for Asian, Black, and White race
STAR_Kinder$asian <- as.numeric(STAR_Kinder$race == 'ASIAN')
STAR_Kinder$black <- as.numeric(STAR_Kinder$race == 'BLACK')
STAR_Kinder$white <- as.numeric(STAR_Kinder$race == 'WHITE')

# 9. create binary indicators for teacher degree and teacher race
STAR_Kinder$tch_ma <- as.numeric(STAR_Kinder$tch_degree == 'MASTERS'|STAR_Kinder$tch_degree == 'MASTERS +')
STAR_Kinder$tch_black <- as.numeric(STAR_Kinder$tch_race == 'BLACK')
STAR_Kinder$tch_white <- as.numeric(STAR_Kinder$tch_race == 'WHITE')

# 10. create single indicator for Asian or White race 
# code shows two ways to make the same variable
STAR_Kinder$asian_or_white1 <- ifelse(STAR_Kinder$asian==1|STAR_Kinder$white==1,1,0)
STAR_Kinder$asian_or_white2 <- as.numeric(STAR_Kinder$race == 'ASIAN'|STAR_Kinder$race == 'WHITE')

# 11. show that both versions of asian_or_white encode the same information
table(STAR_Kinder$asian_or_white1, STAR_Kinder$asian_or_white2)

# 12. assess how actual class size varies by class type treatment assignment
summary(subset(STAR_Kinder,small_class==1)$actual_size_k)
summary(subset(STAR_Kinder,reg_class==1)$actual_size_k)
summary(subset(STAR_Kinder,regaide_class==1)$actual_size_k)

# 13. assess how SES varies by class type treatment assignment
summary(subset(STAR_Kinder,small_class==1)$freelunch_k)
summary(subset(STAR_Kinder,reg_class==1)$freelunch_k)
summary(subset(STAR_Kinder,regaide_class==1)$freelunch_k)

# 14. estimate the average difference in EOY test scores associated with 
# treatment assignment, controlling for gender, race, and SES
reg_full<-lm(ave_score_k ~ small_class + regaide_class + white + female + freelunch_k + factor(school_id_k), STAR_Kinder)
summary(reg_full)

# 15. estimate the average difference in EOY test scores associated with 
# treatment assignment, controlling for gender, race, and SES
reg_full_w_covars<-lm(ave_score_k ~ small_class + regaide_class + white + female + freelunch_k + factor(school_id_k), STAR_Kinder)
summary(reg_full_w_covars)

# 16. estimate the average difference in EOY test scores associated with 
# treatment assignment for Black students, controlling for gender and SES
reg_black_w_covars<-lm(ave_score_k ~ small_class + regaide_class + female + freelunch_k + factor(school_id_k), subset(STAR_Kinder,black==1))
summary(reg_black_w_covars)

# 17. estimate the average difference in EOY test scores associated with 
# treatment assignment for white students, controlling for gender and SES
reg_white_w_covars<-lm(ave_score_k ~ small_class + regaide_class + female + freelunch_k + factor(school_id_k), subset(STAR_Kinder,white==1))
summary(reg_white_w_covars)

# 18. Output the Project STAR Kindergarten dataset with new variables
write.csv(STAR_Kinder, file = 'STAR_Kinder.csv', row.names = F)


# 17. View STAR_Kinder data
#View(STAR_Kinder)

# 18. separately estimate the average difference in EOY test scores associated 
# withactual class size, teacher experience, and teacher degree status
reg_actual_size<-lm(ave_score_k ~ actual_size_k , STAR_Kinder)
summary(reg_actual_size)

reg_tch_exp<-lm(ave_score_k ~ tch_exp , STAR_Kinder)
summary(reg_tch_exp)

reg_tch_deg<-lm(ave_score_k ~ tch_ma , STAR_Kinder)
summary(reg_tch_deg)

# 19. now estimate the relationship between test scores, teacher exp AND degree status
reg_tch_char<-lm(ave_score_k ~ tch_ma + tch_exp, STAR_Kinder)
summary(reg_tch_char)

# 20. test whether racial concordance between students and teachers is
# associated with higher test scores for black and white students
reg_race_match_black<-lm(ave_score_k ~ tch_black , subset(STAR_Kinder,black==1))
summary(reg_race_match_black)

reg_race_match_white<-lm(ave_score_k ~ tch_white , subset(STAR_Kinder,white==1))
summary(reg_race_match_white)

# 21. Exit Ticket
reg_exit_ticket<-lm(ave_score_k ~ actual_size_k + female + age_in_1985 + freelunch_k + tch_ma + tch_exp + tch_white , STAR_Kinder)
summary(reg_exit_ticket)
