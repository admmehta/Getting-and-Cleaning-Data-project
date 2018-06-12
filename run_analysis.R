
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c("activityId", "activityLabel")
features <- read.table("UCI HAR Dataset/features.txt",as.is=TRUE)

#read the training data
trainingSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainingValues <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingActivity <- read.table("UCI HAR Dataset/train/y_train.txt")

# read the testing data
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testValues <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivity <- read.table("UCI HAR Dataset/test/y_test.txt")

#Merge the train and data sheets
humanActivity <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity))
colnames(humanActivity) <- c("subject", features[, 2], "activity")

# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

# keep data in these columns only
humanActivity <- humanActivity[, columnsToKeep]

# replace activity values with named factor levels
humanActivity$activity <- factor(humanActivity$activity, 
levels = activity[, 1], labels = activity[, 2])

# get column names
humanActivityCols <- colnames(humanActivity)

# remove special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expand abbreviations and clean up names
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
colnames(humanActivity) <- humanActivityCols

Data2<-aggregate(. ~subject + activity, humanActivity, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)