Tidy-Data
=========

This repository contains the following files:
- run_analysis.R: script to create tidy set from set of source data files.
- finalsort.txt: output text file upon running 'run_analysis.R' script.
- README.md: summary of how script functions.
- TidyDataCodeBook.md: codebook of variables used in analysis.

<h2>Script Overview</h2>
The 'run_analysis.R' code will be able to run, and produce the resulting tidy data set, as long as the source Samsung data is in your working directory.  The script performs the following steps:
<ol>
<li>Merges multiple training and the test data sets to create one data set</li>
<li>Extracts only the measurements on the mean and standard deviation for each measurement</li>
<li>Uses descriptive activity labels instead of numbers to describe teh activities in each observation in the data set</li>
<li>Appropriately labels the data set columns with descriptive variable names. </li>
<li>Creates a new, independent tidy data set with the average of each variable for each activity and each subject. </li>
</ol>

<h2>Script Notes</h2>
- Loaded necessary packages/libraries and set working directory
- Loaded 6 remote files from downloaded zip source
- Merged 3 test source files using common 'observation' variable

```
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
```

- Repeated for training set
- Used row bind (rbind) to create combined data set
```
merge_combined = rbind(merge_test, merge_train)
```

- Created vector with column names
- Used grep to eliminate columns not containing either "mean()" or "std()" ... 66 variables match this criteria

- Used series of 'gsub' commands to clean up variable names, and make more easily read
- Converted activity numbers to use of string labels instead to make data more easily read

Used for loop with 'dcast' to aggregate data, creating a resulting row/observation for every permutation of 'subject' and 'activity'
```
for (i in fullnames) {
  temp <- dcast(merge_full,subject+activity~i,mean, value.var=i)
  temp0<-merge(temp0,temp)
}
```

Sorted the data by 'subject' and output data file
```
final.data<-temp0
final.data$subject <- as.numeric(as.character(final.data$subject))
final.sorted<-arrange(final.data,subject)

write.table(final.sorted,"finalsorted.txt",sep=",")
```


