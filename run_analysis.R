# "Getting and Cleaning Data"
# Course Project
## 1. Merges the training and test sets to create one data set
## 2. Extracts only mean & std dev measures for each
## 3. Descriptive activity names
## 4. Descriptive labels for data set
## 5. Creates indep tidy data set
###   with avg of each var for each activity and subject

activity_labels <- read.table("activity_labels.txt", header=FALSE)

features <- read.table("features.txt", header=FALSE)

testsubj <- read.table("test/subject_test.txt", header=FALSE, stringsAsFactors = FALSE)
colnames(testsubj) <- "Subject"
testy <- read.table("test/Y_test.txt", header=FALSE, stringsAsFactors = FALSE)
colnames(testy) <- "Activity"
testx <- read.table("test/X_test.txt", header=FALSE, stringsAsFactors = FALSE)
colnames(testx) <- features[,2]

trainsubj <- read.table("train/subject_train.txt", header=FALSE, stringsAsFactors = FALSE)
colnames(trainsubj) <- "Subject"
trainy <- read.table("train/Y_train.txt", header=FALSE, stringsAsFactors = FALSE)
colnames(trainy) <- "Activity"
trainx <- read.table("train/X_train.txt", header=FALSE, stringsAsFactors = FALSE)
colnames(trainx) <- features[,2]

# Merge all test and training data with created variables
mtest <- cbind(TestOrTrain="test", testsubj, testy, testx)
mtrain <- cbind(TestOrTrain="train", trainsubj, trainy, trainx)
m <- rbind(mtest, mtrain)

# Convert subject numbers to factors
m$Subject <- factor(m$Subject)

# Convert activity labels to activity names
m$Activity <- factor(m$Activity)
levels(m$Activity) <- activity_labels[,2]

# Find columns indices of features that are mean/sds
# i.e. with the substring mean() or std()
mean_std_cols <- grep("(mean\\(\\)|std\\(\\))", features[,2], value=FALSE)

# Keep TestOrTrain, Subject, Activity labels, all mean/sds
m <- m[,c(1:3, mean_std_cols+3)]

library(data.table)

# Create data table without Test/Train
dt <- as.data.table(m[,-1])

# Get means of each mean/sd feature
# broken down for each subject then activity
# Then order by subject and activity
dt1 <- dt[order(Subject, Activity), lapply(.SD, mean), by=list(Subject, Activity)]

write.table(dt1, "tidydataset.txt", row.names=FALSE)
