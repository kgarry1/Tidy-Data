## load plyr package
## library plyr package
install.packages("plyr")
install.packages("reshape2")
library(plyr)
library(reshape2)

setwd("C:/Online Courses/Data Science/dev/week3_CleanData")

## load 6 files, 3 from training set, 3 from test set
## Assumes source files were downloaded to working directory and unzipped

subject_test <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/test/subject_test.txt", quote="\"")
X_test <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/test/X_test.txt", quote="\"")
y_test <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/test/y_test.txt", quote="\"")
subject_train <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/train/subject_train.txt", quote="\"")
X_train <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/train/X_train.txt", quote="\"")
y_train <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/train/y_train.txt", quote="\"")
features <- read.table("C:/Online Courses/Data Science/dev/week3_CleanData/features.txt", quote="\"")

## Create merged set of df for all test-related data
subject_test$obsnum <- rownames(subject_test)
subject_test<-subject_test[c(2,1)]
colnames(subject_test)[2] <- "subject"

y_test$obsnum<-rownames(y_test)
y_test<-y_test[c(2,1)]
colnames(y_test)[2] <- "activity"

X_test$obsnum<-rownames(X_test)
X_test<-X_test[c(562,1:561)]

testList = list(subject_test,y_test,X_test)
merge_test<-join_all(testList)

## Create merged set of df for all training-related data
subject_train$obsnum <- rownames(subject_train)
subject_train<-subject_train[c(2,1)]
colnames(subject_train)[2] <- "subject"

y_train$obsnum<-rownames(y_train)
y_train<-y_train[c(2,1)]
colnames(y_train)[2] <- "activity"

X_train$obsnum<-rownames(X_train)
X_train<-X_train[c(562,1:561)]

trainList = list(subject_train,y_train,X_train)
merge_train<-join_all(trainList)

## append df2 onto df1 to create combined data set (using rbind)
merge_combined = rbind(merge_test, merge_train)


## assign feature names to column headings of combined data set
colvector<-as.vector(features$V2)
colvector<-c("obsnum","subject","activity",colvector)
colnames(merge_combined) <- colvector

## remove columns not containing mean(), std()
merge_combined_mean<-merge_combined[, grep("mean\\(",names(merge_combined))]
merge_combined_std<-merge_combined[, grep("std\\(",names(merge_combined))]
merge_combined_base<-merge_combined[,c(1:3)]

merge_combined_mean$obsnum<-rownames(merge_combined_mean)
merge_combined_mean<-merge_combined_mean[c(34,1:33)]
merge_combined_std$obsnum<-rownames(merge_combined_std)
merge_combined_std<-merge_combined_std[c(34,1:33)]

## remerge trimmed data sets
mergeList = list(merge_combined_base,merge_combined_mean,merge_combined_std)
merge_full <-join_all(mergeList)

## rename columns to simplify naming - more user friendly - using gsub
names(merge_full) <- gsub("tBody", "t.Body.", names(merge_full))
names(merge_full) <- gsub("tGravity", "t.Gravity.", names(merge_full))
names(merge_full) <- gsub("fBody", "f.Body.", names(merge_full))
names(merge_full) <- gsub("-", ".", names(merge_full))
names(merge_full) <- gsub("\\(", "", names(merge_full))
names(merge_full) <- gsub("\\)", "", names(merge_full))
names(merge_full) <- gsub(",", ".", names(merge_full))

## rename activity numbers to simplify naming - more user friendly
merge_full$activity[which(merge_full$activity==1)]<-"WALKING"
merge_full$activity[which(merge_full$activity==2)]<-"WALKING UPSTAIRS"
merge_full$activity[which(merge_full$activity==3)]<-"WALKING DOWNSTAIRS"
merge_full$activity[which(merge_full$activity==4)]<-"SITTING"
merge_full$activity[which(merge_full$activity==5)]<-"STANDING"
merge_full$activity[which(merge_full$activity==6)]<-"LAYING"

##
## Need to loop through something like this for every column name:
## creates new dataframe with 180 obs (30 subjects x 6 activities), and mean of 1 variable for each permutation
fullnames<-colnames(merge_full)
fullnames<-fullnames[c(4:69)]

temp0<-aggregate(t.Body.Acc.mean.X~subject+activity,merge_full,mean)
temp0<-test0[c(1:2)]
templist <- vector(mode="character", length=0)

for (i in fullnames) {
  temp <- dcast(merge_full,subject+activity~i,mean, value.var=i)
  temp0<-merge(temp0,temp)
}

## final, tidy data set

final.data<-temp0
final.data$subject <- as.numeric(as.character(final.data$subject))
final.sorted<-arrange(final.data,subject)

write.table(final.sorted,"finalsorted.txt",sep=",")


