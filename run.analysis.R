library(plyr)
library(dplyr)
library(data.table)
fileurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

#Loading data

activity_L <- read.table("activity_labels.txt")
features <- read.table("features.txt")
text_X <- read.table("./test/X_test.txt")
test_Y <- read.table("./test/Y_test.txt")
subject_Test <- read.table("./test/subject_test.txt")
train_X <- read.table("./train/X_train.txt")
train_Y <- read.table("./train/Y_train.txt")
subject_Train <- read.table("./train/subject_train.txt")



#1.Merges the training and the test sets to create one data set.
###############################################################
Temp_X <- rbind(train_X,text_X)
Temp_Y <- rbind(train_Y,test_Y)
Temp_subject <- rbind(subject_Train, subject_Test)
Merged_Set <- cbind(Temp_subject, Temp_X, Temp_Y)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
##########################################################################################
Mean_std <- grep("mean\\(\\)|std\\(\\)", features[,2])
Mean_std
Temp_X <- Temp_X [ ,Mean_std]
head(Temp_X)

#3.Uses descriptive activity names to name the activities in the data set
#########################################################################
Temp_Y[, 1] <- activity_L[Temp_Y[, 1], 2]
head(Temp_Y)

#4.Appropriately labels the data set with descriptive variable names
####################################################################
names <- features[Mean_std,2] ## getting names for variables
names(Temp_X)<-names ## updating colNames for new dataset
names(Temp_subject)<-"SubjectID"
names(Temp_Y)<-"Activity"
TidyData <- cbind(Temp_subject, Temp_Y, Temp_X)
head(TidyData[,c(1:4)])

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#################################################################################################################################################
TidyData<-(data.table(TidyData))

TidyData_2 <- TidyData[, lapply(.SD, mean), by = 'SubjectID,Activity']

dim(TidyData_2)
write.table(TidyData_2, file = "Tidy.txt", row.names = FALSE)
head(TidyData_2[order(SubjectID)][,c(1:4), with = FALSE],12) 
TidyData_2 <- (data.table(TidyData_2))

