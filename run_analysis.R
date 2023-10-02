library(dplyr)
library(data.table)

#Downloading the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("Project.zip")) {
  download.file(url,"Project.zip", method = "curl")

}

#Unzipping the downloaded data on a new directory
unzip("Project.zip", exdir="CourseProject")


#Creating a data drame for each file in the zip
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Number","Functions"))
functions <- features$Functions
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = functions)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = functions)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject_num")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject_num")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="Activity")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="Activity")

#Merges the training and the test sets to create one data set
data <- rbind(X_test, X_train)
labels <- rbind(y_test,y_train)
subject <- rbind(subject_test, subject_train)
merged <- cbind(subject, labels, data)

#Extracts only the measurements on the mean and standard deviation for each measurement
measurements <- select(merged, Subject_num, Activity, matches("mean()|std()"))

#Uses descriptive activity names to name the activities in the data set
measurements[measurements$Activity == 1,2] <- "Walking"
measurements[measurements$Activity == 2,2] <- "Walking_upstairs"
measurements[measurements$Activity == 3,2] <- "Walking_downstairs"
measurements[measurements$Activity == 4,2] <- "Sitting"
measurements[measurements$Activity == 5,2] <- "Standing"
measurements[measurements$Activity == 6,2] <- "Laying"



#Appropriately labels the data set with descriptive variable names. 
names(measurements) <- gsub("Acc","Acceleration", names(measurements))
names(measurements) <- gsub("Gyro","Gyroscope", names(measurements))
names(measurements) <- gsub("Mag","Magnitude", names(measurements))
names(measurements) <- gsub("^t","Time_", names(measurements))
names(measurements) <- gsub("^f","Frequency_", names(measurements))
names(measurements) <- gsub("BodyBody","Body", names(measurements))
names(measurements) <- gsub("mean()","Mean", names(measurements))
names(measurements) <- gsub("std()","Standard_dev", names(measurements))
names(measurements) <- gsub("gravity","Gravity", names(measurements))
names(measurements) <- gsub("angle","Angle", names(measurements))
names(measurements) <- gsub("MeanFreq()","Mean_Frequency", names(measurements))
names(measurements) <- gsub("Angle.t","Angle_Time", names(measurements))

tidy_m <- copy(measurements)
#create a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_m <- tidy_m %>%
  group_by(Activity, Subject_num) %>%
  summarize_all(mean)


write.csv(tidy_m, file="TidyDataSet.csv")
write.table(tidy_m, file="TidyDataSet.txt")
