# Tidy Data version of Smartphones Dataset

To meet the terms of the project as assigned, the run_analysis.R script reads in various files from the Smartphone dataset, lables and condenses the available fields.  A complete description of the data variables in the final dataset is available in the accompanying codebook (run_analysis_codebook.txt).
In detail, the script does the following:

* Calls some required libraries
* Sets the working directory (assumes the required Samsung data is in a subdirectory of the working directory)
* Reads in the dataset files "features.txt" and "activity_lables.txt"
* Reads in the test files "y_test.txt", "x_test.txt", and "subject_test.txt"
* Reads in the train files "y_train.txt", "x_train.txt", and "subject_train.txt"
* Adds the variable names from "features.txt" as column names to x_test and x_train
* Greps to find all column names that contain "mean" or "std"
* Creates a narrow version of x_test with just the mean and std columns
* Translates the integer activity codes in y_test to activity names using activity_lables
* Appends the activity names and subject IDs (from subject_train) to the narrow version of x_test
* Adds meaningful names for activities and subjects
* Repeats the prior four steps with the train data set
* Appends the narrowed test and train sets together

From this tidy data set, a final independent tidy data set is created with the average of each mean or std variable for each activity and subject.  

* Condenses (melts) all the variables into a single column (very narrow, long data set)
* Calculates the mean for each activity and subject for every variable using dcast
* Writes a tab deliniated .txt file to the working directory
  
This is a verbose script and will print to the screen a few status messages to inform the user of the script progress.

Example:

> File loads complete

> Dimensions of tidy data set:

> 10299 rows, 88 columns

> Dimensions of variable means by Activity and Subject_ID:

> 180 rows, 88 columns

> Write to file Variable_Means_by_Activity&Subject.txt complete