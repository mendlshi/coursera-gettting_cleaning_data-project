library(data.table)
library(dplyr)
library(tidyr)


# Read test and training files
features = read.table("UCI HAR Dataset/features.txt")[,2]

# Appropriately labels the data set with descriptive variable names
# Extracts only the measurements on the mean and standard deviation for each measurement
test_data = data.table(read.table("UCI HAR Dataset/test/X_test.txt", col.names=features)) %>%
  select(matches("(mean|std)\\."))
train_data = data.table(read.table("UCI HAR Dataset/train/X_train.txt", col.names=features)) %>%
  select(matches("(mean|std)\\."))

# Add Subject and Activity columns
features = read.table("UCI HAR Dataset/features.txt")[,2]

# Read activity names
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt")

# Uses descriptive activity names to name the activities in the data set

# Read activity association files
test_activities = read.table("UCI HAR Dataset/test/y_test.txt")
train_activities = readLines("UCI HAR Dataset/train/y_train.txt")

# Add column for activity name factors
test_data = mutate(test_data, activity=activity_labels[test_activities[[1]],][,2])
train_data = mutate(train_data, activity=activity_labels[train_activities[[1]],][,2])

# Read subject association file
test_subjects = readLines("UCI HAR Dataset/test/subject_test.txt")
train_subjects = readLines("UCI HAR Dataset/train/subject_train.txt")

# Add column for subject IDs
test_data = mutate(test_data, subject=test_subjects)
train_data = mutate(train_data, subject=train_subjects)

# Merges the training and the test sets to create one data set
all_data = rbind(test_data, train_data) %>%
  arrange(activity, subject)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Aggregate by activity and subject with means
mean_sensor_data = aggregate(. ~ activity + subject, all_data, mean)

# Adjust variables names to be more descriptive and accurate
names(mean_sensor_data) = paste("Mean", names(mean_sensor_data)[-1:-2])

print(mean_sensor_data)
