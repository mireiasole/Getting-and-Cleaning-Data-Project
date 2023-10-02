# Code book for Project: Getting and Cleaning Data

The data for the project can be obtained from this link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, which is originally found in the following page: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. It's a "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."

The scrit/code found in run_analysis R does the following: 

## Download and load
1. Loads the necessary packages to the console (dplry and data.table)
2. Assigns the URL of the page with the dataset to the variable url
3. If a file called Project.zip doesn't already exist in the working directory, it downloads the data from the url into this newly created file.
4. Unzips the downloaded data into a new directory called CourseProject

## Create a data frame for each needed file in the zip, assigning the necessary column names to each one
- features: Read from features.txt, contains the list of all features
- functions: Selects the Functions column from features data frame for posterior assignment of column names
- X_test: Read from X_test.txt in the test subfolder, contains the test set data
- X_train: Read from X_train.txt in the train subfolder, contains the training set data
- subject_test: Read from subject_test in the test subfolder, contains the subject identifier for each person who performed the activity
- subject_train: Read from subject_train in the train subfolder, contains the subject identifier for the train set
- y_test: Read from y_test.txt in the test subfolder, contains the test set labels
- y_train: Read from y_train.txt in the train subfolder, contains the train set labels

## Merge data sets
- data: Binded rows of the train set and test set through rbind()
- labels: Binded rows of the train labels and test labels through rbind()
- subject: Binded rows of the train set subject info and test set subject info through rbind()
- merged: Binded columns of data, labels and subject through cbind()

## Extract the measurements of mean and standard deviation from each measure
- measurements: New data frame created using the select function on the merged dataframe to access the columns describing the subject number, the activity and any column that matches either the "mean()" string or the "std() string

## Name activities in the data set
1. Replace all instances where the column Activity on the measurements data frame is equal to the nummbers 1 to 6 with their corresponding activity name string (Walking for 1, Walking_upstairs for 2, Walking_downstairs for 3, Sitting for 4, Standing for 5, Laying for 6) through reassignment

## Label the data set with descriptive variable names
1. In the names of the measurements data frame, find the strings that match the shown string and replace them for the following string, using gsub()
- Replace Acc with Acceleration
- Replace Gyro with Gyroscope
- Replace Mag with Magnitude
- Replace t at the beginning of the line with Time_
- Replace f at the beginning of the line with Frequency_
- Replace BodyBody with Body
- Replace mean() with Mean
- Replace std() with Standard_dev
- Replace gravity with Gravity
- Replace angle with Angle (so all variable names are capitalised and there's consistency)
- Relace MeanFreq() with Mean_Frequency
- Relace Angle.t with Angle_Time

## Create a new, independent tidy data set with the averages
1. tidy_m: Independent copy of the measurements data frame
2. Group the tidy_m data frame by activity and subject number columns using group_by()
3. Summarize every variable in the data set by getting its mean with summarize_all()


## Save data set
1. Use write.csv to save tidy_m as a csv file
2. Use write.table to save tidy_mas a txt file
