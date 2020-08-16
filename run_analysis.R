#This is a Peer-graded Assignment of Getting and Cleaning Data Course 
#The The purpose of this project is develop abilies to collect, work with, and clean a data set. 

### Download file dataset

fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="dataset_assigment.zip", method="curl")



### 1. Merges the training and the test sets to create one data set.

#training data set
#The dataset_assigment.zip have differents folders and text files

#variables names (561)
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","variables"))

#Training dataset 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$variables)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "acti_code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Trainingset <- cbind(subject_train,x_train,y_train)

#Test dataset 
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$variables)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "acti_code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
Testset<-cbind(subject_test,x_test,y_test)

#mergedataset
dataset<-rbind(Trainingset,Testset)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)

FocusData <- dataset %>% select(subject, acti_code, contains("mean"), contains("std"))


### 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("acti_code", "activity"))
FocusData<- merge(FocusData,activity_labels, by="acti_code")
table(FocusData$activity)

### 4. Appropriately labels the data set with descriptive variable names.

###Obs: info en features_info. 
### A try to put  appropriately labels to almost each variable 

names(FocusData)<-gsub("tBody", "TimeBody", names(FocusData))
names(FocusData)<-gsub("Acc", "Acceleration", names(FocusData))
names(FocusData)<-gsub("-mean()", "Mean", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-std()", "STD.", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-mad", "MAD", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-max", "Max.", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-min", "Min.", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-sma", "SMA.", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-energy", "Energy", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-iqr", "InterquartileRange ", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-entropy", "SEntropy", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-arCoeff", "ArCoeff", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-correlation", "Correlation", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("-freq()", "Frequency", names(FocusData), ignore.case = TRUE)
names(FocusData)<-gsub("angle", "Angle", names(FocusData))
names(FocusData)<-gsub("tGravityAcc", "GravityAceleration", names(FocusData))
names(FocusData)<-gsub("Gyro", "Gyroscope", names(FocusData))
names(FocusData)<-gsub("BodyBody", "Body", names(FocusData))
names(FocusData)<-gsub("Mag", "Magnitude", names(FocusData))
names(FocusData)<-gsub("f", "Frequency", names(FocusData))

### 5. From the data set in step 4, creates a second, 
###independent tidy data set with the average of each variable
###for each activity and each subject.

### the dataset should have 180 obs (30 subject x 6 activities)
TidyDataSet <- FocusData %>% group_by(subject, activity) %>% summarise_all(funs(mean))

str(TidyDataSet )### It is ok [180 x 89]

write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)




