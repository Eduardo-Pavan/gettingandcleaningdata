library(dplyr)
# 1 - Merges the training and the test sets to create one data set
train_data <- cbind(read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE), read.fwf("UCI HAR Dataset/train/X_train.txt", widths = rep_len(16,561)), read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE))
test_data <- cbind(read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE), read.fwf("UCI HAR Dataset/test/X_test.txt", widths = rep_len(16,561)), read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE))
# 4 - Appropriately labels the data set with descriptive variable names. 
F_names = as.vector(rbind(data.frame(V1 = "Subject"), select(read.csv("UCI HAR Dataset/features.txt", sep = "\t", header = FALSE),1), data.frame(V1 = "Label"))[,1])
names(train_data) <- F_names
names(test_data) <- F_names
train_data <- as_tibble(train_data)
test_data <- as_tibble(test_data)
Compl_data <- union(train_data, test_data)

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
Select_data <- select(Compl_data,"Subject", contains("mean"),contains("std"),"Label")

# 3 - Uses descriptive activity names to name the activities in the data set
Act_label <- read.csv("activity_labels.txt", sep = " ", header = FALSE)
names(Act_label) <- c("Label", "Label_Desc")
Select_data <- inner_join(Select_data, Act_label)

# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Sum_data <- Select_data %>% group_by (Label_Desc, Subject) %>% summarize_all(mean)

write.table(Sum_data, row.name = FALSE, file="Output_Step_5.txt")
