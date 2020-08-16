### Observation: 
the R script was developed in Windows if you use Mac you need change the way to
write the direction of the folders ("/" by "\")


### 1. Download the dataset 

Human Activity Recognition Using Smartphones Data Set (more information in README)

Dataset downloaded and extracted in a folder in the proyect directory
called "UCI HAR Dataset"


### 2. Join files to create Trinning and test data set 
1. features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","variables"))

featuares have 561 variable names asociate to different measures. Info in features_info.txt

2. Training dataset 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$variables)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "acti_code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Trainingset <- cbind(subject_train,x_train,y_train)

x_train contains information about features for training mesuares (7532 obs and 561 features)
y_train contains code number for kind of activities realized in the training mesuares (6 codes)
subject_train contains information about the volunteer that provide the information (30 volunteers)
The Trainingset have 7352 obs and 563 variables(var subject+features(561)+ var code activity)

3. Test dataset

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$variables)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "acti_code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
Testset<-cbind(subject_test,x_test,y_test)

x_test contains information about features for test mesuares (2947 obs and 561 features)
y_train contains code number for kind of activities realized in the test mesuares (6 codes)
subject_train contains information about the volunteer that provide the information (30 volunteers)
The Testset have 2947 obs and 563 variables(var subject+features(561)+ var code activity)

4. Merge dataset
dataset<-rbind(Trainingset,Testset)

it is posible do the merge because both previus dataset have the same variables
th emerge data set have 10299 (7352+2947) and 563 variables


### 3. Extracts only the measurements on the mean and standard deviation for each measurement.
1. Use dplyr 
library(dplyr)
2. subset with variables that contains the  string "mean" "std"
FocusData <- dataset %>% select(subject, acti_code, contains("mean"), contains("std"))

FocuData have 89 variables (subject, acti_code +activity and 86 features of mean and standar desviation of different measures)


### 4. Uses descriptive activity names to name the activities in the data set
The activity_labels.txt have 2 variables acti_code (activity code) and activity (activity labels) 

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("acti_code", "activity"))
FocusData<- merge(FocusData, activity_labels, by="acti_code")
table(FocusData$activity)


### 5. Appropriately labels the data set with descriptive variable names.

features_info.txt have information about the labels for features  

names(FocusData)<-gsub("tBody", "TimeBody", names(FocusData))
names(FocusData)<-gsub("Acc", "Acceleration", names(FocusData))
names(FocusData)<-gsub("-mean()", "Mean", names(FocusData), ignore.case = TRUE)
...

### 6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyDataSet <- FocusData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)

the TidyDataSet is a table of [180 x 89]
180 obs = 30 subject x 6 activities
89 variables= subject+ acti_code +activity + 86 features of mean and standar desviation of
different measures

