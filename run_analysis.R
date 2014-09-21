
##install.packages("dplyr")
library("dplyr")

##install.packages ("reshape2")
library("reshape2")

###LOAD IN ALL SOURCE DATA
activity_labels <- read.table("activity_labels.txt",header=FALSE)
features <- read.table("features.txt",header=FALSE)
xtrain <- read.table("train/X_train.txt",header=FALSE)
ytrain <- read.table("train/y_train.txt",header=FALSE)
xtest <- read.table("test/X_test.txt",header=FALSE)
ytest <- read.table("test/y_test.txt",header=FALSE)
subject_test <- read.table("test/subject_test.txt",header=FALSE)
subject_train <- read.table("train/subject_train.txt",header=FALSE)

### PREP FEATURES DATA TO BE BOUND TO THE TRAIN/TEST/SUBJECT DATA ONCE BOUND
features_inverted <- t(features)
features_inverted_singlerow <- features_inverted[-1,]
features_inverted_subject <- append(features_inverted_singlerow, "ActivityNumber")
features_inverted_subject_activity <- append(features_inverted_subject, "Subject")

### BIND TRAIN/TEST/SUBJECT DATA
x_all <- rbind(xtrain,xtest)
y_all <- rbind(ytrain,ytest)
subject_all <- rbind(subject_train,subject_test)
x_y_subject_all <- cbind (x_all,y_all,subject_all)

###ADD FEATURES ROW AS COLUMNS NAMES TO TRAIN/TEST/SUBJECT DATA
colnames(x_y_subject_all) <- paste(features_inverted_subject_activity)

###ADD COLUMN NAMES TO ACTIVITY LABELS SO THEY CAN BE LEFT JOINED TO MAIN DATA FRAME
colnames(activity_labels) <- c("ActivityNumber","Activity")

subset_x_y_subject <- x_y_subject_all[,]
fulldata <- merge(subset_x_y_subject, activity_labels,all.x=TRUE)


std_mean_only <- select(fulldata,contains('-std|-mean|Subject|Activity'))

std_mean_only_headers_revised <- colnames(std_mean_only)

### REPLACE EXISTING HEADER NAMES WITH DESCRIPTIVE HEADER NAMES IN REVISED ARRAY
std_mean_only_headers_revised <- gsub("tBody", "Time_Body_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("tGravity", "Time_Gravity_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("fBody", "Frequency_Body_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("Acc", "Accelerometer_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("Gyro", "Gyroscope_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("Mag", "Magnitude_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("Jerk", "JerkSignals_", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("-mean", "Average", std_mean_only_headers_revised)
std_mean_only_headers_revised <- gsub("-std", "StandardDeviation", std_mean_only_headers_revised)

### INSERT NEW DESCRIPTIVE HEADER NAMES TO SUBSET DATA FRAME
colnames(std_mean_only) <- paste(std_mean_only_headers_revised)

# remove activity id column as it is no longer needed
std_mean_only_noActNum <- select(std_mean_only, -ActivityNumber)

### MELT AND DCAST DATA - BY SUBJECT/ACTIVITY TO CALCULATE MEAN
new_names_vec <- std_mean_only_headers_revised[2:80]

### group the data by activity and subject id
std_mean_only_grouped <- group_by(std_mean_only_noActNum, Activity, Subject)
# summarize the data so each of the variable columns is collapsed to the mean
std_mean_only_summarized <- summarise_each(std_mean_only_grouped, funs(mean))

#### melt data against Subject and Activity
std_mean_only_melted <- melt(std_mean_only_summarized, id.vars=c("Subject","Activity"), measure.vars= new_names_vec)
std_mean_only_meltednoNA <- std_mean_only_melted[!is.na(std_mean_only_melted$Activity),]

### Write data
write.table(std_mean_only_meltednoNA, file = "./gettingcleaningdata.txt", row.names=FALSE,sep=",")

write.table(fulldata, file = "./fulldata.txt", row.names=FALSE,sep=",")




