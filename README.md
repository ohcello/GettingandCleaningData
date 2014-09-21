GettingandCleaningData
======================

##Goal of the Project

To create one R script called run_analysis.R that does the following: 
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set created through the previous steps, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Files

For reading in files, it is assumed all files are in the working directory. 

####Anlysis files

- run_analysis.R 
- new_features.txt

####Data/input files

- Subject_train.txt 
- X_train.txt 
- y_train.txt 
- Subject_test.txt 
- X_test.txt
- y_test.txt
- features.txt
- labels.txt

####Output file
- gettingcleaningdata.txt (can be read back into R using read.table("gettingcleaningdata.txt", header=TRUE) )

####Explanatory file
- code_book.txt

####Original reference files
- original_code_book.txt 
- original_README.txt 
- The original data files can be downloaded [here] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
- More information about the original data can be found [here] 
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

##Usage

The run_analysis.R code performs the following tasks:
- reads in an initial set of files: features.txt, labels.txt, Subject_train.txt, X_train.txt, y_train.txt, Subject_test.txt, X_test.txt, y_test.txt
- combines the data in the initial set of files into a single data frame 
- removes columns that do not contain values for the mean or standard deviation 
- attaches descriptive names to the remaining variables by reading in new_features.txt and renaming the columns
- summarizes the data frame to produce one mean value per variable per subject per activity 
- melts the data frame into a tidy, long data format 
- writes the tidy data set to a file called gettingcleaningdata.txt 
