run_analysis <- function() {

## Create one R script called run_analysis.R that does the following: 
## 1. Merge the training and the test sets to create one data set.
## 2. Extract only the measurements on the mean and standard deviation 
##    for each measurement. 
## 3. Use descriptive activity names to name the activities in the data set
## 4. Appropriately label the data set with descriptive variable names. 
## 5. From the data set in step 4, create a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.
  
  library(plyr)
  library(reshape2)
  
  ##  set working directory 
  setwd("C:/Users/csnell/Desktop/Class/DataCleaning")

  ##  check if file exists
  if (!file.exists("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")) {
    message("File not found")
  }

  ## load dataset files
  features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
  act_lables <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

  ##  load test
  y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
  x_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
  subj_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

  ##  load train
  y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
  x_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
  subj_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

  message("File loads complete")

  ## add meaningful names to x measures
  names(x_test) <- features$V2
  names(x_train) <- features$V2

  ## find mean and std measures, then create narrow data table
  mean_cols <- grep('mean', features$V2, ignore.case=TRUE, value=TRUE)
  std_cols <- grep('std', features$V2, ignore.case=TRUE, value=TRUE)
  meanstd_cols <- c(mean_cols, std_cols)

  narrow_x_test <- x_test[, meanstd_cols]

  ## translate activity number to activity name
  y_act_test <- join(y_test, act_lables, by="V1")

  ## append activity and subject to measures and rename columns
  narrow_x_test <- cbind(y_act_test$V2, narrow_x_test)
  narrow_x_test <- cbind(subj_test$V1, narrow_x_test)
  narrow_x_test <- rename(narrow_x_test, c("subj_test$V1" ="Subject_ID"))
  narrow_x_test <- rename(narrow_x_test, c("y_act_test$V2" ="Activity"))
  
  ## repeat for train data  
  narrow_x_train <- x_train[, meanstd_cols]
  
  ## translate activity number to activity name
  y_act_train <- join(y_train, act_lables, by="V1")

  ## append activity and subject to measures and rename columns
  narrow_x_train <- cbind(y_act_train$V2, narrow_x_train)
  narrow_x_train <- cbind(subj_train$V1, narrow_x_train)
  narrow_x_train <- rename(narrow_x_train, c("subj_train$V1" ="Subject_ID"))
  narrow_x_train <- rename(narrow_x_train, c("y_act_train$V2" ="Activity"))
  
  ## append the test and train data sets
  tidy_x <- rbind(narrow_x_train, narrow_x_test)
  message("Dimensions of tidy data set:")
  message(nrow(tidy_x), " rows, ", ncol(tidy_x), " columns")

  ## 5. From the data set in step 4, create a second, independent tidy data 
  ##    set with the average of each variable for each activity and each subject.

  tidy_melt <- melt(tidy_x, id=c("Activity", "Subject_ID"), 
                    measure.vars=meanstd_cols)
  tidy_x_mean <- dcast(tidy_melt, Activity + Subject_ID ~ variable, mean)
  message("Dimensions of variable means by Activity and Subject_ID:")
  message(nrow(tidy_x_mean), " rows, ", ncol(tidy_x_mean), " columns")
  
  ## write .csv file with result
  ## write.csv(tidy_x_mean, "./Variable_Means_by_Activity&Subject.csv")
  ## message("Write to file Variable_Means_by_Activity&Subject.csv complete")

  ## write .txt file with result
  write.table(tidy_x_mean, "./Variable_Means_by_Activity&Subject.txt", 
              row.name=FALSE, sep="\t")
  message("Write to file Variable_Means_by_Activity&Subject.txt complete")
}