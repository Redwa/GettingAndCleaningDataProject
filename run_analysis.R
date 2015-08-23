# Getting and Cleaning Data : Course Project


library(reshape2) 
 
## 1- Naming the zip file

filename <- "getdata_projectfiles_UCI HAR Dataset.zip" 


## 2- Download and unzip the dataset: 
if (!file.exists(filename)){ 
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 

download.file(fileURL, filename, method="curl") 
 }   
 if (!file.exists("UCI HAR Dataset")) {  
   unzip(filename)  
 } 
 


# 3- Load activity labels + features 

activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
activity_Labels[,2] <- as.character(activity_Labels[,2]) 
features <- read.table("UCI HAR Dataset/features.txt") 
features[,2] <- as.character(features[,2]) 
 

# 4- Extract only the data on mean and standard deviation 
MeanAndStdWanted <- grep(".*mean.*|.*std.*", features[,2]) 
MeanAndStdWanted.names <- features[MeanAndStdWanted,2] 
MeanAndStdWanted.names = gsub('-mean', 'Mean', MeanAndStdWanted.names) 
MeanAndStdWanted.names = gsub('-std', 'Std', MeanAndStdWanted.names) 
MeanAndStdWanted.names <- gsub('[-()]', '', MeanAndStdWanted.names) 
 

 

# 5- Load the datasets 
train <- read.table("UCI HAR Dataset/train/X_train.txt")[MeanAndStdWanted] 
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt") 
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") 
train <- cbind(trainSubjects, trainActivities, train) 
 

test <- read.table("UCI HAR Dataset/test/X_test.txt")[MeanAndStdWanted] 
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt") 
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 

 test <- cbind(testSubjects, testActivities, test) 
 

# 6- merge datasets and add labels 
 allData <- rbind(train, test) 
 colnames(allData) <- c("subject", "activity", MeanAndStdWanted.names) 
 

# 7- turn activities & subjects into factors 
 allData$activity <- factor(allData$activity, levels = activity_Labels[,1], labels = activity_Labels[,2]) 
 allData$subject <- as.factor(allData$subject) 
 
# 8- Mean of all Data: Create tidy dataset
 tidydata <- melt(allData, id = c("subject", "activity")) 
 tidydata <- dcast(tidydata, subject + activity ~ variable, mean) 
 
 View(tidydata)

# 9- convert tidydata to "tidy.txt"
 write.table(tidydata, "tidy.txt", row.names = FALSE, quote = FALSE) 

